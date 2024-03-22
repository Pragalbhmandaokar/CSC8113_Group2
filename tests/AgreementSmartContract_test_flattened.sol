
// File: contracts/AccessControl.sol


pragma solidity ^0.8.0;

contract AccessControl {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

     modifier onlyOwner {
        require(msg.sender == owner, "Only the contract owner can perform this operation");
        _;
    }

}
// File: contracts/DataUsageSmartContract.sol


pragma solidity ^0.8.10;

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
        require(dataUsages[_actorConsentId].actorId != 0, "Data User does not exist.");
        return dataUsages[_actorConsentId];
    }

    function getDataUsageCounter() public view returns (uint) {
        return dataUsageCounter;
    }
}
// File: contracts/AgreementSmartContract.sol


pragma solidity ^0.8.10;



contract AgreementSmartContract is AccessControl {
    // Struct
    struct Consent {
        address purposeBlockAddress;        // = dataUsageSmartContractAddress, input
        uint userId;                        // input
        bool isConsented;                   // positive == true / negative == false, input
    }

    // Mapping
    mapping(uint => Consent) private consents;          // mapping consents <uint dataUsageId, Consent theConsent>
    uint[] private consentKeys;                         // key  = Consent.dataUsageId(uint)
    uint private consentsCounter = 0;                   // counter,(start from 0, ++ when add)


    // Function
    function addConsent(
        address _purposeBlockAddress,
        uint _userId,
        bool _isConsented
    ) public onlyOwner {
        
        consents[_userId] = Consent({
            purposeBlockAddress: _purposeBlockAddress,
            userId: _userId,
            isConsented: _isConsented
        });
        
        consentKeys.push(_userId);
        consentsCounter++;
    }

    function getConsentByKey(uint _dataUsageId) public view returns (Consent memory) {
        require(consents[_dataUsageId].userId != 0, "Consent does not exist.");
        return consents[_dataUsageId];
    }

    function getConsentCounter() public view returns (uint) {
        return consentsCounter;
    }

    function getConsentKeys() public view returns (uint[] memory) {
        return consentKeys;
    }

}

// File: contracts/LogSmartContract.sol


pragma solidity ^0.8.10;



contract LogSmartContract is AccessControl {
    enum Operations{
        read,
        write,
        transfer
    }

    // Struct
    struct Log {
        uint actorId;                                    // below all data get from this dataUsage
        Operations operations;
        string serviceName;
        bytes32 processedPersonalDatas;
    }

   // Mapping
    mapping(uint => Log) private logs;                  // mapping logs <uint dataUsageId, Log theLog>
    uint[] private logKeys;                             // key  = Log.dataUsageId(uint)
    uint private logCounter = 0;                       // counter,(start from 0, ++ when add)

    // Function 

    function addLog(uint _actorId,Operations _operation, bytes32 _processPersonalData, string memory _serviceName) public onlyOwner {
        // Retrieve the associated DataUsage record to ensure it exists
        //require(_dataUsageId < dataUsageSmartContract.getDataUsageCounter(),"Transaction number out of bounds");

        // Create the log record
        logs[_actorId] = Log({
            actorId: _actorId,
            operations: _operation,
            serviceName: _serviceName,
            processedPersonalDatas: _processPersonalData
        });
        
        logKeys.push(_actorId);
        logCounter++;
       
    }

    function getLogByKey(uint _dataActorId) public view returns (Log memory) {
        return logs[_dataActorId];
    }

    function getLogCounter() public view returns (uint) {
        return logCounter;
    }

    function getLogKeys() public view returns (uint[] memory) {
        return logKeys;
    }
}
 
// File: remix_tests.sol



pragma solidity >=0.4.22 <0.9.0;

