// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract LogSmartContract {
    
    struct Log {
        uint actorID;
        string operation;
        string serviceName;
        string processedPersonalData;
    }
    
    mapping(uint => Log) public logs;
    uint public logCount;

    function addLog(uint _actorID, string memory _operation, string memory _serviceName, string memory _processedPersonalData) public {
        logs[logCount] = Log(_actorID, _operation, _serviceName, _processedPersonalData);
        logCount++;
    }
  
}