// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract BytesStorage {
    string public shortString = "WTF";
    bytes public longBytes = hex"365f5f375f5f365f73bebebebebebebebebebebebebebebebebebebebe5af43d5f5f3e5f3d91602a57fd5bf3";

    function getHash(bytes memory bb) public pure returns(bytes32){
        return keccak256(bb);
    }
}