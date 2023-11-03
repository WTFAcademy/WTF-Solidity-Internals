---
title: 02. 映射和动态数组的存储布局
tags:
  - solidity
  - storage
  - storage layout
  - mapping
  - dynamic array
  - state variables
---

# WTF Solidity内部标准: 02. 映射和动态数组的存储布局

《WTF Solidity内部标准》教程将介绍Solidity智能合约中的存储布局，内存布局，以及ABI编码规则，帮助大家理解Solidity的内部规则。

推特：[@0xAA_Science](https://twitter.com/0xAA_Science)

社区：[Discord](https://discord.gg/5akcruXrsk)｜[微信群](https://docs.google.com/forms/d/e/1FAIpQLSe4KGT8Sh6sJ7hedQRuIYirOoZK_85miz3dw7vA1-YjodgJ-A/viewform?usp=sf_link)｜[官网 wtf.academy](https://wtf.academy)

所有代码和教程开源在github: [github.com/AmazingAng/WTF-Solidity-Internals](https://github.com/AmazingAng/WTF-Solidity-Internals)

-----

这一讲，我们将介绍映射和动态数组类型的状态变量是如何在合约中存储的。

## 映射和动态数组

由于映射和动态数组的大小是可以改变的，不能事先预知，因此，它们有着特别的存储布局。

## 映射

在基础存储布局规则中，映射只占用`32`个字节。假设一个映射被存在了槽`p`，这个槽仅用作占位，不存储任何内容，保持空（`0`）的状态。而映射中键`k`对应的值会被存储在由Keccak哈希决定的槽中，计算方法为`keccak256(h(k) . p)`， 其中`.`是连接符，`h`是一个函数，根据键的类型应用于键。

- 对于值类型，函数`h`将与在内存中存储值的相同方式来将值填充为`32`字节。比如`uint8`类型的`1`会被填充为`0000000000000000000000000000000000000000000000000000000000000001`。

- 对于字符串和字节数组，`h(k)`只是未填充的数据。

我们以`MappingStorage`合约为例，其中声明了两个状态变量，一个为`mapping(uint => uint)`类型，另一个为`uint256`类型。

```solidity
contract MappingStorage {
    mapping(uint => uint) public a;
    uint256 public b = 5;

    constructor(){
        a[0] = 1;
        a[1] = 2;
    }

    function getHash(bytes memory bb) public pure returns(bytes32){
        return keccak256(bb);
    }
}
```

你可以使用下面的命令打印合约的存储布局：

```shell
forge inspect src/02_MappingStorage.sol:MappingStorage storage-layout --pretty
```

可以看到，映射`a`被存在了Slot 0，而变量`b`被存在了Slot 1。

| Name | Type                        | Slot | Offset | Bytes | Contract                                 |
|------|-----------------------------|------|--------|-------|------------------------------------------|
| a    | mapping(uint256 => uint256) | 0    | 0      | 32    | src/02_MappingStorage.sol:MappingStorage |
| b    | uint256                     | 1    | 0      | 32    | src/02_MappingStorage.sol:MappingStorage |

其实这里`foundry`并没有将映射的存储布局显示完全，没有给出`a[0]`和`a[1]`的位置。其实，它们分别在：

```
a[0]: 0xad3228b676f7d3cd4284a5443f17f1962b36e491b30a40b2405849e597ba5fb5
a[1]: 0xada5013122d395ba3c54772283fb069b10426056ef8ca54750cb9bb552a59e7d
```

它们分别由：

```
keccak256(0x00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000)
```

和

```
keccak256(0x00000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000)
```

计算而得，你可以把它们输入`getHash()`函数，并检查输出的值。

## 动态数组

与映射类似，动态数组的成员也会被保存在由Keccak哈希决定的槽中。在基础存储布局规则中，动态数组只占用`32`个字节。假设一个动态数组被存在了槽`p`，这个槽仅用于保存动态数组当前的长度（字节数组和字符串例外）。而数组的数据从`keccak256(p)`开始保存，排列方式与静态大小的阵列数据相同： 一个元素接着一个元素，如果元素的长度不超过16字节，就有可能共享存储槽。

我们以`ArrayStorage`合约为例，其中声明了两个状态变量，一个为`uint128`类型，另一个为`uint128[]`类型。

```solidity
contract ArrayStorage {
    uint128 public a = 9;
    uint128[] public b;

    constructor(){
        b.push(10);
        b.push(11);
        b.push(12);
    }
    
    function getHash(bytes memory bb) public pure returns(bytes32){
        return keccak256(bb);
    }
}
```

这个合约的存储布局如下所示：

| Name | Slot |
|------|-----------------------------|
| a    | 0 |
| b.length    | 1 |
| b[0] | 0xb10e2d527612073b26eecdfd717e6a320cf44b4afac2b0732d9fcbe2b7fa0cf6 |
| b[1] | 0xb10e2d527612073b26eecdfd717e6a320cf44b4afac2b0732d9fcbe2b7fa0cf6 |
| b[2] | 0xb10e2d527612073b26eecdfd717e6a320cf44b4afac2b0732d9fcbe2b7fa0cf7 |

其中`b[0]`和`b[1]`共用一个存储槽`keccak(1)`，`b[2]`保存在`keccak(1)+1`。

你可以使用`getHash()`（需要把参数填充到`32`字节），或者下面的命令行验证：

```shell
cast keccak 0x0000000000000000000000000000000000000000000000000000000000000001
# output
# 0xb10e2d527612073b26eecdfd717e6a320cf44b4afac2b0732d9fcbe2b7fa0cf6
```

## 总结

这一讲，我们介绍了映射和动态数组的存储布局。与值类型不同，映射和动态数组的长度不能事先预知，因此使用的存储槽由哈希决定。
