// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract DeleteContract {
    uint public value = 10;

    constructor() payable {}

    receive() external payable {}

    // 新版本用destroy
    function deleteContract() external {
        selfdestruct(payable(msg.sender));
    }

    function getBalance() external view returns (uint balance) {
        balance = address(this).balance;
    }
}
