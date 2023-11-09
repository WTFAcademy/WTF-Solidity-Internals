// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract AbiEvent {

    // 定义Transfer event，记录transfer交易的转账地址，接收地址和转账数量
    event Transfer(address indexed from, address indexed to, uint value);
    // 定义String event，分别以topic和data记录相同的string
    event String(string indexed strTopic, string strData);
    // 定义Array event，分别以topic和data记录相同的数组
    event Array(uint[] indexed arrTopic, uint[] arrData);
    // 定义匿名事件，它的日志中不包含事件哈希，最多拥有`4`个`indexed`参数
    event Anon(address indexed from, address indexed to, uint256 indexed num1, uint256 indexed num2) anonymous;

    function testEventTransfer(
        address from,
        address to,
        uint256 amount
    ) external {
        emit Transfer(from, to, amount);
    }

    function testEventString(
        string memory str
    ) external {
        emit String(str, str);
    }

    function testEventArray() external {
        uint[] memory x = new uint[](3);
        x[0] = 1;
        x[1] = 2;
        x[2] = 3;

        emit Array(x, x);
    }

    function testEventAnon(        
        address from,
        address to,
        uint256 num1,
        uint256 num2
    ) external {
        emit Anon(from, to, num1, num2);
    }
}