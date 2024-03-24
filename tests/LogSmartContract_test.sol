// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.10;

import "remix_tests.sol"; 
import "../contracts/LogSmartContract.sol";

contract LogSmartContractTest {
    AccessControl accessControl;
  
    address purposeBlockAddress = address(this); // Example purpose block address
    uint userId = 1;
    uint dataUsageId = 1;
    bool isConsented = true;
    string testServicePurpose = "Purpose XYZ";
    
    LogSmartContract logContract;

    function beforeEach() public {
        logContract = new LogSmartContract();
    }

    
    function testAddLog() public {
        uint actorId = 123;
        uint operation = 0;
        bytes32 processPersonalData = bytes32("SomeData");
        string memory serviceName = "Service1";

        logContract.addLog(actorId, LogSmartContract.Operations.read, processPersonalData, serviceName);

        LogSmartContract.Log memory log = logContract.getLogByKey(actorId);

        Assert.equal(log.actorId, actorId, "Actor ID should match");
        Assert.equal(uint(log.operations), uint(operation), "Operation should match");
        Assert.equal(log.processedPersonalDatas, processPersonalData, "Processed personal data should match");
        Assert.equal(log.serviceName, serviceName, "Service name should match");
    }

    function testLogCounter() public {
        uint initialCounter = logContract.getLogCounter();
        Assert.equal(initialCounter, 0, "Initial log counter should be zero");

        logContract.addLog(1, LogSmartContract.Operations.read, bytes32("Data"), "Service1");

        uint updatedCounter = logContract.getLogCounter();
        Assert.equal(updatedCounter, 1, "Log counter should be incremented after adding a log");
    }

    function testLogKeys() public {
        uint actorId = 123;
        logContract.addLog(actorId,LogSmartContract.Operations.read, bytes32("Data"), "Service1");

        uint[] memory keys = logContract.getLogKeys();

        Assert.equal(keys.length, 1, "Number of log keys should match the number of logs");

        Assert.equal(keys[0], actorId, "Log key should match");
    }


}