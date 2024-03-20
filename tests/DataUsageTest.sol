// SPDX-License-Identifier: GPL-3.0
        
pragma solidity ^0.8.10;

import "remix_tests.sol"; 

import "../contracts/DataUsageSmartContract.sol";
import "../contracts/AccessControl.sol";

contract DataUsageSmartTestCases {
    // The address of the agreement smart contract to be tested
    AccessControl accessControl;
    DataUsageSmartContract dataUsageContract;

    address purposeBlockAddress = address(this); // Example purpose block address
    uint userId = 1;
    uint dataUsageId = 1;
    bool isConsented = true;

    function beforeAll() public {
        dataUsageContract = new DataUsageSmartContract();
    }

     // Test the addActor function
    function testAddActor() public {
        uint testActorId = 1;
        string memory testActorName = "Company XYZ";

        dataUsageContract.addActor(testActorId, testActorName);

        DataUsageSmartContract.Actor memory actor = dataUsageContract.getActorByKey(testActorId);

        Assert.equal(actor.actorId, testActorId, "Actor ID does not match");
        Assert.equal(actor.actorName, testActorName, "Actor name does not match");
    }
    
    function testAddPersonalData() public {
        uint testUserId = 1;
        string memory testUserName = "Rename it";
        string memory testUserAddress = "123 Main St";
        string memory testUserTelephone = "123-456-7890";
        string[] memory testAdditionalInfos = new string[](0); // No additional infos for this test
        
        dataUsageContract.addPersonalData(testUserId, testUserName, testUserAddress, testUserTelephone, testAdditionalInfos);

        DataUsageSmartContract.PersonalData memory personalData = dataUsageContract.getPersonalDataByKey(testUserId);

        Assert.equal(personalData.userId, testUserId, "User ID does not match");
        Assert.equal(personalData.userName, testUserName, "User name does not match");
        Assert.equal(personalData.userAddress, testUserAddress, "User address does not match");
        Assert.equal(personalData.userTelephone, testUserTelephone, "User telephone does not match");
    }

    //
    function testAddProcessedPersonalData() public {
        uint testPersonalDataId = 1;

     string[] memory testAdditionalInfos = new string[](1);
        testAdditionalInfos[0] = "some"; // Initialize the dynamic array manually

        dataUsageContract.addPersonalData(testPersonalDataId, "Alice", "123 Main St", "123-456-7890", testAdditionalInfos );
        dataUsageContract.addProcessedPersonalData(testPersonalDataId);

        bytes32 processedData = dataUsageContract.getProcessedPersonalDataByKey(testPersonalDataId);

        // You may need to adjust this assertion based on your actual implementation
        Assert.notEqual(processedData, bytes32(0), "Processed personal data should not be empty");
    }


    function testAddDataUsage() public {
        string memory testServiceName = "Service ABC";
        string memory testServicePurpose = "Purpose XYZ";
        uint testActorId = 1;
        
        string[] memory testOperations = new string[](2);
        testOperations[0] = "read";
        testOperations[1] = "write";

        uint[] memory testPersonalDataIds = new uint[](1);
        testPersonalDataIds[0] = 1;

         string[] memory testAdditionalInfos = new string[](1);
        testAdditionalInfos[0] = "some"; // Initialize the dynamic array manually


        dataUsageContract.addPersonalData(1, "Alice", "123 Main St", "123-456-7890", testAdditionalInfos );
        dataUsageContract.addProcessedPersonalData(1);
        dataUsageContract.addActor(testActorId, "Company XYZ");

        dataUsageContract.addDataUsage(testServiceName, testServicePurpose, testActorId, testOperations, testPersonalDataIds);

        DataUsageSmartContract.DataUsage memory dataUsage = dataUsageContract.getDataUsageByKey(0);

        Assert.equal(dataUsage.serviceName, testServiceName, "Service name does not match");
        Assert.equal(dataUsage.servicePurpose, testServicePurpose, "Service purpose does not match");
        Assert.equal(dataUsage.actorId, testActorId, "Actor ID does not match");
        Assert.equal(dataUsage.operations.length, testOperations.length, "Operations length does not match");
        Assert.equal(dataUsage.personalDataIds.length, testPersonalDataIds.length, "PersonalDataIds length does not match");
    }

}
    