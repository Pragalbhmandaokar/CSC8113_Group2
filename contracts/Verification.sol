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

    uint[] private violators;                                   // Array to store the IDs of the actors that violated the agreements

    event ActorFlaggedAsViolator(address indexed _actor,string  _serviceName,string _servicePurpose, string _violationMessage);

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
        uint[] memory logKeys = logSmartContract.getLogKeys();
        uint[] memory consentKeys = agreementSmartContract.getConsentKeys();

        for (uint i = 0; i < logKeys.length; i++) {
            uint logKey = logKeys[i];
            LogSmartContract.Log memory log = logSmartContract.getLogByKey(logKey);

            for (uint j = 0; j < consentKeys.length; j++) {
                uint consentKey = consentKeys[j];
                if (logKey == consentKey) {
                    AgreementSmartContract.Consent memory consent = agreementSmartContract.getConsentByKey(consentKey);
                    DataUsageSmartContract.DataUsage memory dataUsage = dataUsageSmartContract.getDataUsageByKey(logKey);

                    if (!consent.isConsented || log.actorId != consent.userId) {
                        violators.push(log.actorId);
                        continue;
                    }

                    bool isViolation = false;
                    if(log.operations.length != dataUsage.operations.length) {
                        isViolation = true;
                    } else {
                        for (uint k = 0; k < log.operations.length; k++) {
                            if (keccak256(abi.encodePacked(log.operations[k])) != keccak256(abi.encodePacked(dataUsage.operations[k]))) {
                                isViolation = true;
                                break;
                            }
                        }
                    }

                    if (!isViolation) {
                        for (uint l = 0; l < log.processedPersonalDatas.length; l++) {
                            bytes32 logData = log.processedPersonalDatas[l];
                            bytes32 consentData = dataUsageSmartContract.getProcessedPersonalDataByKey(dataUsage.personalDataIds[l]);
                            if (logData != consentData) {
                                isViolation = true;
                                break;
                            }
                        }
                    }

                    if (isViolation) {
                        violators.push(log.actorId);
                    }
                }
            }
        }
    }

    /** In the revised verifyCompliance function:
            1 - It first fetches the keys for logs and consents.
            2 - It iterates over the log keys and, within that loop, iterates over the consent keys to find matches.
            3 - When a matching key is found, it performs the necessary verifications:
                    - Checks if the consent is given and the actor's ID matches.
                    - Compares the operations and processed personal data between the log and data usage entries.
            4 - If any discrepancies are found, it flags the actor as a violator.
    */

    function getViolators() public view returns (uint[] memory) {
        return violators;
    }
}

