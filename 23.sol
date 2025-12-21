// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract DeleteContract {
    uint public value = 10;
    address public owner;

    constructor(address _owner) payable {
        owner = _owner;
    }

    receive() external payable {}

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner");
        _;
    }

    // 新版本用destroy
    // 注意: EIP-6780 后, selfdestruct 在多数链上不再“彻底清除”
    function deleteContract() external onlyOwner {
        selfdestruct(payable(msg.sender));
    }

    function getBalance() external view returns (uint balance) {
        balance = address(this).balance;
    }
}
