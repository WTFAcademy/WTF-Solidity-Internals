// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract MappingStorage {
    mapping(uint => uint) public a;
    uint256 public b = 5;

    constructor(){
        a[0] = 1;
        a[1] = 2;
    }
}

contract ArrayStorage {
    uint128 public a = 9;
    uint128[] public b;

    constructor(){
        b.push(10);
        b.push(11);
        b.push(12);
    }
}

