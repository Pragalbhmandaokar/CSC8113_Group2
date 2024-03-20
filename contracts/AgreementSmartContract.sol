// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract AgreementSmartContract {
    struct Agreement {
        bytes32 purposeBlockHash;
        uint userID;
        bool consent;
    }
    
    // mapping(uint => Agreement) public agreements;    //array [] = {}
    // uint public agreementCount = 0;

   Agreement[] public agreements;
    function addAgreement(bytes32 _purposeBlockHash, uint _userID, bool _consent) public {
        agreements.push(Agreement(_purposeBlockHash, _userID, _consent));
     
    }

    function getAgreementsLength() public view returns (uint){
        return agreements.length;
    }
}