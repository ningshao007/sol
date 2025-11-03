// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

error SendFailed();
error CallFailed();

// 3种方法发送ETH
// 1. transfer() 2300 gas ,revert, 不推荐
// 2. send() 2300 gas , return bool, 不推荐
// 3. call() all gas , return (bool, data).没有gas限制,需要手动处理revert.可以支持对方合约fallback()和receive()实现复杂逻辑,推荐

contract SendETH {
    // 构造函数,payable使得部署的时候可以转eth进去
    constructor() payable {}
    // receive函数,payable使得可以接收eth
    receive() external payable {}

    // 用transfer()发送eth,如果转账失败,会自动revert回滚交易
    function transferETH(address payable _to, uint256 amount) external payable {
        _to.transfer(amount);
    }

    // 用send()发送eth
    function sendETH(address payable _to, uint256 amount) external payable {
        bool success = _to.send(amount);
        if (!success) {
            revert SendFailed();
        }
    }

    // 用call()发送eth
    function callETH(address payable _to, uint256 amount) external payable {
        (bool success,) = _to.call{value: amount}("");
        if (!success) {
            revert CallFailed();
        }
    }
}

contract ReceiveETH {
    event Log(uint256 amount, uint256 gas);

    receive() external payable {
        emit Log(msg.value, gasleft()); // gasleft() 返回剩余的gas, 全局函数
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
