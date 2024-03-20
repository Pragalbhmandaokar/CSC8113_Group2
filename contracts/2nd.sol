
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract DataUsageSmartContract {

    enum Operation {
        Read,
        Write,
        Transfer
    }

    struct PersonalData {
        string UserID;
        string name;
        string user_address;
        string telephone;
    }

    struct DataUsage {
        address actorId;
        string serviceName;
        string servicePurpose;
        Operation operation;
        PersonalData personalData;
    }

    event UsageActivity(address indexed _actorid, string _userid, DataUsage _dataUsage);

    DataUsage[] public data_usage_contract;

    // Add record of DataUsage
    function addDataUsageRecord(
        address _actorId,
        string memory _serviceName,
        string memory _servicePurpose,
        Operation _operation,
        string memory _userID,
        string memory _name,
        string memory _user_address,
        string memory _telephone
    ) public {
        require(bytes(_serviceName).length > 0, "Service name must not be empty");
        require(bytes(_servicePurpose).length > 0, "Service purpose must not be empty");
        require(bytes(_userID).length > 0, "User ID must not be empty");
        require(bytes(_name).length > 0, "Name must not be empty");
        require(bytes(_user_address).length > 0, "User address must not be empty");
        require(bytes(_telephone).length > 0, "Telephone must not be empty");
        require(bytes(_user_address).length>0, "Invalid user address length");
        //phoneNumber should be 11 digits
        require(bytes(_telephone).length == 11, "Invalid telephone number length");
        require(_operation == Operation.Read || _operation == Operation.Write || _operation == Operation.Transfer, "Invalid operation");

        // address _actorId = msg.sender;
        // Typing actor address by ourselves
        PersonalData memory _personaldata = PersonalData(_userID, _name, _user_address, _telephone);
        DataUsage memory data_usage = DataUsage(_actorId, _serviceName, _servicePurpose, _operation, _personaldata);
        data_usage_contract.push(data_usage);

        emit UsageActivity(_actorId, _userID, data_usage);
    }

    function getDataUsageLength() public view returns (uint) {
        return data_usage_contract.length;
    }


    function getContractAddress() public view returns (address) {
        return address(this);
    }

    //Other contracts can get the data in here

    /*function getDataUsageRecord(uint index) public view returns (DataUsage memory) {
        require(index < data_usage_contract.length, "Index out of bounds");
        return data_usage_contract[index];
    }
    */

    function getDataUsageRecord(uint transactionNumber) public view returns (DataUsage memory) {
        require(transactionNumber < data_usage_contract.length, "Transaction number out of bounds");
        return data_usage_contract[transactionNumber];
}
}



}