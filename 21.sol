// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

// call 调用 另一个合约 的函数，使用被调用合约自己的存储空间 | 调用 另一个合约 的函数，但用自己的存储空间
// delegatecall  “跑到别人家，读写别人家的数据” | “请别人来我家帮我做事，改我自己的数据”

contract C {
    uint public num;
    address public sender;

    function setVars(uint _num) public payable {
        num = _num;
        sender = msg.sender;
    }
}

contract B {
    uint public num;
    address public sender;

    function callSetVars(address _addr, uint _num) external payable {
        (bool success, bytes memory data) = _addr.call(
            abi.encodeWithSignature("setVars(uint256)", _num)
        );
    }

    function delegatecallSetVars(address _addr, uint num) external payable {
        var () = _addr.delegatecall(
            abi.encodeWithSIgnature("setVars(uint256)", _num)
        );
    }
}
