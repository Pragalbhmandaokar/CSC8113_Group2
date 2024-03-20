// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./AccessControl.sol";
import "./DataUsageSmartContract.sol";
import "./AgreementSmartContract.sol";
import "./LogSmartContract.sol";

contract Verification is AccessControl {

    DataUsageSmartContract private dataUsageSmartContract;
    AgreementSmartContract private agreementSmartContract;
    LogSmartContract private logSmartContract;

    uint[] private violatorActorIds;                                   // Array to store the IDs of the actors that violated the agreements

    constructor(
        address _dataUsageSmartContractAddress,
        address _agreementSmartContractAddress,
        address _logSmartContractAddress
    ) {
        require(_dataUsageSmartContractAddress != address(0), "Invalid DataUsageSmartContract address.");
        require(_agreementSmartContractAddress != address(0), "Invalid AgreementSmartContract address.");
        require(_logSmartContractAddress != address(0), "Invalid LogSmartContract address.");

        dataUsageSmartContract = DataUsageSmartContract(_dataUsageSmartContractAddress);
        agreementSmartContract = AgreementSmartContract(_agreementSmartContractAddress);
        logSmartContract = LogSmartContract(_logSmartContractAddress);
    }
    

    function verifyCompliance() public onlyOwner {
        uint dataUsageCount = dataUsageSmartContract.getDataUsageCounter();
        
        for (uint i = 0; i < dataUsageCount; i++) {
            // Assume the existence of a method in LogSmartContract to get logs by dataUsageId
            LogSmartContract.Log memory log = logSmartContract.getLogByKey(i);
            // Assume the existence of a method in AgreementSmartContract to get consent by dataUsageId
            AgreementSmartContract.Consent memory consent = agreementSmartContract.getConsentByKey(i);

            // Verification logic
            if(consent.isConsented == false || log.actorId != consent.userId) {
                // If consent is not given or log's actorId does not match consent's userId, flag as violator
                violatorActorIds.push(log.actorId);
            }
        }
    }

    function getViolators() public view returns (uint[] memory) {
        return violatorActorIds;
    }
}

