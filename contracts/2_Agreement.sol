// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

contract AgreementContract {
    struct Agreement {
        bytes32 purposeBlockHash;
        address userId;
        bool consent;
    }

    Agreement[] public agreements;

    function addAgreement(
        bytes32 _purposeBlockHash,
        address _userId,
        bool _consent
    ) public {
        agreements.push(Agreement(_purposeBlockHash, _userId, _consent));
    }
    
    function getAgreement(uint _index) public view returns (bytes32 purposeBlockHash, address userId, bool consent) {
        require(_index < agreements.length, "Index out of bounds");
        Agreement storage agreement = agreements[_index];
        return (agreement.purposeBlockHash, agreement.userId, agreement.consent);
    }
}
