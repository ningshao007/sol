// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IERC165 {
    // 输入要查询的interfaceId接口id,若合约实现了该接口,则返回true
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}
