// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "./IERC20.sol";

contract Faucet {
    uint256 public amountAllowed = 100;
    address public tokenContract;
    mapping(address => bool) public requestedAddress;
    address public owner;

    event SendToken(address indexed Receiver, uint256 indexed Amount);

    constructor(address _tokenContract) {
        require(_tokenContract != address(0), "Zero address");
        tokenContract = _tokenContract;
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner");
        _;
    }

    function setAmountAllowed(uint256 amount) external onlyOwner {
        require(amount > 0, "Amount zero");
        amountAllowed = amount;
    }

    function setTokenContract(address _tokenContract) external onlyOwner {
        require(_tokenContract != address(0), "Zero address");
        tokenContract = _tokenContract;
    }

    function resetRequester(address requester) external onlyOwner {
        requestedAddress[requester] = false;
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

        require(token.transfer(msg.sender, amountAllowed), "Transfer failed");
        requestedAddress[msg.sender] = true;

        emit SendToken(msg.sender, amountAllowed);
    }
}
