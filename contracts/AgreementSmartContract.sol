// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./AccessControl.sol";
import "./DataUsageSmartContract.sol";

contract AgreementSmartContract is AccessControl {

    struct Consent {
        uint dataUsageId;             // ID linking to a specific DataUsage record
        address purposeBlockAddress;  // Address of the DataUsageSmartContract
        uint userId;                  // ID of the user giving consent
        string servicePurpose;        // The purpose for which the service is used
        bool isConsent;               // Whether negative(false) / positive(true)
    }

    DataUsageSmartContract public dataUsageSmartContract;

    mapping(uint => Consent) private consents;       // Mapping from userID to consent
    uint private consentCount = 0;

    event ConsentAdded(uint indexed userId, uint indexed dataUsageId, bool isConsent);

    constructor(address _dataUsageSmartContractAddress) {
        dataUsageSmartContract = DataUsageSmartContract(_dataUsageSmartContractAddress);
    }


    

}