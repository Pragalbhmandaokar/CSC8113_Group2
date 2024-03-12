// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


// Define a contract named DataUsageSmartContract
/**
 * @title Data Usage Smart Contract
 * @dev Store and retrieve user data usage details
 */
contract DataUsageSmartContract {

    // Define a structure named DataUsage to hold data usage details
    /**
     * @dev Struct to store data usage
     * @param actorID Unique ID of the actor (data processor)
     * @param serviceName Name of the service
     * @param servicePurpose Purpose of the data processing
     * @param operation Type of data operation (read, write, transfer)
     * @param personalData Array of personal data involved
     */
    struct DataUsage {
        uint actorID;
        string serviceName;
        string servicePurpose;
        string operation;
        string[] personalData;
    }


    // Declare an array to store multiple data usage entries
    // mapping(uint => DataUsage) public dataUsages;
    DataUsage[] public dataUsages;  
  

    // Function to add a data usage entry to the array
    /**
     * @dev Store a new data usage in the contract
     * @param _actorID The actor's unique identifier
     * @param _serviceName The name of the service processing data
     * @param _servicePurpose The purpose for processing the data
     * @param _operation The type of operation performed on the data
     * @param _personalData The list of personal data items
     */  
    function addDataUsage(uint _actorID, string memory _serviceName, string memory _servicePurpose, string memory _operation, string[] memory _personalData) public {
        // Push a new instance of DataUsage struct to the dataUsages array
        dataUsages.push(DataUsage(_actorID, _serviceName, _servicePurpose, _operation, _personalData));
    }
    //Array [] = {}


    // Function to retrieve a unique hash for a data usage entry
    /**
     * @dev Retrieve a hash of the service purpose and actor ID
     * @param index The index of the data usage entry in the array
     * @return The keccak256 hash of the actorID and serviceName
     */
    function getPurposeHash(uint index) public view returns (bytes32) {
        // Generate and return a hash of the actor ID and service name
        return keccak256(abi.encodePacked(dataUsages[index].actorID, dataUsages[index].serviceName));
    }
    
}
// Array [] = { } 