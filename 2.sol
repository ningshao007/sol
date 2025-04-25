// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

contract Incrementer {
    uint256 public number;

    event Increment(uint256 value);
    event Reset();

    constructor(uint256 initialValue) {
        number = initialValue;
    }

    function increment(uint256 value) public {
        require(value > 0, unicode"increment value should be positive number");
        number += value;

        emit Increment(value);
    }

    function reset() public {
        number = 0;
        emit Reset();
    }

    function getNumber() public view returns (uint256) {
        return number;
    }
}
