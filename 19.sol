// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

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

    function getX() external view returns (uint256 x) {
        x = _x;
    }
}

// 类型转换
contract CallContract {
    // 这里的_Address是外部合约的地址
    // 将地址转换为合约类型,然后调用合约的setX函数.而不是new OtherContract(),两者有区别的
    function callSetX(address _Address, uint256 x) external {
        OtherContract(_Address).setX(x);
    }

    function callGetX(OtherContract _Address) external view returns (uint256 x) {
        x = _Address.getX();
    }

    function callGetX2(address _Address) external view returns (uint256 x) {
        OtherContract oc = OtherContract(_Address);
        x = oc.getX();
    }

    function setXTransferETH(address otherContract, uint256 x) external payable {
        OtherContract(otherContract).setX{value: msg.value}(x);
    }
}
