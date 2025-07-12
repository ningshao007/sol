// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract FunctionTypes {
    uint256 public number = 5;

    constructor() payable {}

    function add() external {
        number += 1;
    }

    function addPure(uint256 _number) external pure returns (uint256 new_number) {
        // 这里可不能写number,因为number是状态变量,状态变量不能在纯函数中使用
        new_number = _number + 1;
    }

    function addView() external view returns (uint256 new_number) {
        new_number = number + 1;
    }

    function minus() internal {
        number -= 1;
    }

    function minusCall() external {
        minus();
    }

    function minusPayable() external payable returns (uint256 balance) {
        minus();
        balance = address(this).balance;
    }
}
