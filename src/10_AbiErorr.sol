// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract AbiError {
    error InsufficientBalance(address from, uint256 required);

    // revert-error
    function testError(address addr, uint amount) public pure {
        revert InsufficientBalance(addr, amount);
    }

    // require
    function testRequire(address from) public pure {
        require(from == address(0), "Transfer Not Zero");
    }
}