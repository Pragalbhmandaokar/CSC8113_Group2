// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DataUsageSmartContract {
    enum Operation {
        Read,
        Write,
        Transfer
    }

    struct UserDetials{
        string name;
        string userAddress;
        uint userId;
        uint mobileNumber;
    }
    struct DataUsage {
        uint actorID;
        string serviceName;
        string servicePurpose;
        Operation operation;
        UserDetials personalData; /*[name, mobileNumber, Verified ID]  */
    }

    struct Actor{
        uint actorId;
        address actorAdress;
        string actorName;
    }

    DataUsage[] public dataUsages;
    // mapping(uint => DataUsage) public dataUsages;
    
    function addUserDetails(uint _userId, string memory name, string memory userAddress, uint mobileNumber) public {
        require(bytes(name).length > 0, "Service name must not be empty");
        require(bytes(userAddress).length > 0, "Service name must not be empty");

        emit UsageActivity(_actorId, _userID, data_usage);
    }
    //Array [] = {}
    function addDataUsage(uint _actorID, string memory _serviceName, string memory _servicePurpose, Operation _operation, UserDetials memory _personalData) public {
        dataUsages.push(DataUsage(_actorID, _serviceName, _servicePurpose, _operation, _personalData));
    }

    function getPurposeHash(uint index) public view returns (bytes32) {
        return keccak256(abi.encodePacked(dataUsages[index].actorID, dataUsages[index].serviceName));
    }
    
    
}

// Array [] = { } 