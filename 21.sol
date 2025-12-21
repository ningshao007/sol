// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract C {
    uint256 public num;
    address public sender;

    function setVars(uint256 _num) public payable {
        num = _num;
        sender = msg.sender;
    }
}

contract B {
    uint256 public num;
    address public sender;

    function callSetVars(address _addr, uint256 _num) external payable {
        (bool success, bytes memory data) = _addr.call(
            abi.encodeCall(C.setVars, (_num))
        );
        require(success, "Call failed");
        data;
    }

    function delegatecallSetVars(address _addr, uint256 _num) external payable {
        (bool success, bytes memory data) = _addr.delegatecall(
            abi.encodeCall(C.setVars, (_num))
        );
        require(success, "Delegatecall failed");
        data;
    }
}
