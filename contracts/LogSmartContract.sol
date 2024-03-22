// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract LogSmartContract {
    // Struct
    struct Log {
        bytes32 serviceName;
        address actorAddress;
        bytes32 operation;
        bytes32[] personalDataList;
    }

    // Mapping
    mapping(bytes32 => Log) public mapHashLog;

    // Event
    event LogAdded(bytes32 hashOfLog);

    // Function to add a log entry and return the hash of the log
    function addLog(
        bytes32 _serviceName,
        address _actorAddress,
        bytes32 _operation,
        bytes32[] memory _personalDataList
    ) public returns (bytes32) {
        // Generate the hash for the new log
        bytes32 hashOfLog = keccak256(
            abi.encodePacked(_serviceName, _actorAddress, _operation, _personalDataList)
        );

        // Ensure the log is unique and doesn't already exist
        require(
            mapHashLog[hashOfLog].actorAddress == address(0),
            "Log already exists for this hash."
        );

        // Create and store the new log
        mapHashLog[hashOfLog] = Log({
            serviceName: _serviceName,
            actorAddress: _actorAddress,
            operation: _operation,
            personalDataList: _personalDataList
        });

        // Emit the log added event
        emit LogAdded(hashOfLog);

        // Return the hash of the new log
        return hashOfLog;
    }
}
