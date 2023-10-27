// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract AbiEncode {
    function testAbiEncode() public pure returns (bytes memory){
        uint a = 1;
        uint8 b = 2;
        uint32[3] memory c = [uint32(3),4,5];
        bool d = true;
        bytes1 e = hex"aa";
        address f = 0x7A58c0Be72BE218B41C608b7Fe7C5bB630736C71;
        return abi.encode(a, b, c, d, e, f);
    }
}