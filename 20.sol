// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

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
    event Response(bool success, bytes data);

    // 高级调用，OtherContract(_Address).sexX
    // 低级调用 _addr.call{value:msg.value}(abi.encodeWithSignature("sexX(uint256)", x))
    function callSetX(address payable _addr, uint256 x) public payable {
        (bool success, bytes memory data) = _addr.call{value: msg.value}(abi.encodeWithSignature("setX(uint256)", x));

        emit Response(success, data);
        return abi.decode(data, (uint256));
    }

    function callGetX(address _addr) external returns (uint256) {
        (bool success, bytes memory data) = _addr.call(abi.encodeWithSignature("getX()"));

        emit Response(success, data);
        return abi.decode(data, (uint256));
    }

    function callNonExist(address _addr) external {
        (bool success, bytes memory data) = _addr.call(abi.encodeWithSignature("foo(uint256)"));

        emit Response(success, data);
    }
}
