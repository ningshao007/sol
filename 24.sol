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
        DeleteContract del = new DeleteContract{value: msg.value}();

        DemoResult memory res = DemoResult({
            addr: address(del),
            balance: del.getBalance(),
            value: del.value()
        });

        del.deleteContract();

        return res;
    }
}
