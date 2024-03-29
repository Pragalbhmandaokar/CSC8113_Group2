# Solidity API

## AccessControl

### Contract
AccessControl : contracts/AccessControl.sol

 --- 
### Modifiers:
### onlyOwner

```solidity
modifier onlyOwner()
```

 --- 
### Functions:
### constructor

```solidity
constructor() public
```

## DataUsageSmartContract

### Contract
DataUsageSmartContract : contracts/DataUsageSmartContract.sol

 --- 
### Functions:
### addPersonalData

```solidity
function addPersonalData(uint256 _userId, string _userName, string _userAddress, string _userTelephone) public pure returns (bytes32)
```

### getPersonalDataCounter

```solidity
function getPersonalDataCounter() public view returns (uint256)
```

### addDataUsage

```solidity
function addDataUsage(string _serviceName, string _servicePurpose, uint256 _actorId, enum DataUsageSmartContract.Operation _operations, uint256 _personalDataIds, bytes32 _proceedPersonalData) public
```

### getDataUsageByKey

```solidity
function getDataUsageByKey(uint256 _actorConsentId) public view returns (struct DataUsageSmartContract.DataUsage)
```

### getDataUsageCounter

```solidity
function getDataUsageCounter() public view returns (uint256)
```

inherits AccessControl:

