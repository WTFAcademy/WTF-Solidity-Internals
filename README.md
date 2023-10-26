# WTF Solidity Internals

《WTF Solidity内部标准》教程将介绍Solidity智能合约中的存储布局，内存布局，以及ABI编码规则，帮助大家理解Solidity的内部规则。

先修课程：
1. [WTF Solidity](https://github.com/AmazingAng/WTF-Solidity)

## 教程

**第01讲：基础存储布局**：[Code](https://github.com/WTFAcademy/WTF-Solidity-Internals/blob/master/src/01_ValueStorage.sol) | [文章](https://github.com/WTFAcademy/WTF-Solidity-Internals/blob/master/tutorials/01_ValueStorage/readme.md) 

**第02讲：映射和动态数组的存储布局**：[Code](https://github.com/WTFAcademy/WTF-Solidity-Internals/blob/master/src/02_MappingStorage.sol) | [文章](https://github.com/WTFAcademy/WTF-Solidity-Internals/blob/master/tutorials/02_MappingStorage/readme.md) 

**第03讲：字节数组和字符串的存储布局**：[Code](https://github.com/WTFAcademy/WTF-Solidity-Internals/blob/master/src/03_BytesStorage.sol) | [文章](https://github.com/WTFAcademy/WTF-Solidity-Internals/blob/master/tutorials/03_BytesStorage/readme.md) 

**第04讲：内存布局**：[Code](https://github.com/WTFAcademy/WTF-Solidity-Internals/blob/master/src/04_MemoryLayout.sol) | [文章](https://github.com/WTFAcademy/WTF-Solidity-Internals/blob/master/tutorials/04_MemoryLayout/readme.md) 

## 运行

### 配置环境

要使用此模板，你需要安装以下内容。请按照链接和指示操作。

- [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)  
    - 如果你可以运行`git --version`，则说明你已正确安装。
- [Foundry / Foundryup](https://github.com/gakonst/foundry)
    - 这将会安装`forge`，`cast`和`anvil`
    - 通过运行`forge --version`并获取类似`forge 0.2.0 (92f8951 2022-08-06T00:09:32.96582Z)`的输出，你可以检测是否已正确安装。
    - 要获取每个工具的最新版本，只需运行`foundryup`。

### 快速开始

1. 克隆[本仓库](https://github.com/WTFAcademy/WTF-Solidity-Internals)。

运行：

```
git clone https://github.com/WTFAcademy/WTF-Solidity-Internals
cd WTF-Huff
```

2. 安装依赖

克隆并进入你的仓库后，你需要安装必要的依赖项。为此，只需运行：

```shell
forge install
```

3. 打印合约存储布局

要打印合约存储布局，你可以运行：

```shell
forge inspect ValueStorage3 storage-layout --pretty
```

有关如何使用Foundry的更多信息，请查看[Foundry Github Repository](https://github.com/foundry-rs/foundry/tree/master/forge)和[foundry-huff library repository](https://github.com/huff-language/foundry-huff)。

## 参考

- [Solidity-doc](https://docs.soliditylang.org/en/latest/internals/layout_in_storage.html)
