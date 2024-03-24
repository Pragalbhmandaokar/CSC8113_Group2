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

## AgreementSmartContract

### Contract
AgreementSmartContract : contracts/AgreementSmartContract.sol

 --- 
### Functions:
### addConsent

```solidity
function addConsent(address _purposeBlockAddress, uint256 _userId, bool _isConsented) public
```

### getConsentByKey

```solidity
function getConsentByKey(uint256 _dataUsageId) public view returns (struct AgreementSmartContract.Consent)
```

### getConsentCounter

```solidity
function getConsentCounter() public view returns (uint256)
```

### getConsentKeys

```solidity
function getConsentKeys() public view returns (uint256[])
```

inherits AccessControl:

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

## LogSmartContract

### Contract
LogSmartContract : contracts/LogSmartContract.sol

 --- 
### Functions:
### addLog

```solidity
function addLog(uint256 _actorId, enum LogSmartContract.Operations _operation, bytes32 _processPersonalData, string _serviceName) public
```

### getLogByKey

```solidity
function getLogByKey(uint256 _dataActorId) public view returns (struct LogSmartContract.Log)
```

### getLogCounter

```solidity
function getLogCounter() public view returns (uint256)
```

### getLogKeys

```solidity
function getLogKeys() public view returns (uint256[])
```

inherits AccessControl:

## Verification

### Contract
Verification : contracts/Verification.sol

 --- 
### Functions:
### constructor

```solidity
constructor(address _dataUsageSmartContractAddress, address _agreementSmartContractAddress, address _logSmartContractAddress) public
```

### verifyCompliance

```solidity
function verifyCompliance() public
```

### getViolators

```solidity
function getViolators() public view returns (uint256[])
```

In the revised verifyCompliance function:
            1 - It first fetches the keys for logs and consents.
            2 - It iterates over the log keys and, within that loop, iterates over the consent keys to find matches.
            3 - When a matching key is found, it performs the necessary verifications:
                    - Checks if the consent is given and the actor's ID matches.
                    - Compares the operations and processed personal data between the log and data usage entries.
            4 - If any discrepancies are found, it flags the actor as a violator.

inherits AccessControl:

 --- 
### Events:
### ActorFlaggedAsViolator

```solidity
event ActorFlaggedAsViolator(uint256 _actor, string _violationMessage)
```

inherits AccessControl:

