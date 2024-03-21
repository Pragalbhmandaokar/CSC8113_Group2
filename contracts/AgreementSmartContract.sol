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
    }

    // Mapping

    mapping(uint => Consent) private consents;          // mapping consents <uint dataUsageId, Consent theConsent>
    uint[] private consentKeys;                         // key  = Consent.dataUsageId(uint)
    uint private consentsCounter = 0;                   // counter,(start from 0, ++ when add)


    // Function
    function addConsent(
        address _purposeBlockAddress,
        uint _userId,
        bool _isConsented
    ) public onlyOwner {
        
        consents[_userId] = Consent({
            purposeBlockAddress: _purposeBlockAddress,
            userId: _userId,
            isConsented: _isConsented
        });
        
        consentKeys.push(_userId);
        consentsCounter++;
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
