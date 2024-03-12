// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

contract DataUsageContract {
    struct DataUsage {
        address actor;
        string serviceName;
        string servicePurpose;
        string operation;
        string personalData;
    }

    DataUsage[] public dataUsages;

    function addDataUsage(
        address _actor,
        string memory _serviceName,
        string memory _servicePurpose,
        string memory _operation,
        string memory _personalData
    ) public {
        dataUsages.push(DataUsage(_actor, _serviceName, _servicePurpose, _operation, _personalData));
    }
    
    function getDataUsage(uint _index) public view returns (address actor, string memory serviceName, string memory servicePurpose, string memory operation, string memory personalData) {
        require(_index < dataUsages.length, "Index out of bounds");
        DataUsage storage usage = dataUsages[_index];
        return (usage.actor, usage.serviceName, usage.servicePurpose, usage.operation, usage.personalData);
    }
}