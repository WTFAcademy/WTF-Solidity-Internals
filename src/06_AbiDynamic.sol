// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract AbiDynamic {
    function testAbiArray() public pure returns (bytes memory){
        uint[] memory a = new uint[](3);
        a[0] = 1;
        a[1] = 2;
        a[2] = 3;
        return abi.encode(a);
    }

    function testAbiString() public pure returns (bytes memory){
        string memory b = "WTF";
        return abi.encode(b);
    }

    function testAbiStringStaticArray() public pure returns (bytes memory){
        string[2] memory strings = ["WTF", "Academy"];
        return abi.encode(strings);
    }


    function testAbiStringArray() public pure returns (bytes memory){
        string[] memory strings = new string[](2);
        strings[0] = "WTF";
        strings[1] = "Academy";
        return abi.encode(strings);
    }

    struct DynamicStruct { uint a; uint[] b; string c; }

    function testAbiDynamicStruct() public pure returns (bytes memory){
        uint a = 99;
        uint[] memory b = new uint[](3);
        b[0] = 1;
        b[1] = 2;
        b[2] = 3;
        string memory c = "WTF";

        DynamicStruct memory ds = DynamicStruct(a, b, c);
        return abi.encode(ds);
    }
}