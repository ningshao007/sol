// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract Overload {
    // 函数重载
    function saySomething() public pure returns (string memory) {
        return "nothing";
    }
    function saySomething(
        string memory something
    ) public pure returns (string memory) {
        return something;
    }

    // 下面的会有问题
    function f(uint8 _in) public pure returns (uint8 out) {
        out = _in;
    }
    function f(uint256 _in) public pure returns (uint256 out) {
        out = _in;
    }
}
