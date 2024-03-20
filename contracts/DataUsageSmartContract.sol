// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./AccessControl.sol";

contract DataUsageSmartContract is AccessControl {

    // Struct

    struct DataUsage {
        string serviceName;
        string servicePurpose;
        uint actorId;                       // associated with the actor
        string[] operations;                //  == "read", "write", "transfer"(multiple)
        uint[] personalDataIds;             // associated with proccessedPersonalData(byte32)
        bytes32[] processedPersonalDatas;
    }

    struct Actor {
        uint actorId;
        address actorAddress;
        string actorName;
    }

    struct PersonalData {
        uint userId;
        string userName;
        string userAddress;
        string userTelephone;
        string[] additionalInfos;
    }

    // Mapping

    mapping(uint => DataUsage) private dataUsages;              // mapping dataUsages <uint dataUsageId, DataUsage theDataUsage>
    mapping(uint => Actor) private actors;                      // mapping actors <uint actorId, Actor theActor>
    mapping(uint => PersonalData) private personalDatas;        // mapping personalDatas <uint personalDataId, PersonalData thePersonalData>
    mapping(uint => bytes32) private processedPersonalDatas;    // mapping processedPersonalDatas <uint personalDataId, byte32 theProcessedPersonalData>

    // Store Key of Mappings

    uint private dataUsageCounter = 0;
    uint[] private actorIds;
    uint private personalDataCounter = 0;

    // Event : When an event is triggered, it is recorded on the blockchain and can be listened to by external applications or other smart contracts.

    event DataUsageAdded(uint dataUsageId);
    
    // Function

    // ------ mapping : personalDatas ---- : add\get PersonalData functions are "public onlyOwner", getCounter function is "public view"
    function addPersonalData(
        uint _userId,
        string memory _userName,
        string memory _userAddress,
        string memory _userTelephone,
        string[] memory additionalInfos
    ) public onlyOwner {
        personalDatas[_userId] = PersonalData({
            userId: _userId,
            userName: _userName,
            userAddress: _userAddress,
            userTelephone: _userTelephone,
            additionalInfos: additionalInfos
        });
        personalDataCounter++;
    }

    function getPersonalDataByKey(uint _personalDataId) public onlyOwner returns (PersonalData memory) {
        require(_personalDataId < personalDataCounter, "PersonalData does not exist.");
        return personalDatas[_personalDataId];
    }

    function getPersonalDataCounter() public view returns (uint) {
        return personalDataCounter;
    }

    // ------ mapping : processedPersonalDatas ---- : add function is "public onlyOwner", get functions are "public view"
    function addProcessedPersonalData(uint _personalDataId) public onlyOwner {
        // Ensure that the personal data exists
        require(_personalDataId < personalDataCounter, "PersonalData does not exist.");
    
        // Retrieve the personal data
        PersonalData storage personalData = personalDatas[_personalDataId];
    
        // Initialize a variable to concatenate the personal data fields
        bytes memory dataToHash;

         // Concatenate non-array fields
        dataToHash = abi.encodePacked(
            personalData.userName,
            personalData.userAddress,
            personalData.userTelephone
        );
    
        // Iterate over the additionalInfos array and concatenate its contents
        for (uint i = 0; i < personalData.additionalInfos.length; i++) {
            dataToHash = abi.encodePacked(dataToHash, personalData.additionalInfos[i]);
        }

        // Generate the hash of the concatenated data
        bytes32 processedPersonalData = keccak256(dataToHash);

        // Create a mapping from the personalDataId to the hashed data
        processedPersonalDatas[_personalDataId] = processedPersonalData;   
    }

    function getProcessedPersonalDataByKey(uint _personalDataId) public view returns (bytes32) {
        require(_personalDataId < personalDataCounter, "ProcessedPersonalData does not exist.");
        return processedPersonalDatas[_personalDataId];
    }

    // ------ mapping : actors ---- : add function is "public onlyOwner", get functions are "public view"
    function addActor(uint _actorId, address _actorAddress, string memory _actorName) public onlyOwner {
        actors[_actorId] = Actor({
            actorId: _actorId,
            actorAddress: _actorAddress,
            actorName: _actorName
        });
        // Update the actorIds array and handle its counter as needed
        actorIds.push(_actorId);
    }

    function getActorByKey(uint _actorId) public view returns (Actor memory) {
        require(actors[_actorId].actorId != 0, "Actor does not exist."); // Assuming 0 is not a valid ID
        return actors[_actorId];
    }

    function getActorIds() public view returns (uint[] memory) {
        return actorIds;
    }

    // ------ mapping : dataUsages ---- : add function is "public onlyOwner", get functions are "public view"
    function addDataUsage(
        string memory _serviceName,
        string memory _servicePurpose,
        uint _actorId,
        string[] memory _operations,
        uint[] memory _personalDataIds
    ) public onlyOwner {
        uint newDataUsageId = dataUsageCounter++;
        bytes32[] memory processedDatas = new bytes32[](_personalDataIds.length);
        
        for (uint i = 0; i < _personalDataIds.length; i++) {
            require(_personalDataIds[i] < personalDataCounter, "PersonalData does not exist.");
            processedDatas[i] = getProcessedPersonalDataByKey(_personalDataIds[i]);
        }

        // Add the new DataUsage with the processedPersonalDatas included
        dataUsages[newDataUsageId] = DataUsage({
            serviceName: _serviceName,
            servicePurpose: _servicePurpose,
            actorId: _actorId,
            operations: _operations,
            personalDataIds: _personalDataIds,
            processedPersonalDatas: processedDatas
        });

        // Update the counter for the data usage
        dataUsageCounter++;

        emit DataUsageAdded(newDataUsageId);
    }


    function getDataUsageByKey(uint _dataUsageId) public view returns (DataUsage memory) {
        require(_dataUsageId < dataUsageCounter, "DataUsage does not exist.");
        return dataUsages[_dataUsageId];
    }

    function getDataUsageCounter() public view returns (uint) {
        return dataUsageCounter;
    }
}