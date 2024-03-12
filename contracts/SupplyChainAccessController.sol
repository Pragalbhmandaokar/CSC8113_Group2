// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Importing AccessControl from the OpenZeppelin Contracts library, which provides a standard implementation for role-based access control.
import "@openzeppelin/contracts/access/AccessControl.sol";

/**
 * @title Log Smart Contract
 * @dev Extends OpenZeppelin's AccessControl contract to implement role-based access control
 */
contract LogSmartContract is AccessControl{

    // Define a modifier that checks if the `msg.sender` has the specified `role`
    /**
     * @dev Modifier to enforce role-based access control
     * @param role The required role to perform a certain function call
     */
    modifier only(bytes32 role) {
        // Reverts if the `msg.sender` does not have the role required for the operation
        require(hasRole(role, msg.sender), "Caller is not authorized due to role");
        _;
    }

    // Declare a constant hash for the OEM role
    bytes32 public constant OEM = keccak256("OEM");

    // Declare a constant hash for the DEALERSHIP role
    bytes32 public constant DEALERSHIP = keccak256("DEALERSHIP_ROLE");
}