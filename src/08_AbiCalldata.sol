// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract AbiCalldata {
    function testCalldata(uint256 x, bool y) public pure{
    }

    function testReturndata() public pure returns(uint x, bool y){
        x = 99;
        y = true;
    }
}