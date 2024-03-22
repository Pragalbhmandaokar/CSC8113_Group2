// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./AccessControl.sol";
import "./DataUsageSmartContract.sol";

contract LogSmartContract is AccessControl {

     enum Operations{
        read,
        write,
        transfer
    }
    // Struct
    struct Log {
        uint actorId;                                    // below all data get from this dataUsage
        Operations operations;
        string serviceName;
        bytes32 processedPersonalDatas;
    }

   // Mapping
    mapping(uint => Log) private logs;                  // mapping logs <uint dataUsageId, Log theLog>
    uint[] private logKeys;                             // key  = Log.dataUsageId(uint)
    uint private logCounter = 0;                       // counter,(start from 0, ++ when add)

    // Function 

    function addLog(uint _actorId,Operations _operation, bytes32 _processPersonalData, string memory _serviceName) public onlyOwner {
        // Retrieve the associated DataUsage record to ensure it exists
        //require(_dataUsageId < dataUsageSmartContract.getDataUsageCounter(),"Transaction number out of bounds");

        // Create the log record
        logs[_actorId] = Log({
            actorId: _actorId,
            operations: _operation,
            serviceName: _serviceName,
            processedPersonalDatas: _processPersonalData
        });
        
        logKeys.push(_actorId);
        logCounter++;
       
    }

    function getLogByKey(uint _dataActorId) public view returns (Log memory) {
        return logs[_dataActorId];
    }

    function getLogCounter() public view returns (uint) {
        return logCounter;
    }

    function getLogKeys() public view returns (uint[] memory) {
        return logKeys;
    }
}
 