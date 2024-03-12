// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

contract LogContract {
    struct Log {
        address actor;
        string operation;
        string processedData;
        string serviceName;
    }

    Log[] public logs;

    function addLog(
        address _actor,
        string memory _operation,
        string memory _processedData,
        string memory _serviceName
    ) public {
        logs.push(Log(_actor, _operation, _processedData, _serviceName));
    }
    
    function getLog(uint _index) public view returns (address actor, string memory operation, string memory processedData, string memory serviceName) {
        require(_index < logs.length, "Index out of bounds");
        Log storage log = logs[_index];
        return (log.actor, log.operation, log.processedData, log.serviceName);
    }
}
