// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AccessControl {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

     modifier onlyOwner {
        require(msg.sender == owner, "Only the contract owner can perform this operation");
        _;
    }

}