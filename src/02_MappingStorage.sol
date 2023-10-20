// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract MappingStorage {
    mapping(uint => uint) public a; // slot 0 仅用作占位
    uint256 public b = 5;           // slot 1 

    constructor(){
        a[0] = 1;                   // slot 0xad3228b676f7d3cd4284a5443f17f1962b36e491b30a40b2405849e597ba5fb5
        a[1] = 2;                   // slot 0xada5013122d395ba3c54772283fb069b10426056ef8ca54750cb9bb552a59e7d
    }
}

contract ArrayStorage {
    uint128 public a = 9;           // slot 0
    uint128[] public b;             // slot 1 保存数组长度

    constructor(){
        b.push(10);                 // slot 0xb10e2d527612073b26eecdfd717e6a320cf44b4afac2b0732d9fcbe2b7fa0cf6
        b.push(11);                 // slot 0xb10e2d527612073b26eecdfd717e6a320cf44b4afac2b0732d9fcbe2b7fa0cf6
        b.push(12);                 // slot 0xb10e2d527612073b26eecdfd717e6a320cf44b4afac2b0732d9fcbe2b7fa0cf7
    }
}

