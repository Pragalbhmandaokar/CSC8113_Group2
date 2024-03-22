// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./AccessControl.sol";

contract DataUsageSmartContract is AccessControl {

    // Struct
    enum Operation{
        read,
        write,
        transaction
    }
    
    struct DataUsage {
        string serviceName;
        string servicePurpose;
        uint actorId;                       // associated with the actor
        Operation operations;                //  == "read", "write", "transfer"(multiple)
        uint personalDataIds;             // associated with proccessedPersonalData(byte32)
        bytes32 processedPersonalDatas;
    }

    struct PersonalData {
        uint userId;
        string userName;
        string userAddress;
        string userTelephone;
    }
    
    // Mapping
     mapping(uint => DataUsage) private dataUsages;              // mapping dataUsages <uint dataUsageId, DataUsage theDataUsage>
    // mapping(bytes32 => DataUsage) public mapHashedDataUsage;
    // Store Key of Mappings
    
    uint private dataUsageCounter = 0;
    uint[] private actorIds;
    uint private personalDataCounter = 0;
    
    // event emitProcessorPersonalData(bytes32 processPersonalData);
    // ------ mapping : personalDatas ---- : add\get PersonalData functions are "public onlyOwner", getCounter function is "public view"
    function addPersonalData(
        uint _userId,
        string memory  _userName,
        string memory  _userAddress,
        string memory  _userTelephone
    ) public pure returns (bytes32) {
         // Initialize a variable to concatenate the personal data fields
        bytes memory dataToHash;

        dataToHash = abi.encodePacked(
            _userId,
            _userName,
            _userAddress,
            _userTelephone
        );
   
        // Generate the hash of the concatenated data 
        bytes32 processedPersonalData = keccak256(dataToHash);
        return processedPersonalData;
    }

    
    function getPersonalDataCounter() public view returns (uint) {
        return personalDataCounter;
    }

    // ------ mapping : dataUsages ---- : add function is "public onlyOwner", get functions are "public view"
    function addDataUsage(
        string memory _serviceName,
        string memory _servicePurpose,
        uint _actorId,
        Operation _operations,
        uint _personalDataIds,
        bytes32 _proceedPersonalData
    ) public onlyOwner {

        // Add the new DataUsage with the processedPersonalDatas included
        dataUsages[_actorId] = DataUsage({
            serviceName: _serviceName,
            servicePurpose: _servicePurpose,
            actorId: _actorId,
            operations: _operations,
            personalDataIds: _personalDataIds,
            processedPersonalDatas: _proceedPersonalData
        });

        // Update the counter for the data usage
        dataUsageCounter++;

    }


    function getDataUsageByKey(uint _actorConsentId) public view returns (DataUsage memory) {
        return dataUsages[_actorConsentId];
    }

    function getDataUsageCounter() public view returns (uint) {
        return dataUsageCounter;
    }
}