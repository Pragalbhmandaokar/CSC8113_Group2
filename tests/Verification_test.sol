// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.10;

import "remix_tests.sol"; 
import "../contracts/Verification.sol";
import "../contracts/DataUsageSmartContract.sol";
import "../contracts/AgreementSmartContract.sol";
import "../contracts/LogSmartContract.sol";

contract TestVerification {
    Verification verification;
    DataUsageSmartContract dataUsageSmartContract;
    AgreementSmartContract agreementSmartContract;
    LogSmartContract logSmartContract;

    function beforeEach() public {
        dataUsageSmartContract = new DataUsageSmartContract();
        agreementSmartContract = new AgreementSmartContract();
        logSmartContract = new LogSmartContract();
        verification = new Verification(address(dataUsageSmartContract), address(agreementSmartContract), address(logSmartContract));
    }

    

   function testVerifyComplianceNonMatchingOperations() public {
        // Create logs and consents with non-matching operations
        dataUsageSmartContract.addDataUsage("Service1", "Purpose1", 1, DataUsageSmartContract.Operation.read, 10, "ProcessedData1");
        agreementSmartContract.addConsent(address(dataUsageSmartContract), 10, true);
        logSmartContract.addLog(1, LogSmartContract.Operations.write, "ProcessedData1", "Service1");

        // Call verifyCompliance function
        verification.verifyCompliance();

        // Get violators
        uint[] memory violators = verification.getViolators();

        // Assert violators exist
        Assert.notEqual(violators.length, 0, "Expected value should be equal to");
    }

    function testVerifyComplianceNonMatchingProcessedPersonalData() public {
        // Create logs and consents with non-matching processed personal data
        dataUsageSmartContract.addDataUsage("Service1", "Purpose1", 1, DataUsageSmartContract.Operation.read, 10, "ProcessedData1");
        agreementSmartContract.addConsent(address(dataUsageSmartContract), 10, true);
        logSmartContract.addLog(1, LogSmartContract.Operations.read, "ProcessedData2", "Service1");

        // Call verifyCompliance function
        verification.verifyCompliance();

        // Get violators
        uint[] memory violators = verification.getViolators();

        // Assert violators exist
        Assert.notEqual(violators.length, 0, "There should be violators");
    }

     function testGetViolators() public {
        // Create logs and consents to generate violators
        dataUsageSmartContract.addDataUsage("Service1", "Purpose1", 1, DataUsageSmartContract.Operation.read, 10, "ProcessedData1");
        agreementSmartContract.addConsent(address(dataUsageSmartContract), 10, true);
        logSmartContract.addLog(1, LogSmartContract.Operations.write, "ProcessedData1", "Service1");

        // Call verifyCompliance function
        verification.verifyCompliance();

        // Get violators
        uint[] memory violators = verification.getViolators();

        // Assert violators match expected list
        Assert.equal(violators.length, 1, "There should be one violator");
        Assert.equal(violators[0], 1, "The violator ID should match");
    }
}
