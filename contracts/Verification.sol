// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./DataUsageSmartContract.sol";
import "./AgreementSmartContract.sol";
import "./LogSmartContract.sol";

// Define a contract named Verification
/**
 * @title Verification Contract
 * @dev Contract to verify data usage compliance with user agreements
 */
contract Verification {

    // Public state variables for the associated smart contracts
    DataUsageSmartContract public dataUsageContract;
    AgreementSmartContract public agreementContract;
    LogSmartContract public logContract;

    // Constructor to initialize the smart contracts on deployment
    /**
     * @dev Constructor to set the addresses of associated smart contracts
     * @param _dataUsageContract Address of the DataUsageSmartContract
     * @param _agreementContract Address of the AgreementSmartContract
     * @param _logContract Address of the LogSmartContract
     */
    constructor(address _dataUsageContract, address _agreementContract, address _logContract) {
        dataUsageContract = DataUsageSmartContract(_dataUsageContract);
        agreementContract = AgreementSmartContract(_agreementContract);
        logContract = LogSmartContract(_logContract);
    }

    // Function to check for violations in the logs against user agreements
    /**
     * @dev Checks for violations of data usage against user consents
     * @return violators Array of actor IDs who violated the data usage agreements
     */
    function checkViolations() public view returns (string[] memory violators) {

        // Retrieve the total number of logs from the LogSmartContract
        uint logCount = logContract.getLogsLength();
        
        // Initialize an array to hold the potential violators
        violators = new string[](logCount);
        uint violatorCount = 0;

        // Iterate over all logs to check for violations
        for (uint i = 0; i < logCount; i++) {
            // Retrieve log details from the LogSmartContract
            (string memory _actorID, string memory _operation, string memory _serviceName, string memory _processedPersonalData) = logContract.logs(i);
            // Reconstruct the log data for comparison
            LogSmartContract.Log memory log = LogSmartContract.Log(_actorID, _operation, _serviceName, _processedPersonalData);
            // LogSmartContract.Log memory log = logContract.logs[i];

            // Initialize a boolean flag to track found consents
            bool found = false;

            // Iterate over all agreements to find matching consents
            for (uint j = 0; j < agreementContract.getAgreementsLength(); j++) {
                // Retrieve consent details from the AgreementSmartContract
                (bytes32 _purposeBlockHash, uint _userID, bool _consent) = agreementContract.agreements(j);
                // Reconstruct the consent data for comparison
                AgreementSmartContract.Agreement memory consent = AgreementSmartContract.Agreement(_purposeBlockHash,_userID,_consent);
                // Calculate the purpose hash to compare with consent records
                bytes32 purposeHash = dataUsageContract.getPurposeHash(j);

                // Check if the logged action has a matching consent
                if (consent.purposeBlockHash == purposeHash && consent.consent) {
                    found = true;
                    break;
                }
            }

            // If no matching consent is found, add actor to violators list
            if (!found) {
                violators[violatorCount] = log.actorID;
                violatorCount++;
            }
        }

        // Resize the array to the actual number of violators
        // This low-level operation adjusts the array size to save on storage costs
        assembly {
            mstore(violators, violatorCount)
        }
    }
}