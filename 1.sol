// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

type UFixed18 is uint256;

using {add as +} for UFixed18 global;
function add(UFixed18 a, UFixed18 b) pure returns (UFixed18) {
    return UFixed18.wrap(UFixed18.unwrap(a) + UFixed18.unwrap(b));
}

contract SimpleContract {
    uint256 public counter;
    address private owner;
    uint256 immutable creationTime;
    uint256 public transientCounter;

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
    mapping(address => uint256) private userIndex;

    User[] public userList;
    Status public contractStatus = Status.Pending;

    event CounterIncremented(address indexed user, uint256 newValue);
    event UserAdded(address indexed userAddress, string name);
    event Received(address indexed sender, uint256 amount);
    event Withdrawn(address indexed sender, uint256 amount);
    event BalanceTransferred(address indexed from, address indexed to, uint256 amount);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event StatusUpdated(Status previousStatus, Status newStatus);

    error Unauthorized(address caller);
    error InsufficientBalance(uint256 available, uint256 required);
    error ZeroAddress();
    error ZeroAmount();
    error TransferFailed();

    modifier onlyOwner() {
      if (msg.sender != owner) {
        revert Unauthorized(msg.sender);
      }
      _;
    }

    constructor() payable {
        owner = msg.sender;
        creationTime = block.timestamp;
    }

    function basicFunctions(
        string calldata _name
    ) external returns (uint256, string memory) {
        counter++;

        User storage user = users[msg.sender];
        user.name = _name;
        user.isActive = true;

        _upsertUserList(msg.sender);
        emit CounterIncremented(msg.sender, counter);

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
            revert ZeroAmount();
        }
        _credit(msg.sender, msg.value);
    }

    function advancedFeaturesAndErrorHandling(
        address _user,
        address to,
        uint256 amount
    ) public returns (string memory name, uint256 balance, bool isActive) {
        if (_user != msg.sender) {
            revert Unauthorized(msg.sender);
        }
        User storage user = users[_user];
        name = user.name;
        balance = user.balance;
        isActive = user.isActive;

        _transferWithCustomError(_user, to, amount);
    }

    function transferWithCustomError(address to, uint256 amount) public {
        _transferWithCustomError(msg.sender, to, amount);
    }

    function _transferWithCustomError(address from, address to, uint256 amount) internal {
        if (to == address(0)) {
            revert ZeroAddress();
        }
        if (amount == 0) {
            revert ZeroAmount();
        }
        if (users[from].balance < amount) {
            revert InsufficientBalance(users[from].balance, amount);
        }

        users[from].balance -= amount;
        users[to].balance += amount;
        users[to].isActive = true;

        transientCounter += 1;
        emit BalanceTransferred(from, to, amount);
        _syncUserListIfExists(from);
        _syncUserListIfExists(to);
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

        encoded = abi.encode(text, a);
        packed = abi.encodePacked(text, a);

        selector = this.dataOperations.selector;
    }

    function advancedOperations(uint256 x) public pure returns (UFixed18, uint256) {
        UFixed18 value = UFixed18.wrap(x);
        UFixed18 doubleValue = value + value;

        uint256 result;

        assembly {
            let temp := add(x, 1)

            if gt(x, 100) {
                temp := mul(temp, 2)
            }

            result := temp
        }

        return (doubleValue, result);
    }

    fallback() external payable {
        _credit(msg.sender, msg.value);
    }

    receive() external payable {
        _credit(msg.sender, msg.value);
    }

    function getContractInfo() public view returns (address _owner, uint256 _creationTime, Status _status) {
        _owner = owner;
        _creationTime = creationTime;
        _status = contractStatus;
    }

    function withdraw(uint256 amount) public {
        if (amount == 0) {
            revert ZeroAmount();
        }
        if (users[msg.sender].balance < amount) {
            revert InsufficientBalance(users[msg.sender].balance, amount);
        }
        users[msg.sender].balance -= amount;
        _syncUserListIfExists(msg.sender);

        (bool success, ) = msg.sender.call{value: amount}("");
        if (!success) {
            revert TransferFailed();
        }
        emit Withdrawn(msg.sender, amount);
    }

    function setStatus(Status newStatus) external onlyOwner {
        Status previousStatus = contractStatus;
        contractStatus = newStatus;
        emit StatusUpdated(previousStatus, newStatus);
    }

    function transferOwnership(address newOwner) external onlyOwner {
        if (newOwner == address(0)) {
            revert ZeroAddress();
        }
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

    function _credit(address user, uint256 amount) internal {
        if (amount == 0) {
            return;
        }
        users[user].balance += amount;
        users[user].isActive = true;
        _syncUserListIfExists(user);
        emit Received(user, amount);
    }

    function _upsertUserList(address user) internal {
        User memory snapshot = users[user];
        uint256 index = userIndex[user];
        if (index == 0) {
            userList.push(snapshot);
            userIndex[user] = userList.length;
            emit UserAdded(user, snapshot.name);
        } else {
            userList[index - 1] = snapshot;
        }
    }

    function _syncUserListIfExists(address user) internal {
        uint256 index = userIndex[user];
        if (index != 0) {
            userList[index - 1] = users[user];
        }
    }
}
