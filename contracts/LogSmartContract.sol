// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract LogSmartContract {
    struct Log {
        string actorID;
        string operation;
        string serviceName;
        string processedPersonalData;
    }

    Log[] public logs;
    // mapping(uint => Log) public logs;
    // uint public logCount;
    
    //array [] = {}
    function addLog(string memory _actorID, string memory _operation, string memory _serviceName, string memory _processedPersonalData) public {
        logs.push(Log(_actorID, _operation, _serviceName, _processedPersonalData));
    }
    
    function getLogsLength() public view returns (uint) {
        return logs.length;
    }
}