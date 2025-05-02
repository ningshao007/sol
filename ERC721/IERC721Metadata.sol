// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC721Metadata {
    // 返回代币名称
    function name() external view returns (string memory);
    // 代币代号
    function symbol() external view returns (string memory);
    // 通过tokenId查询metadata的链接url
    function tokenURI(uint256 tokenId) external view returns (string memory);
}
