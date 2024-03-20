// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AccessControl {
    address public owner;

    modifier onlyOwner {
        require(msg.sender == owner, "Only the contract owner can perform this operation");
        _;
    }

    constructor() {
        owner = msg.sender;
    }
}