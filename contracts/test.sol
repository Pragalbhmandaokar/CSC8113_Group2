// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract AgreementSmartContract {

    // Struct
    struct Consent {
        address purposeBlockAddress;                 // the address of the DataUsageSmartContract after deployed into public blockchain
        bytes32 purposeHashKeyOfDataUsage;           // Hash key of the data usage entry, Key of mapHashDataUsage = hash value of the properties in one data usage record
        uint userId;                                 // ID of the user
        bool isConsented;                            // the user's given consent (positive == true / negative == false)
    }

    // Mapping to store consents keyed by a hash
    mapping(bytes32 => Consent) public mapHashConsent;

    // Event emitted when a new consent is added
    event ConsentAdded(bytes32 hashOfConsent);

    // Function to add a new consent record and return the hash of the consent
    function addConsent(
        address _purposeBlockAddress,
        bytes32 _purposeHashKeyOfDataUsage,
        uint _userId,
        bool _isConsented
    ) public returns (bytes32) {
        
        // Generate the hash for the new consent
        bytes32 hashOfConsent = keccak256(
            abi.encodePacked(_purposeBlockAddress, _purposeHashKeyOfDataUsage, _userId, _isConsented)
        );

        // Ensure the consent is unique and doesn't already exist
        require(
            mapHashConsent[hashOfConsent].userId == 0,
            "A consent record with this hash already exists."
        );

        // Create and store the new consent
        mapHashConsent[hashOfConsent] = Consent({
            purposeBlockAddress: _purposeBlockAddress,
            purposeHashKeyOfDataUsage: _purposeHashKeyOfDataUsage,
            userId: _userId,
            isConsented: _isConsented
        });

        // Emit an event for the new consent
        emit ConsentAdded(hashOfConsent);

        // Return the hash of the new consent
        return hashOfConsent;
    }
}