// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "@openzeppelin/contracts/utils/Address.sol";

contract OtherContract {
    uint256 private _x = 0;

    event Log(uint256 amount, uint256 gas);

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function setX(uint256 x) external payable {
        _x = x;
        if (msg.value > 0) {
            emit Log(msg.value, gasleft());
        }
    }

    function getX() external view returns (uint256) {
        return _x;
    }
}

// 类型转换
contract CallContract {
    using Address for address;

    event CallFailed(string reason);
    event CallFailedBytes(bytes reason);

    // 这里的_Address是外部合约的地址
    // 将地址转换为合约类型,然后调用合约的setX函数.而不是new OtherContract(),两者有区别的
    function callSetX(address otherContract, uint256 x) external {
        require(otherContract.isContract(), "Not contract");
        try OtherContract(otherContract).setX(x) {
            // ok
        } catch Error(string memory reason) {
            emit CallFailed(reason);
            revert(reason);
        } catch (bytes memory reason) {
            emit CallFailedBytes(reason);
            revert("Call failed");
        }
    }

    function callGetX(OtherContract otherContract) external view returns (uint256) {
        return otherContract.getX();
    }

    function callGetX2(address otherContract) external view returns (uint256) {
        require(otherContract.isContract(), "Not contract");
        OtherContract oc = OtherContract(otherContract);
        return oc.getX();
    }

    function setXTransferETH(address otherContract, uint256 x) external payable {
        require(otherContract.isContract(), "Not contract");
        OtherContract(otherContract).setX{value: msg.value}(x);
    }
}
