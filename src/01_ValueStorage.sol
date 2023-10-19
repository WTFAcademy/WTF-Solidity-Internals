// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract ValueStorage1 {
    uint256 public a = 5;
    uint256 public b = 2;
}


contract ValueStorage2 {
    uint128 public a = 5;
    uint64 public b = 2;
    uint32 public c = 3;
    uint64 public d = 1;
}

contract ValueStorage3 {
    struct S { uint64 b; uint32 c; }

    uint128 public a = 5;
    S public s = S(2, 3);
    uint64 public d = 1;
}
