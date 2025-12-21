// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "./23.sol";

contract DeployContract {
    struct DemoResult {
        address addr;
        uint balance;
        uint value;
    }

    constructor() payable {}

    function demo() public payable returns (DemoResult memory) {
        DeleteContract del = new DeleteContract{value: msg.value}(msg.sender);

        DemoResult memory res = DemoResult({
            addr: address(del),
            balance: del.getBalance(),
            value: del.value()
        });

        // 部署者(外部调用者)需在返回地址上自行调用 deleteContract()
        return res;
    }

    function demoAndDestroyAsOwner() public payable returns (DemoResult memory) {
        // 让本合约成为 owner, 以便在同一交易内自毁
        DeleteContract del = new DeleteContract{value: msg.value}(address(this));

        DemoResult memory res = DemoResult({
            addr: address(del),
            balance: del.getBalance(),
            value: del.value()
        });

        del.deleteContract();

        return res;
    }
}
