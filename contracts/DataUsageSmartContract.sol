// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract DataUsageSmartContract {

    // Struct
    struct DataUsage {
        bytes32 serviceName;
        bytes32 servicePurpose;
        address actorAddress;
        bytes32 operation;
        bytes32[] personalDataList;
    }

    // Mapping: Key = hash value of the 5 properties in one data usage record
    mapping(bytes32 => DataUsage) public mapHashDataUsage;

    // Event
    event DataUsageAdded(bytes32 hashOfDataUsage);

    // Function
    function addDataUsage(
        bytes32 _serviceName,
        bytes32 _servicePurpose,
        address _actorAddress,
        bytes32 _operation,
        bytes32[] memory _personalDataList
    ) public returns (bytes32 hashOfDataUsage) {

        // Generate the hash for the new dataUsage
        hashOfDataUsage = keccak256(
            abi.encodePacked(_serviceName, _servicePurpose, _actorAddress, _operation, _personalDataList)
        );

        // Ensure that the dataUsage is not already stored
        require(
            mapHashDataUsage[hashOfDataUsage].actorAddress == address(0),
            "DataUsage already exists for this hash."
        );

        // Create and store the new dataUsage
        mapHashDataUsage[hashOfDataUsage] = DataUsage({
            serviceName: _serviceName,
            servicePurpose: _servicePurpose,
            actorAddress: _actorAddress,
            operation: _operation,
            personalDataList: _personalDataList
        });

        // Emit an event for the new dataUsage
        emit DataUsageAdded(hashOfDataUsage);

        // The function will return the hash of the data usage
        return hashOfDataUsage;
    }
}
