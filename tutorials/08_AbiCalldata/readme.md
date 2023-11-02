---
title: 08. calldata和returndata的ABI编码
tags:
  - solidity
  - abi
---

# WTF Solidity内部标准: 08. 不同功能的ABI编码

《WTF Solidity内部标准》教程将介绍Solidity智能合约中的存储布局，内存布局，以及ABI编码规则，帮助大家理解Solidity的内部规则。

推特：[@0xAA_Science](https://twitter.com/0xAA_Science)

社区：[Discord](https://discord.gg/5akcruXrsk)｜[微信群](https://docs.google.com/forms/d/e/1FAIpQLSe4KGT8Sh6sJ7hedQRuIYirOoZK_85miz3dw7vA1-YjodgJ-A/viewform?usp=sf_link)｜[官网 wtf.academy](https://wtf.academy)

所有代码和教程开源在github: [github.com/AmazingAng/WTF-Solidity-Internals](https://github.com/AmazingAng/WTF-Solidity-Internals)

-----

这一讲，我们将介绍函数参数`calldata`和返回值`returndata`的ABI编码规则。

## calldata

当我们调用函数时，我们需要为要调用的函数名以及参数进行ABI编码。对于参数`a_1, ..., a_n`的函数`f`的调用会被编码为：

```
function_selector(f) e((a_1, ..., a_n))
```

其中`function_selector(f)`为函数的选择器（函数签名的`Keccak-256`哈希值的前`4`字节），`(a_1, ..., a_n)`为参数组成的元组，`e(x)`为变量`x`的ABI编码。

举个简单的例子：

```solidity
function testCalldata(uint256 x, bool y) public pure{
}
```

当我们调用上面的`testCalldata()`函数，参数为`99`（也就是`0x63`）和`true`时，会如何编码呢？

首先，我们需要计算这个函数的函数选择器，为`0xb3b1391c`。如果你不了解函数选择器，可以阅读[WTF Solidity教程第29讲](https://www.wtf.academy/solidity-advanced/Selector/)。

接下来我们需要编码`(x, y)`。由于`x`和`y`都是静态类型，这个元组也是静态类型，直接编码就可以。

因此，`calldata`的编码为：

```
0xb3b1391c
0000000000000000000000000000000000000000000000000000000000000063
0000000000000000000000000000000000000000000000000000000000000001
```

## returndata

当函数返回时，我们需要对返回值进行编码。返回值`a_1, ..., a_n`会被被编码为：

```
e((a_1, ..., a_n))
```

举个简单的例子：

```solidity
function testReturndata() public pure returns(uint x, bool y){
    x = 99;
    y = true;
}
```

当我们调用上面的`testReturndata()`函数，返回值是如何编码的？

其实很简单，返回值的编码就是`e((x, y))`，也就是上一节`calldata`编码去掉函数选择器的部分：

```
0x
0000000000000000000000000000000000000000000000000000000000000063
0000000000000000000000000000000000000000000000000000000000000001
```

## 总结

这一讲，我们介绍了Solidity合约的ABI编码公式，有了它，再复杂的编码也不怕。它的核心思想是使用递归的方法把复杂类型的编码转换成简单类型的编码。