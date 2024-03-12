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

    DataUsage[] public dataUsages;
    // mapping(uint => DataUsage) public dataUsages;
  
    //Array [] = {}
    function addDataUsage(uint _actorID, string memory _serviceName, string memory _servicePurpose, string memory _operation, string[] memory _personalData) public {
        dataUsages.push(DataUsage(_actorID, _serviceName, _servicePurpose, _operation, _personalData));
    }

     function getPurposeHash(uint index) public view returns (bytes32) {
        return keccak256(abi.encodePacked(dataUsages[index].actorID, dataUsages[index].serviceName));
    }
    
}

// Array [] = { } 