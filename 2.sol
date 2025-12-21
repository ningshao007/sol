// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

contract Incrementer {
    uint256 public number;
    address public owner;

    event Increment(uint256 value);
    event Reset();

    constructor(uint256 initialValue) {
        owner = msg.sender;
        number = initialValue;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner");
        _;
    }

    function increment(uint256 value) public onlyOwner {
        require(value > 0, "increment value should be positive number");
        number += value;

        emit Increment(value);
    }

    function reset() public onlyOwner {
        number = 0;
        emit Reset();
    }
}
