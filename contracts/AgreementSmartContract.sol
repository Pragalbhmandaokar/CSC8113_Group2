// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./AccessControl.sol";
import "./DataUsageSmartContract.sol";

contract AgreementSmartContract is AccessControl {

    // Struct
    struct Consent {
        address purposeBlockAddress;        // = dataUsageSmartContractAddress, input
        uint userId;                        // input
        bool isConsented;                   // positive == true / negative == false, input
        string servicePurpose;              // retrieve from this dataUsage
    }

    // Associate with the DataUsageSmartContract

    DataUsageSmartContract private dataUsageSmartContract;

    // Mapping

    mapping(uint => Consent) private consents;          // mapping consents <uint dataUsageId, Consent theConsent>
    uint[] private consentKeys;                         // key  = Consent.dataUsageId(uint)
    uint private consentsCounter = 0;                   // counter,(start from 0, ++ when add)

    // Event
    event ConsentAdded(uint dataUsageId);

    // Constructor
    constructor(address _dataUsageSmartContractAddress) {
        dataUsageSmartContract = DataUsageSmartContract(_dataUsageSmartContractAddress);
        require(_dataUsageSmartContractAddress != address(0), "The DataUsageSmartContract Address does not exist.");
    }

    // Function
    function addConsent(
        address _purposeBlockAddress,
        uint _userId,
        bool _isConsented
    ) public onlyOwner {
        // Retrieve service purpose from data usage smart contract
        DataUsageSmartContract.DataUsage memory dataUsage = dataUsageSmartContract.getDataUsageByKey(_userId);
        
        consents[_userId] = Consent({
            purposeBlockAddress: _purposeBlockAddress,
            userId: _userId,
            isConsented: _isConsented,
            servicePurpose: dataUsage.servicePurpose
        });
        
        consentKeys.push(_userId);
        consentsCounter++;

        emit ConsentAdded(_userId);
    }

    function getConsentByKey(uint _dataUsageId) public view returns (Consent memory) {
        require(consents[_dataUsageId].userId != 0, "Consent does not exist.");
        return consents[_dataUsageId];
    }

    function getConsentCounter() public view returns (uint) {
        return consentsCounter;
    }

    function getConsentKeys() public view returns (uint[] memory) {
        return consentKeys;
    }

}
