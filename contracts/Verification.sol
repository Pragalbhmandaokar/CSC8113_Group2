// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./DataUsageSmartContract.sol";
import "./AgreementSmartContract.sol";
import "./LogSmartContract.sol";

contract Verification {

    address public owner;

    DataUsageSmartContract public dataUsageContract;
    AgreementSmartContract public agreementContract;
    LogSmartContract public logContract;

    string[] violators;

    constructor(address _dataUsageContract, address _agreementContract, address _logContract) {
        dataUsageContract = DataUsageSmartContract(_dataUsageContract);
        agreementContract = AgreementSmartContract(_agreementContract);
        logContract = LogSmartContract(_logContract);
        owner = msg.sender;
    }

    function checkViolations() public view returns (string[] memory violators) {
        require(msg.sender == owner, "Only owner can perform this action");

        uint logCount = logContract.getLogsLength();
        violators = new string[](logCount);
        uint violatorCount = 0;

        for (uint i = 0; i < logCount; i++) {
            (string memory _actorID, string memory _operation, string memory _serviceName, string memory _processedPersonalData) = logContract.logs(i);
            LogSmartContract.Log memory log = LogSmartContract.Log(_actorID, _operation, _serviceName, _processedPersonalData);
           
            // LogSmartContract.Log memory log = logContract.logs[i];
            bool found = false; 

            for (uint j = 0; j < agreementContract.getAgreementsLength(); j++) {
                (bytes32 _purposeBlockHash, uint _userID, bool _consent) = agreementContract.agreements(j);
                AgreementSmartContract.Agreement memory consent = AgreementSmartContract.Agreement(_purposeBlockHash,_userID,_consent);
                bytes32 purposeHash = dataUsageContract.getPurposeHash(j);

                if (consent.purposeBlockHash == purposeHash && consent.consent) {
                    found = true;
                    break;
                }
            }

            if (!found) {
                violators[violatorCount] = log.actorID;
                violatorCount++;
            }
        }

        // Resize the array to the actual number of violators
        assembly {
            mstore(violators, violatorCount)
        }
    }
}