library Assert {

  event AssertionEvent(
    bool passed,
    string message,
    string methodName
  );

  event AssertionEventUint(
    bool passed,
    string message,
    string methodName,
    uint256 returned,
    uint256 expected
  );

  event AssertionEventInt(
    bool passed,
    string message,
    string methodName,
    int256 returned,
    int256 expected
  );

  event AssertionEventBool(
    bool passed,
    string message,
    string methodName,
    bool returned,
    bool expected
  );

  event AssertionEventAddress(
    bool passed,
    string message,
    string methodName,
    address returned,
    address expected
  );

  event AssertionEventBytes32(
    bool passed,
    string message,
    string methodName,
    bytes32 returned,
    bytes32 expected
  );

  event AssertionEventString(
    bool passed,
    string message,
    string methodName,
    string returned,
    string expected
  );

  event AssertionEventUintInt(
    bool passed,
    string message,
    string methodName,
    uint256 returned,
    int256 expected
  );

  event AssertionEventIntUint(
    bool passed,
    string message,
    string methodName,
    int256 returned,
    uint256 expected
  );

  function ok(bool a, string memory message) public returns (bool result) {
    result = a;
    emit AssertionEvent(result, message, "ok");
  }

  function equal(uint256 a, uint256 b, string memory message) public returns (bool result) {
    result = (a == b);
    emit AssertionEventUint(result, message, "equal", a, b);
  }

  function equal(int256 a, int256 b, string memory message) public returns (bool result) {
    result = (a == b);
    emit AssertionEventInt(result, message, "equal", a, b);
  }

  function equal(bool a, bool b, string memory message) public returns (bool result) {
    result = (a == b);
    emit AssertionEventBool(result, message, "equal", a, b);
  }

  // TODO: only for certain versions of solc
  //function equal(fixed a, fixed b, string message) public returns (bool result) {
  //  result = (a == b);
  //  emit AssertionEvent(result, message);
  //}

  // TODO: only for certain versions of solc
  //function equal(ufixed a, ufixed b, string message) public returns (bool result) {
  //  result = (a == b);
  //  emit AssertionEvent(result, message);
  //}

  function equal(address a, address b, string memory message) public returns (bool result) {
    result = (a == b);
    emit AssertionEventAddress(result, message, "equal", a, b);
  }

  function equal(bytes32 a, bytes32 b, string memory message) public returns (bool result) {
    result = (a == b);
    emit AssertionEventBytes32(result, message, "equal", a, b);
  }

  function equal(string memory a, string memory b, string memory message) public returns (bool result) {
     result = (keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b)));
     emit AssertionEventString(result, message, "equal", a, b);
  }

  function notEqual(uint256 a, uint256 b, string memory message) public returns (bool result) {
    result = (a != b);
    emit AssertionEventUint(result, message, "notEqual", a, b);
  }

  function notEqual(int256 a, int256 b, string memory message) public returns (bool result) {
    result = (a != b);
    emit AssertionEventInt(result, message, "notEqual", a, b);
  }

  function notEqual(bool a, bool b, string memory message) public returns (bool result) {
    result = (a != b);
    emit AssertionEventBool(result, message, "notEqual", a, b);
  }

  // TODO: only for certain versions of solc
  //function notEqual(fixed a, fixed b, string message) public returns (bool result) {
  //  result = (a != b);
  //  emit AssertionEvent(result, message);
  //}

  // TODO: only for certain versions of solc
  //function notEqual(ufixed a, ufixed b, string message) public returns (bool result) {
  //  result = (a != b);
  //  emit AssertionEvent(result, message);
  //}

  function notEqual(address a, address b, string memory message) public returns (bool result) {
    result = (a != b);
    emit AssertionEventAddress(result, message, "notEqual", a, b);
  }

  function notEqual(bytes32 a, bytes32 b, string memory message) public returns (bool result) {
    result = (a != b);
    emit AssertionEventBytes32(result, message, "notEqual", a, b);
  }

  function notEqual(string memory a, string memory b, string memory message) public returns (bool result) {
    result = (keccak256(abi.encodePacked(a)) != keccak256(abi.encodePacked(b)));
    emit AssertionEventString(result, message, "notEqual", a, b);
  }

  /*----------------- Greater than --------------------*/
  function greaterThan(uint256 a, uint256 b, string memory message) public returns (bool result) {
    result = (a > b);
    emit AssertionEventUint(result, message, "greaterThan", a, b);
  }

  function greaterThan(int256 a, int256 b, string memory message) public returns (bool result) {
    result = (a > b);
    emit AssertionEventInt(result, message, "greaterThan", a, b);
  }
  // TODO: safely compare between uint and int
  function greaterThan(uint256 a, int256 b, string memory message) public returns (bool result) {
    if(b < int(0)) {
      // int is negative uint "a" always greater
      result = true;
    } else {
      result = (a > uint(b));
    }
    emit AssertionEventUintInt(result, message, "greaterThan", a, b);
  }
  function greaterThan(int256 a, uint256 b, string memory message) public returns (bool result) {
    if(a < int(0)) {
      // int is negative uint "b" always greater
      result = false;
    } else {
      result = (uint(a) > b);
    }
    emit AssertionEventIntUint(result, message, "greaterThan", a, b);
  }
  /*----------------- Lesser than --------------------*/
  function lesserThan(uint256 a, uint256 b, string memory message) public returns (bool result) {
    result = (a < b);
    emit AssertionEventUint(result, message, "lesserThan", a, b);
  }

  function lesserThan(int256 a, int256 b, string memory message) public returns (bool result) {
    result = (a < b);
    emit AssertionEventInt(result, message, "lesserThan", a, b);
  }
  // TODO: safely compare between uint and int
  function lesserThan(uint256 a, int256 b, string memory message) public returns (bool result) {
    if(b < int(0)) {
      // int is negative int "b" always lesser
      result = false;
    } else {
      result = (a < uint(b));
    }
    emit AssertionEventUintInt(result, message, "lesserThan", a, b);
  }

  function lesserThan(int256 a, uint256 b, string memory message) public returns (bool result) {
    if(a < int(0)) {
      // int is negative int "a" always lesser
      result = true;
    } else {
      result = (uint(a) < b);
    }
    emit AssertionEventIntUint(result, message, "lesserThan", a, b);
  }
}

