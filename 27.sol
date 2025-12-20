// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract OnlyEven {
    error InvalidNumber();
    error NotEven();

    constructor(uint a) {
        if (a == 0 || a == 1) revert InvalidNumber();
    }

    function onlyEven(uint256 b) external pure returns (bool) {
        if (b % 2 != 0) revert NotEven();
        return true;
    }
}

contract TryCatch {
    event Success();
    event ErrorReason(string message);
    event PanicData(bytes data);

    OnlyEven immutable even;

    constructor() {
        even = new OnlyEven(2);
    }

    function execute(uint amount) external returns (bool success) {
        try even.onlyEven(amount) returns (bool _success) {
            emit Success();
            return _success;
        } catch Error(string memory reason) {
            emit ErrorReason(reason);
        } catch (bytes memory reason) {
            emit PanicData(reason);
        }
    }

    function executeNew(uint a) external returns (bool success) {
        try new OnlyEven(a) returns (OnlyEven _even) {
            emit Success();
            success = _even.onlyEven(a);
        } catch Error(string memory reason) {
            emit ErrorReason(reason);
        } catch (bytes memory reason) {
            emit PanicData(reason);
        }
    }
}
