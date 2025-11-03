// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

// 消耗gas require > assert > error
// required最常用的，其次是revert,assert很少用

// 可以在contract外定义使用
error TransferNotOwner();

contract Errors {
    mapping(uint256 => address) private _owners;

    function transferOwner1(uint256 tokenId, address newOwner) public {
        if (_owners[tokenId] != msg.sender) {
            revert TransferNotOwner();
        }
        _owners[tokenId] = newOwner;
    }

    function transferOwner2(uint256 tokenId, address newOwner) public {
        require(_owners[tokenId] == msg.sender, "transfer not owner");
        _owners[tokenId] = newOwner;
    }

    function transferOwner3(uint256 tokenId, address newOwner) public {
        assert(_owners[tokenId] == msg.sender);
        _owners[tokenId] = newOwner;
    }
}
