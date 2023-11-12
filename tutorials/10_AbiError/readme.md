---
title: 10. Error的ABI编码
tags:
  - solidity
  - abi
---

# WTF Solidity内部标准: 10. Error的ABI编码

《WTF Solidity内部标准》教程将介绍Solidity智能合约中的存储布局，内存布局，以及ABI编码规则，帮助大家理解Solidity的内部规则。

推特：[@0xAA_Science](https://twitter.com/0xAA_Science)

社区：[Discord](https://discord.gg/5akcruXrsk)｜[微信群](https://docs.google.com/forms/d/e/1FAIpQLSe4KGT8Sh6sJ7hedQRuIYirOoZK_85miz3dw7vA1-YjodgJ-A/viewform?usp=sf_link)｜[官网 wtf.academy](https://wtf.academy)

所有代码和教程开源在github: [github.com/AmazingAng/WTF-Solidity-Internals](https://github.com/AmazingAng/WTF-Solidity-Internals)

-----

这一讲，我们将介绍Solidity的错误（error）的ABI编码规则。

## error

合约在运行发生故障时可以使用`REVERT`操作码终止运行并回滚交易，而且可以返回一个错误信息给调用者。这个错误信息的编码方式与`calldata`一致。

### 自定义错误

编码由`error`关键字定义的自定义错误信息时，前`4`字节为错误选择器。错误选择器与函数选择器类似，是错误签名的Keccak256哈希的前`4`字节，比如下面`InsufficientBalance`错误，错误签名为`InsufficientBalance(address,uint256)`，错误选择器为`0xf6deaa04`。

```solidity
error InsufficientBalance(address from, uint256 required);

// revert-error
function testError(address addr, uint amount) public pure {
    revert InsufficientBalance(addr, amount);
}
```

对于函数输入 `000000000000000000000000d8b934580fce35a11b58c6d73adee468a2833fa8` 和 `1`，该错误信息的编码为：

```
0xf6deaa04
000000000000000000000000d8b934580fce35a11b58c6d73adee468a2833fa8
0000000000000000000000000000000000000000000000000000000000000001
```

### require 和 assert

自定义错误是在Solidity `0.8.4`版本加入的，之前只能用`require`和`assert`抛出一个字符串作为错误信息，那么它是如何编码的呢？

Solidity规定了它们的错误签名为`Error(string)`，对应的选择器为`0x08c379a0`。

```solidity
// require
function testRequire(address from) public pure {
    require(from == address(0), "Transfer Not Zero");
}
```

上面函数`require`抛出的错误会被编码为:

```
0x08c379a0
0000000000000000000000000000000000000000000000000000000000000020
0000000000000000000000000000000000000000000000000000000000000011
5472616e73666572204e6f74205a65726f000000000000000000000000000000
```

## 总结

这一讲，我们介绍了Solidity中错误的ABI编码规则，包括`0.8.4`新加入的自定义错误和以前`require`和`assert`抛出的字符串错误。