// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.10;

import "remix_tests.sol"; 
import "../contracts/LogSmartContract.sol";
import "../contracts/DataUsageSmartContract.sol";
import "../contracts/AgreementSmartContract.sol";
import "../contracts/AccessControl.sol";

contract AgreementSmartContractTest {
    AccessControl accessControl;
    AgreementSmartContract agreementContract;

    function beforeEach() public {
        agreementContract = new AgreementSmartContract();
    }

    function testAddConsent() public {
        address purposeBlockAddress = address(0x1);
        uint userId = 1;
        bool isConsented = true;

        agreementContract.addConsent(purposeBlockAddress, userId, isConsented);

        AgreementSmartContract.Consent memory consent = agreementContract.getConsentByKey(userId);

        Assert.equal(consent.purposeBlockAddress, purposeBlockAddress, "Purpose block address should match input.");
        Assert.equal(consent.userId, userId, "User ID should match input.");
        Assert.equal(consent.isConsented, isConsented, "Consent status should match input.");
    }

    function testConsentCounter() public {
        uint expected = 0;
        Assert.equal(agreementContract.getConsentCounter(), expected, "Initial consent counter should be 0.");

        agreementContract.addConsent(address(0x1), 1, true);
        expected += 1;
        Assert.equal(agreementContract.getConsentCounter(), expected, "Consent counter should increase after adding consent.");
    }

    function testConsentKeys() public {
        uint[] memory keys = agreementContract.getConsentKeys();
        Assert.equal(keys.length, 0, "Initial keys array should be empty.");

        agreementContract.addConsent(address(0x1), 1, true);
        keys = agreementContract.getConsentKeys();
        Assert.equal(keys.length, 1, "Keys array should contain one element after adding consent.");
        Assert.equal(keys[0], 1, "Keys array should contain the correct user ID.");
    }
}