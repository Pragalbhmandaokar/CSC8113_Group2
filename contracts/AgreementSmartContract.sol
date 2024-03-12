// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Define a contract named AgreementSmartContract
/**
 * @title Agreement Smart Contract
 * @dev Store and manage user agreements on data usage purposes
 */
contract AgreementSmartContract {

    // Define a structure named Agreement to hold agreement details
    /**
     * @dev Struct to store a user's agreement to a data processing purpose
     * @param purposeBlockHash The hash of the data purpose block
     * @param userID Unique identifier of the user
     * @param consent The user's consent status (true for agree, false for disagree)
     */
    struct Agreement {
        bytes32 purposeBlockHash;
        uint userID;
        bool consent;
    }
    
    // Declare a mapping to store multiple user agreements, indexed by a unique ID
    mapping(uint => Agreement) public agreements;    //array [] = {}

    // A counter to keep track of the number of agreements added
    uint public agreementCount;
   
    // Function to add a user agreement to the mapping
    /**
     * @dev Record a new agreement in the contract
     * @param _purposeBlockHash The hash of the purpose block related to the agreement
     * @param _userID The user's unique identifier
     * @param _consent The user's consent (true for agree, false for disagree)
     */
    function addAgreement(bytes32 _purposeBlockHash, uint _userID, bool _consent) public {
        // Add the agreement to the mapping at the current count index
        agreements[agreementCount] = Agreement(_purposeBlockHash, _userID, _consent);
        // Increment the count to track the new entry
        agreementCount++;
    }

    // Function to get the number of agreements stored
    /**
     * @dev Returns the number of agreements stored in the contract
     * @return The count of agreements
     */
    function getAgreementsLength() public view returns (uint){
        return agreementCount;
    }
}