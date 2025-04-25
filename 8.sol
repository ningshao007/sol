// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract Mapping {
    mapping(uint => address) public idToAddress;
    mapping(address => address) public swapPair;

    struct Student {
        uint256 id;
        uint256 score;
    }
    // NOTE: 错误,key只能是内置类型
    mapping(Student => uint) public testVar;

    function writeMap(uint _Key, address _Value) public {
        idToAddress[_Key] = _Value;
    }
}
