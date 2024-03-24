// SPDX-License-Identifier: GPL-3.0
        
pragma solidity ^0.8.10;

import "remix_tests.sol"; 

import "../contracts/DataUsageSmartContract.sol";
import "../contracts/AccessControl.sol";

contract DataUsageSmartTestCases {
    // The address of the agreement smart contract to be tested
    AccessControl accessControl;
    DataUsageSmartContract dataUsageContract;


    function beforeAll() public {
        dataUsageContract = new DataUsageSmartContract();
    }

    function testAddDataUsageIncreasesCounter() public {
        bytes32 processedData = keccak256(abi.encodePacked(uint(1), "Alice", "123 Main St", "555-0100"));
        dataUsageContract.addDataUsage("TestService", "Testing", 1, DataUsageSmartContract.Operation.read, 1, processedData);
        uint expected = 1;
        Assert.equal(dataUsageContract.getDataUsageCounter(), expected, "Counter should increase to 1 after adding a data usage.");
    }
    
     function testGetDataUsageByKey() public {
        bytes32 processedData = keccak256(abi.encodePacked(uint(1), "Bob", "456 Elm St", "555-0101"));
        dataUsageContract.addDataUsage("AnotherService", "Testing", 2, DataUsageSmartContract.Operation.write, 1, processedData);
        DataUsageSmartContract.DataUsage memory usage = dataUsageContract.getDataUsageByKey(2);

        Assert.equal(usage.serviceName, "AnotherService", "Service name should match input.");
        Assert.equal(usage.servicePurpose, "Testing", "Service purpose should match input.");
        Assert.equal(usage.actorId, 2, "Actor ID should match input.");
        Assert.equal(uint(usage.operations), uint(DataUsageSmartContract.Operation.write), "Operation should match input.");
        Assert.equal(usage.personalDataIds, 1, "Personal data IDs should match input.");
        Assert.equal(usage.processedPersonalDatas, processedData, "Processed personal data should match input.");
    }
}
    