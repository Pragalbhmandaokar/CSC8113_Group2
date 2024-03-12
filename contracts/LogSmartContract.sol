// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Define a contract named LogSmartContract
/**
 * @title Log Smart Contract
 * @dev Store and retrieve logs of data processing operations
 */
contract LogSmartContract {

    // Define a structure named Log to hold details of data processing operations
    /**
     * @dev Struct to store logs of data processing activities
     * @param actorID The identifier of the actor (data processor)
     * @param operation The type of data processing operation performed
     * @param serviceName The name of the service associated with the operation
     * @param processedPersonalData The data that was processed
     */
    struct Log {
        string actorID;
        string operation;
        string serviceName;
        string processedPersonalData;
    }

    // Declare an array to store multiple logs
    Log[] public logs;
    // mapping(uint => Log) public logs;
    // uint public logCount;
    // array [] = {}
    
    // Function to add a log entry to the array
    /**
     * @dev Add a new log entry to the contract
     * @param _actorID The identifier of the actor (data processor)
     * @param _operation The type of data processing operation performed
     * @param _serviceName The name of the service associated with the operation
     * @param _processedPersonalData The data that was processed
     */
    function addLog(string memory _actorID, string memory _operation, string memory _serviceName, string memory _processedPersonalData) public {
        logs.push(Log(_actorID, _operation, _serviceName, _processedPersonalData));
    }
    
    // Function to retrieve the number of log entries
    /**
     * @dev Retrieve the total number of log entries stored
     * @return The number of log entries
     */
    function getLogsLength() public view returns (uint) {
        return logs.length;
    }
}