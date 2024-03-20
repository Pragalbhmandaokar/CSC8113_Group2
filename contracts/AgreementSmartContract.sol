// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./AccessControl.sol";
import "./DataUsageSmartContract.sol";

contract AgreementSmartContract is AccessControl {

    // Struct
    
    struct Consent {
        address purposeBlockAddress;        // = dataUsageSmartContractAddress, input
        uint userId;                        // input
        uint dataUsageId;                   // can get the dataUsage, input
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
        uint _dataUsageId,
        bool _isConsented
    ) public onlyOwner {
        // Retrieve service purpose from data usage smart contract
        DataUsageSmartContract.DataUsage memory dataUsage = dataUsageSmartContract.getDataUsageByKey(_dataUsageId);
        
        consents[_dataUsageId] = Consent({
            purposeBlockAddress: _purposeBlockAddress,
            userId: _userId,
            dataUsageId: _dataUsageId,
            isConsented: _isConsented,
            servicePurpose: dataUsage.servicePurpose
        });
        
        consentKeys.push(_dataUsageId);
        consentsCounter++;

        emit ConsentAdded(_dataUsageId);
    }

    function getConsentByKey(uint _dataUsageId) public view returns (Consent memory) {
        require(consents[_dataUsageId].dataUsageId != 0, "Consent does not exist.");
        return consents[_dataUsageId];
    }

    function getConsentCounter() public view returns (uint) {
        return consentsCounter;
    }

    function getConsentKeys() public view returns (uint[] memory) {
        return consentKeys;
    }

}
