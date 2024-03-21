// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.10;

import "remix_tests.sol"; 
import "../contracts/LogSmartContract.sol";
import "../contracts/DataUsageSmartContract.sol";
import "../contracts/AccessControl.sol";

contract LogSmartContractTest {
    AccessControl accessControl;
    LogSmartContract logContract;
    DataUsageSmartContract dataUsageContract;

    uint dataUsageId = 1;


    function beforeAll() public {
        accessControl = new AccessControl();
        dataUsageContract = new DataUsageSmartContract();
        logContract = new LogSmartContract(address(dataUsageContract));

        // Add necessary data to the DataUsageSmartContract
        dataUsageContract.addActor(1, "Company XYZ");
        string[] memory operations = new string[](2);
        operations[0] = "read";
        operations[1] = "write";

        // Initialize an empty uint[] array
        uint[] memory emptyUintArray;

        // Pass the empty uint[] array to the addDataUsage function
        dataUsageContract.addDataUsage("Service ABC", "Purpose XYZ", 1, operations, emptyUintArray);
    }

    function testAddLog() public {
        logContract.addLog(dataUsageId);

        LogSmartContract.Log memory log = logContract.getLogByKey(dataUsageId);

        Assert.equal(log.dataUsageId, dataUsageId, "Data usage ID does not match");
        Assert.equal(log.actorId, 1, "Actor ID does not match");
        Assert.equal(log.operations.length, 2, "Operations length does not match");
        Assert.equal(log.serviceName, "Service ABC", "Service name does not match");
        Assert.equal(log.processedPersonalDatas.length, 1, "Processed personal data length does not match");
    }

    function testGetLogCounter() public {
        uint logCounter = logContract.getLogCounter();
        Assert.equal(logCounter, 1, "Log counter should be 1");
    }

    function testGetLogKeys() public {
        uint[] memory keys = logContract.getLogKeys();
        Assert.equal(keys[0], dataUsageId, "Log key does not match");
    }
}