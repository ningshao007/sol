// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "./12.sol";
import {Yeye} from "./12.sol";

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Import {
    using Address for address;
    Yeye yeye = new Yeye();

    function test() external {
        yeye.hip();
    }
}
