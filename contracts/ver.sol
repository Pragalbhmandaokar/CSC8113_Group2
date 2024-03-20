// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./DataUsageSmartContract.sol";
import "./LogSmartContract.sol";
import "./AgreementSmartContract.sol";

contract VerificationContract {
    address public owner;

    DataUsageSmartContract public dataUsage;

    DataProcessingLog public dataProcessingLog;

    DataPurposeVoting public dataPurposeVoting;

    mapping(address => bool) public violators;

    event ActorFlaggedAsViolator(address indexed _actor,string  _serviceName,string _servicePurpose, string _violationMessage);

    constructor(DataProcessingLog _dataProcessingLog, DataPurposeVoting _dataPurposeVoting,DataUsageSmartContract _dataUsage) {
        owner = msg.sender;
        dataUsage = _dataUsage;
        dataProcessingLog = _dataProcessingLog;
        dataPurposeVoting = _dataPurposeVoting;
    }

    function checkViolator(bytes32 _purposeHash,string memory _userId,uint256 i) external{

        require(msg.sender == owner, "Only owner can perform this action");

        // Get vote data from DataPurposeVoting contract
        (bytes32 vote_purposeHash, address vote_actorId, string memory _serviceName,string memory _servicePurpose, DataPurposeVoting.Operation vote_operation,DataPurposeVoting.UserData memory vote_userData, bool consent) = dataPurposeVoting.votes(_purposeHash,_userId);



        vote_purposeHash = _purposeHash;

        address recordedActorId = dataProcessingLog.getActorId(i);

        DataUsageSmartContract.Operation recordOperation = dataProcessingLog.getOperation(i);

        DataUsageSmartContract.PersonalData memory recordPersonalData = dataProcessingLog.getPersonalData(i);


        if (vote_actorId != recordedActorId || (!consent)) {
            violators[recordedActorId] = true;
            emit ActorFlaggedAsViolator(recordedActorId,_serviceName,_servicePurpose,
                "Actor's address didn't conform to user's voting or consent is not provided");
        }

        if(uint(vote_operation) != uint(recordOperation) || (!consent) )
        {
            violators[recordedActorId] = true;
            emit ActorFlaggedAsViolator(recordedActorId,_serviceName,_servicePurpose,
                "Actor's operation didn't conform to user's voting or consent is not provided");
        }

        if(!compareUserData(recordPersonalData,vote_userData))
        {
            violators[recordedActorId] = true;
            emit ActorFlaggedAsViolator(recordedActorId,_serviceName,_servicePurpose,
                "Processed data didn't conform to user's voting or consent is not provided");
        }

    }

    function compareUserData(DataUsageSmartContract.PersonalData memory data1, DataPurposeVoting.UserData memory data2) internal pure returns (bool) {
        return (keccak256(abi.encode(data1)) == keccak256(abi.encode(data2)));
    }
}