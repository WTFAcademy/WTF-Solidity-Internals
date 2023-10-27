// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract MemoryLayout {
    function testUint() public pure returns (uint){
        uint a = 3;
        return a;
    }

    function testShortString() public pure returns (string memory){
        string memory x = "WTF";
        return x;
    }

    function testLongBytes() public pure returns (bytes memory){
        bytes memory x = hex"365f5f375f5f365f73bebebebebebebebebebebebebebebebebebebebe5af43d5f5f3e5f3d91602a57fd5bf3";
        return x;
    }

    function testStaticArray() public pure returns (uint8[3] memory){
        uint8[3] memory b = [1,2,3];
        return b;
    }

    function testDynamicArray() public pure returns (uint[] memory){
        uint[] memory x = new uint[](3);
        x[0] = 1;
        x[2] = 4;
        return x;
    }

    function testMultiDimensionalArray(string memory info, uint16 length) public pure returns (string[] memory){
        string[] memory x = new string[](length);
        x[0] = info;
        x[1] = "HELLO";
        x[length - 1] = "WTF";
        return x;
    }
}
