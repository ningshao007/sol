// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

event GlobalEvent(address indexed sender, uint256 value);

type UFixed18 is uint256;

using {add as +} for UFixed18 global;
function add(UFixed18 a, UFixed18 b) pure returns (UFixed18) {
    return UFixed18.wrap(UFixed18.unwrap(a) + UFixed18.unwrap(b));
}

contract SimpleContract {
    uint256 public counter;
    address private owner;
    string internal description;
    bool constant IS_ACTIVE = true;
    uint256 immutable creationTime;
    // transient uint256 public transientCounter;

    struct User {
        string name;
        uint256 balance;
        bool isActive;
    }

    enum Status {
        Pending,
        Active,
        Inactive
    }

    mapping(address => User) public users;
    mapping(address => mapping(address => bool)) public approvals;

    User[] public userList;
    Status public contractStatus = Status.Pending;

    event CounterIncremented(address indexed user, uint256 newValue);
    event UserAdded(address indexed userAddress, string name);
    event Received(address indexed sender, uint256 amount);

    error Unauthorized(address caller);
    error InsufficientBalance(uint256 available, uint256 required);

    modifier onlyOwner(){
      if(msg.sender != owner){
        revert Unauthorized(msg.sender);
     }
      _;
    }

    modifier withCodeBlock(){
      {
        uint localVar = 123;
        require(localVar > 0,unicode"应为正数")};
      _;
      }

    constructor(string memory _description) payable {
        owner = msg.sender;
        description = _description;
        creationTime = block.timestamp;
    }

    function basicFunctions(
        string calldata _name
    ) external returns (uint256, string memory) {
        counter++;

        User storage newUser = users[msg.sender];
        newUser.name = _name;
        newUser.isActive = true;

        User memory userCopy = User({name: _name, balance: 0, isActive: true});

        userList.push(userCopy);

        return (counter, _name);
    }

    function functionModifiers(
        uint256 a,
        uint256 b
    ) public view returns (address, uint256) {
        address currentOwner = owner;
        uint256 sum = _pureCalculation(a, b);
        return (currentOwner, sum);
    }

    function _pureCalculation(
        uint256 a,
        uint256 b
    ) private pure returns (uint256) {
        return a + b;
    }

    function deposit() public payable {
        if (msg.value == 0) {
            revert(unicode"不能存入0个ETH");
        }
        users[msg.sender].balance += msg.value;
        emit Received(msg.sender, msg.value);
    }

    function advancedFeaturesAndErrorHandling(
        address _user,
        address to,
        uint256 amount
    ) public returns (string memory name, uint256 balance, bool isActive) {
        User storage user = users[_user];
        name = user.name;
        balance = user.balance;
        isActive = user.isActive;

        try this.transferWithCustomError(to, amount) {} catch Error(
            string memory reason
        ) {} catch (bytes memory) {}
    }

    function transferWithCustomError(address to, uint256 amount) public {
        // require(
        //     users[msg.sender].balance >= amount,
        //     InsufficientBalance(users[msg.sender].balance3, amount)
        // );
        if (users[msg.sender].balance < amount) {
            revert InsufficientBalance(users[msg.sender].balance, amount);
        }

        users[msg.sender].balance -= amount;
        users[to].balance += amount;

        transientCounter += 1;
    }

    function dataOperations(
        uint256 a,
        uint256 b,
        string memory text
    )
        public
        pure
        returns (
            uint256 checkedSum,
            uint256 uncheckedSum,
            bytes memory encoded,
            bytes memory packed,
            bytes4 selector
        )
    {
        checkedSum = a + b;

        unchecked {
            uncheckedSum = a + b;
        }

        bytes memory textBytes = bytes(text);

        encoded = abi.encode(text, a);
        packed = abi.encodePacked(text, a);

        selector = this.dataOperations.selector;
    }

    function advancedOperations(uint256 x) public pure returns (UFixed18,uint256){
      UFFixed18 value = UFixed18.wrap(x);
      UFixed18 doubleValue = value + value;

      uint256 result;

      assembly {
        let temp :=add(x,1)

        if gt(x,100){
          temp := mul(temp,2)
        }

        verbatim_0i_10(hex"6001")

        result := temp
      }

      return (doubleValue,result)
    }

    fallback() external payable {
      emit Received(msg.sender,msg.value);
    }

    receive() external payable {
      emit Received(msg.sender,msg.value);
    }

    function getContractInfo() public view returns (address _owner,uint256 _creationTime,Status _status){
      _owner = owner;
      _creationTime = creationTime;
      _status = contractStatus;
    }
}
