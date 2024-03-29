// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./AccessControl.sol";
import "./DataUsageSmartContract.sol";
import "./AgreementSmartContract.sol";
import "./LogSmartContract.sol";

contract Verification is AccessControl {

    enum Operations{
        read,
        write,
        transfer
    }

    DataUsageSmartContract private dataUsageSmartContract;
    AgreementSmartContract private agreementSmartContract;
    LogSmartContract private logSmartContract;

    uint[] private violators;   // Array to store the IDs of the actors that violated the agreements

    event ActorFlaggedAsViolator(uint _actor, string _violationMessage);

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
             uint logKeyTsUser = logKeys[i];

            LogSmartContract.Log memory log = logSmartContract.getLogByKey(logKeyTsUser);

           for (uint j = 0; j < consentKeys.length; j++) {
                uint consentKeyIsActor = consentKeys[j];
                
                if (logKeyTsUser != consentKeyIsActor) {
                    AgreementSmartContract.Consent memory consent = agreementSmartContract.getConsentByKey(consentKeyIsActor);
                    DataUsageSmartContract.DataUsage memory dataUsage = dataUsageSmartContract.getDataUsageByKey(logKeyTsUser);

                    if (!consent.isConsented || log.actorId == consent.userId) {
                        violators.push(log.actorId);
                        emit ActorFlaggedAsViolator(log.actorId, "Consent is false");
                        continue;
                    }

                    bool isViolation = false;
                    if(uint(log.operations) != uint(dataUsage.operations)) {
                        isViolation = true;
                        emit ActorFlaggedAsViolator(log.actorId, "Operation performed is different");
                    } 

                    if (!isViolation) {
                            bytes32 logData = log.processedPersonalDatas;
                            bytes32 consentData = dataUsage.processedPersonalDatas;
                            if (logData != consentData) {
                                isViolation = true;
                                emit ActorFlaggedAsViolator(log.actorId, "processed personal data doesnt match");
                            }     
                    }

                    if (isViolation) {
                        violators.push(log.actorId);
                        break;
                    }
                    emit ActorFlaggedAsViolator(log.actorId, "Actor's address matched succesfully");
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
        require(violators.length != 0, "violator is empty");
        return violators;
    }
}

