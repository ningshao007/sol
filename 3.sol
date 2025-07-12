// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract ValueTypes {
    bool public _bool = true;
    bool public _bool2 = !_bool;

    int256 public _int = -1;
    uint256 public _uint = 1;

    address public _address = 0x7A58c0Be72BE218B41C608b7Fe7C5bB630736C71;
    // 比普通地址多了transfer,send两个成员方法,用于接收转账
    address payable public _address1 = payable(_address);
    uint256 public balance = _address1.balance;

    // 定长字节,不定长字节
    // 给人看的用string;要存二进制数据用bytes;要高效处理做哈希或状态用bytes32/bytes1
    bytes32 public _bytes32 = "MiniSolidity"; // bytes32: 0x4d696e69536f6c69646974790000000000000000000000000000000000000000
    bytes1 public _bytes = _bytes32[0]; // bytes1: 0x4d

    enum ActionSet {
        Buy,
        Hold,
        Sell
    }

    ActionSet action = ActionSet.Buy;

    function enumToUint() external view returns (uint256) {
        return uint256(action);
    }
}
