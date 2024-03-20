// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./AccessControl.sol";
import "./DataUsageSmartContract.sol";

contract LogSmartContract is AccessControl {

    // Struct

    struct Log {
        uint dataUsageId;                                // can get the specific dataUsage, input
        uint actorId;                                    // below all data get from this dataUsage
        string[] operations;
        string serviceName;
        bytes32[] processedPersonalDatas;
    }

    // Associate with the DataUsageSmartContract

    DataUsageSmartContract private dataUsageSmartContract;

    // Mapping

    mapping(uint => Log) private logs;                  // mapping logs <uint dataUsageId, Log theLog>
    uint[] private logKeys;                             // key  = Log.dataUsageId(uint)
    uint private logCounter = 0;                        // counter,(start from 0, ++ when add)

    // Event
    event LogAdded(uint dataUsageId);

    // Constructor
    constructor(address _dataUsageSmartContractAddress) {
        dataUsageSmartContract = DataUsageSmartContract(_dataUsageSmartContractAddress);
        require(_dataUsageSmartContractAddress != address(0), "DataUsageSmartContract address is invalid.");
    }

    // Function

    function addLog(uint _dataUsageId) public onlyOwner {
        // Retrieve the associated DataUsage record to ensure it exists
        DataUsageSmartContract.DataUsage memory dataUsage = dataUsageSmartContract.getDataUsageByKey(_dataUsageId);

        // Initialize processedPersonalDatas array for the log, assuming DataUsage contract provides a method to get processed data
        bytes32[] memory processedDatas = new bytes32[](dataUsage.personalDataIds.length);
        for(uint i = 0; i < dataUsage.personalDataIds.length; ++i) {
            processedDatas[i] = dataUsageSmartContract.getProcessedPersonalDataByKey(dataUsage.personalDataIds[i]);
        }

        // Create the log record
        logs[_dataUsageId] = Log({
            dataUsageId: _dataUsageId,
            actorId: dataUsage.actorId,
            operations: dataUsage.operations,
            serviceName: dataUsage.serviceName,
            processedPersonalDatas: processedDatas
        });

        logKeys.push(_dataUsageId);
        logCounter++;

        emit LogAdded(_dataUsageId);
    }

    function getLogByKey(uint _dataUsageId) public view returns (Log memory) {
        require(logs[_dataUsageId].dataUsageId != 0, "Log does not exist.");
        return logs[_dataUsageId];
    }

    function getLogCounter() public view returns (uint) {
        return logCounter;
    }

    function getLogKeys() public view returns (uint[] memory) {
        return logKeys;
    }
}
 