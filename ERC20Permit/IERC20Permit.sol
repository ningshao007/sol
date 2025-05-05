// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20Permit {
    function permit(
        address owner,
        address spender,
        uint256 value,
        uint deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    // 每次成功调用{permit}都会将owner的nonce+1,防止多次使用签名
    function nonces(address owner) external view returns (uint256);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
}
