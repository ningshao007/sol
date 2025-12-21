// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "@openzeppelin/contracts/utils/Address.sol";

contract OtherContract {
    uint256 private _x = 0;

    event Log(uint256 amount, uint256 gas);

    fallback() external payable {}

    receive() external payable {}

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function setX(uint256 x) external payable {
        _x = x;
        if (msg.value > 0) {
            emit Log(msg.value, gasleft());
        }
    }

    function getX() external view returns (uint256 x) {
        x = _x;
    }
}

contract Call {
    using Address for address;

    event Response(address addr, bool success, bytes data);

    // 高级调用，OtherContract(_Address).setX
    // 低级调用 _addr.call{value:msg.value}(abi.encodeWithSignature("setX(uint256)", x))
    function callSetX(address payable _addr, uint256 x) public payable returns (bool) {
        require(_addr.isContract(), "Not contract");
        (bool success, bytes memory data) = _addr.call{value: msg.value}(
            abi.encodeCall(OtherContract.setX, (x))
        );

        emit Response(_addr, success, data);
        require(success, "Call failed");
        return true;
    }

    function callGetX(address _addr) external returns (uint256) {
        require(_addr.isContract(), "Not contract");
        (bool success, bytes memory data) = _addr.call(
            abi.encodeCall(OtherContract.getX, ())
        );

        emit Response(_addr, success, data);
        require(success, "Call failed");
        return abi.decode(data, (uint256));
    }

    function callNonExist(address _addr) external {
        (bool success, bytes memory data) = _addr.call(
            abi.encodeWithSignature("foo(uint256)")
        );

        emit Response(_addr, success, data);
    }
}
