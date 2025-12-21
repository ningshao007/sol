// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

abstract contract Base {
    string public name = "base";
    function getAlias() external pure virtual returns (string memory);

    function setName(string memory newName) public {
        name = newName;
    }
}

contract BaseImpl is Base {
    function getAlias() external pure override returns (string memory) {
        return "BaseImpl";
    }
}

contract Child is Base {
    constructor() {
        setName("child");
    }

    function updateName(string memory newName) external {
        setName(newName);
    }
}
