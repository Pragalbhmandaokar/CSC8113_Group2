// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract DataUsageSmartContract {
    struct DataUsage {
        uint actorID;
        string serviceName;
        string servicePurpose;
        string operation;
        string[] personalData;
    }
    
    mapping(uint => DataUsage) public dataUsages;
    uint public dataUsageCount;
    //array [] = {}
    function addDataUsage(uint _actorID, string memory _serviceName, string memory _servicePurpose, string memory _operation, string[] memory _personalData) public {
        dataUsages[dataUsageCount] = DataUsage(_actorID, _serviceName, _servicePurpose, _operation, _personalData);
        dataUsageCount++;
    }
}

