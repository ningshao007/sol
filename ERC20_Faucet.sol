// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "./IERC20.sol";

contract Faucet {
    uint256 public amountAllowed = 100;
    address public tokenContract;
    mapping(address => bool) public requestedAddress;

    event SendToken(address indexed Receiver, uint256 indexed Amount);

    constructor(address _tokenContract) {
        tokenContract = _tokenContract;
    }

    function requestToken() external {
        require(!requestedAddress[msg.sender], "Cant request multiple times");
        /**
         * NOTE: 不是传参,而是类型转换
         * 把tokenContract这个地址当作一个实现了IERC20接口的合约来使用,它是一个部署了符合IERC20规范的合约,可以调用token.transfer,token.balanceOf等接口函数;
         */
        IERC20 token = IERC20(tokenContract);
        require(
            token.balanceOf(address(this)) >= amountAllowed,
            "Faucet Empty"
        );

        token.transfer(msg.sender, amountAllowed);
        requestedAddress[msg.sender] = true;

        emit SendToken(msg.sender, amountAllowed);
    }
}
