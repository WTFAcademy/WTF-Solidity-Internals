---
title: 01. 基础存储布局
tags:
  - solidity
  - storage
  - storage layout
  - state variables
---

# WTF Solidity内部标准: 01. 基础存储布局

《WTF Solidity内部标准》教程将介绍Solidity智能合约中的存储布局，内存布局，以及ABI编码规则，帮助大家理解Solidity的内部规则。

推特：[@0xAA_Science](https://twitter.com/0xAA_Science)

社区：[Discord](https://discord.gg/5akcruXrsk)｜[微信群](https://docs.google.com/forms/d/e/1FAIpQLSe4KGT8Sh6sJ7hedQRuIYirOoZK_85miz3dw7vA1-YjodgJ-A/viewform?usp=sf_link)｜[官网 wtf.academy](https://wtf.academy)

所有代码和教程开源在github: [github.com/AmazingAng/WTF-Solidity-Internals](https://github.com/AmazingAng/WTF-Solidity-Internals)

-----

在WTF Solidity内部标准系列教程中，我们将详细介绍Solidity合约中变量的存储布局，内存存储，以及`calldata`和`returndata`遵守的ABI编码规则，帮助大家理解Solidity的内部规则。这一讲，我们将介绍Solidity的值类型变量是如何在合约中存储的，你需要事先安装[foundry](https://book.getfoundry.sh/getting-started/installation)。

## EVM的存储

EVM的账户存储（Account Storage）是一种映射（mapping，键值对存储），每个键和值都是256 bit的数据，它支持256 bit的读和写。这种存储在每个合约账户上都存在，并且是持久的：它的数据会保持在区块链上，直到被明确地修改。

对存储的读取（`SLOAD`）和写入（`SSTORE`）都需要gas，并且比内存操作更昂贵。这样设计可以防止滥用存储资源，因为所有的存储数据都需要在每个以太坊节点上保存。

![](./img/1-1.png)

## 值类型的存储布局

在Solidity中，值类型（比如`uint8`和静态数组）和引用类型（比如映射和动态数组）的存储布局不同，这一讲我们只介绍前者。

### 规则1. 默认从存储槽0开始被逐项存储

合约中的第一个状态变量默认存储在槽`0`中，之后的状态变量（如果不能放在同一个存储槽）存储在槽`1`中，以此类推。在下面的`ValueStorage1`合约中，我们声明了2个`uint256`类型的状态变量：

```solidity
contract ValueStorage1 {
    uint256 public a = 5;
    uint256 public b = 2;
}
```

你可以使用下面的命令打印合约的存储布局，可以看到变量`a`被存储在Slot 0，变量`b`被存储在Slot 1。

```shell
forge inspect src/01_ValueStorage.sol:ValueStorage1 storage-layout --pretty
```

| Name | Type    | Slot | Offset | Bytes | Contract                              |
|------|---------|------|--------|-------|---------------------------------------|
| a    | uint256 | 0    | 0      | 32    | src/01_ValueStorage.sol:ValueStorage1 |
| b    | uint256 | 1    | 0      | 32    | src/01_ValueStorage.sol:ValueStorage1 |

### 规则2. 多个值可共享同一个存储槽

由于EVM的存储很贵，在合约中，状态变量以一种紧凑的方式存储：值类型只使用存储它们所需的字节数，如果多个连续状态变量的大小总和不足32字节，它们会被放在同一个存储槽中；如果一个值类型不适合一个存储槽的剩余部分，它将被存储在下一个存储槽。

在下面的`ValueStorage2`合约中，我们声明了`4`个状态变量。

```solidity
contract ValueStorage2 {
    uint128 public a = 5;
    uint64 public b = 2;
    uint32 public c = 3;
    uint64 public d = 1;
}
```

你可以使用下面的命令打印合约的存储布局：

```shell
forge inspect src/01_ValueStorage.sol:ValueStorage2 storage-layout --pretty
```

我们可以看到，变量`a`，`b`和`c`都被存储在`Slot 0`中，这是因为它们的类型分别为`uint128`，`uint64`和`uint32`，而`128+64+32=224`小于`256`。变量`d`被存储在`Slot 1`，这是因为它是`uint64`类型，加上前面的变量就超过`256`位了。

| Name | Type    | Slot | Offset | Bytes | Contract                              |
|------|---------|------|--------|-------|---------------------------------------|
| a    | uint128 | 0    | 0      | 16    | src/01_ValueStorage.sol:ValueStorage2 |
| b    | uint64  | 0    | 16     | 8     | src/01_ValueStorage.sol:ValueStorage2 |
| c    | uint32  | 0    | 24     | 4     | src/01_ValueStorage.sol:ValueStorage2 |
| d    | uint64 | 1    | 0      | 8    | src/01_ValueStorage.sol:ValueStorage2 |

> **思考题**：如果变量`d`是`uint32`的话，它会被存储在哪里呢？

### 规则3. 存储插槽的第一项会以低位对齐（即右对齐）的方式储存

`ValueStorage1`合约中的变量`a`和`b`（均为`uint256`类型）会被存储为

```
a: 0x0000000000000000000000000000000000000000000000000000000000000005
b: 0x0000000000000000000000000000000000000000000000000000000000000002
```

`ValueStorage2`合约中的变量`a`，`b`和`c`（分别为`uint128`，`uint64`和`uint32`）会被存储为：

```
a b c: 0x0000000000000003000000000000000200000000000000000000000000000005
```

这是因为变量`a`是第一项，会从最右边开始存，值为`5`，占`128`位（`16`字节）。然后`b`从右数`16`字节开始存，值为`2`，占`64`位（`8`字节）。最后`c`从右数`24`字节开始存，值为`3`，占`32`位（`4`字节）。

### 规则4. 结构/数组总是从一个新的存储槽开始，紧跟着它们的变量总是开辟一个新的存储槽

在下面的`ValueStorage3`合约中，我们声明了一个`S`结构体，它包含两个成员：`uint64`类型的`b`和`uint32`类型的`c`。按照规则3的话，变量`a`和结构体`s`会共享Slot 0；而如果按照规则4，变量`a`会被单独保存在Slot 0，结构体`s`会被保存在Slot 1，而变量`d`会被保存在Slot 2。

```solidity
contract ValueStorage3 {
    struct S { uint64 b; uint32 c; }

    uint128 public a = 5;
    S public s = S(2, 3);
    uint64 public d = 1;
}
```

你可以使用下面的命令打印合约的存储布局：

```shell
forge inspect src/01_ValueStorage.sol:ValueStorage3 storage-layout --pretty
```

可以看到，按照规则4，三个变量被保存在不同的存储槽中。

| Name | Type                   | Slot | Offset | Bytes | Contract                              |
|------|------------------------|------|--------|-------|---------------------------------------|
| a    | uint128                | 0    | 0      | 16    | src/01_ValueStorage.sol:ValueStorage3 |
| s    | struct ValueStorage3.S | 1    | 0      | 32    | src/01_ValueStorage.sol:ValueStorage3 |
| d    | uint64                 | 2    | 0      | 8     | src/01_ValueStorage.sol:ValueStorage3 |

## 总结

这一讲，我们介绍了值变量，静态数组和结构体数据在合约中的存储结构。
