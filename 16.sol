// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import {Yeye} from "./12.sol";
import "@openzeppelin/contracts/utils/Address.sol";

contract Import {
    using Address for address;
    Yeye public immutable yeye;

    constructor() {
        yeye = new Yeye();
    }

    function test() external {
        yeye.hip();
    }

    function testWithAddress() external {
        address(yeye).functionCall(abi.encodeWithSignature("hip()"));
    }
}