// File: tests/AgreementSmartContract_test.sol



pragma solidity ^0.8.10;






contract AgreementSmartContractTest {
    AccessControl accessControl;
    AgreementSmartContract agreementContract;

    function beforeEach() public {
        agreementContract = new AgreementSmartContract();
    }

    function testAddConsent() public {
        address purposeBlockAddress = address(0x1);
        uint userId = 1;
        bool isConsented = true;

        agreementContract.addConsent(purposeBlockAddress, userId, isConsented);

        AgreementSmartContract.Consent memory consent = agreementContract.getConsentByKey(userId);

        Assert.equal(consent.purposeBlockAddress, purposeBlockAddress, "Purpose block address should match input.");
        Assert.equal(consent.userId, userId, "User ID should match input.");
        Assert.equal(consent.isConsented, isConsented, "Consent status should match input.");
    }

    function testConsentCounter() public {
        uint expected = 0;
        Assert.equal(agreementContract.getConsentCounter(), expected, "Initial consent counter should be 0.");

        agreementContract.addConsent(address(0x1), 1, true);
        expected += 1;
        Assert.equal(agreementContract.getConsentCounter(), expected, "Consent counter should increase after adding consent.");
    }

    function testConsentKeys() public {
        uint[] memory keys = agreementContract.getConsentKeys();
        Assert.equal(keys.length, 0, "Initial keys array should be empty.");

        agreementContract.addConsent(address(0x1), 1, true);
        keys = agreementContract.getConsentKeys();
        Assert.equal(keys.length, 1, "Keys array should contain one element after adding consent.");
        Assert.equal(keys[0], 1, "Keys array should contain the correct user ID.");
    }
}