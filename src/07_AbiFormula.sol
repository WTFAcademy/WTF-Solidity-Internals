// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract AbiFormula {
    function testAbiUintTuple() public pure returns (bytes memory){
        uint x = 1;
        return abi.encode((x));
    }

    function testAbiArray() public pure returns (bytes memory){
        uint[] memory x = new uint[](3);
        x[0] = 1;
        x[1] = 2;
        x[2] = 3;
        return abi.encode(x);
    }

    struct DynamicStruct { uint x; uint[] y; string z; }

    function testAbiDynamicStruct() public pure returns (bytes memory){
        uint x = 99;
        uint[] memory y = new uint[](3);
        y[0] = 1;
        y[1] = 2;
        y[2] = 3;
        string memory z = "WTF";

        return abi.encode(DynamicStruct(x, y, z));
    }
}