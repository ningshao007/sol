// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;
contract Return {
    function returnMultiple()
        public
        pure
        returns (uint256, bool, uint256[3] memory)
    {
        // 把 1 转成 uint256 类型,后面的2,5类型会自动推断
        return (1, true, [uint256(1), 2, 5]);
    }

    function returnNamed()
        public
        pure
        returns (uint256 _number, bool _bool, uint256[3] memory _array)
    {
        _number = 2;
        _bool = false;
        _array = [uint256(3), 2, 1];
    }

    function returnNamed2()
        public
        pure
        returns (uint256 _number, bool _bool, uint256[3] memory _array)
    {
        return (1, true, [uint256(1), 2, 5]);
    }

    // 读取返回值，解构式赋值
    function readReturn() public pure {
        // 读取全部返回值
        uint256 _number;
        bool _bool;
        bool _bool2;
        uint256[3] memory _array;
        (_number, _bool, _array) = returnNamed();

        // 读取部分返回值，解构式赋值
        (, _bool2, ) = returnNamed();
    }
}
