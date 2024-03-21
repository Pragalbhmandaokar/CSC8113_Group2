// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.10;

import "remix_tests.sol"; 
import "../contracts/AgreementSmartContract.sol";
import "../contracts/DataUsageSmartContract.sol";
import "../contracts/AccessControl.sol";

contract AgreementSmartContractTest {
    AccessControl accessControl;
    AgreementSmartContract agreementContract;
    DataUsageSmartContract dataUsageContract;

    address purposeBlockAddress = address(this); // Example purpose block address
    uint userId = 1;
    uint dataUsageId = 1;
    bool isConsented = true;
    string testServicePurpose = "Purpose XYZ";

    function beforeAll() public {
        accessControl = new AccessControl();
        dataUsageContract = new DataUsageSmartContract();
        agreementContract = new AgreementSmartContract(address(dataUsageContract));
        dataUsageContract.addActor(1, "Company XYZ");
        string[] memory operations = new string[](2);
        operations[0] = "read";
        operations[1] = "write";
        uint[] memory personalDataIds = new uint[](0);  // Empty array of uint[]
        dataUsageContract.addDataUsage("Service ABC", testServicePurpose, 1, operations, personalDataIds);
    }




    function testAddConsent() public {
        agreementContract.addConsent(purposeBlockAddress, userId, isConsented);

        AgreementSmartContract.Consent memory consent = agreementContract.getConsentByKey(dataUsageId);

        Assert.equal(consent.purposeBlockAddress, purposeBlockAddress, "Purpose block address does not match");
        Assert.equal(consent.userId, userId, "User ID does not match");
        Assert.equal(consent.isConsented, isConsented, "Consent value does not match");
        Assert.equal(consent.servicePurpose, testServicePurpose, "Service purpose does not match");
    }

    function testGetConsentCounter() public {
        uint consentCounter = agreementContract.getConsentCounter();
        Assert.equal(consentCounter, 1, "Consent counter should be 1");
    }

    function testGetConsentKeys() public {
        uint[] memory keys = agreementContract.getConsentKeys();
        Assert.equal(keys[0], dataUsageId, "Consent key does not match");
    }
}