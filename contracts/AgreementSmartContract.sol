// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract AgreementSmartContract {
    struct Agreement {
        bytes32 purposeBlockHash;
        uint userID;
        bool consent;
    }
    
    mapping(uint => Agreement) public agreements;
    uint public agreementCount;

    function addAgreement(bytes32 _purposeBlockHash, uint _userID, bool _consent) public {
        agreements[agreementCount] = Agreement(_purposeBlockHash, _userID, _consent);
        agreementCount++;
    }
}