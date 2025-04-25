// SPDX-License-Identifier: MIT
contract DataStorage {
    // storage(默认状态,存储在链上)
    // memory(函数参数和临时变量,存储在内存中,不上链,如果返回数据类型是变长情况下(string,bytes,array和自定义结构),必须加memory修饰)
    // calldata,和memory类似,但是只读,不能修改

    uint[] public x = [1, 2, 3];

    function fStorage() public {
        // 修改xStorage也会影响到x
        uint[] storage xStorage = x;
        xStorage[0] = 100;
    }

    function fMemory() public view {
        // NOTE: 声明一个memory变量xMemory,复制x.修改xMemory不会影响x
        uint[] memory xMemory = x;
        xMemory[0] = 100;
        xMemory[3] = 200;
        uint[] memory xMemory2 = x;
        xMemory2[0] = 300;
    }

    function fCalldata(
        uint[] calldata _x
    ) public pure returns (uint[] calldata) {
        // NOTE: 这样会报错
        _x[0] = 0;
        return (_x);
    }
}

contract Variables {
    // 状态变量,局部变量,全局变量

    // 状态变量,存储在链上
    uint public x = 1;
    uint public y;
    string public z;

    function foo() external {
        x = 5;
        y = 1;
        z = "Hello";
    }

    // 局部变量,存储在内存中
    function bar() external pure returns (uint) {
        uint xx = 1;
        uint yy = 3;
        uint zz = xx + yy;
        return zz;
    }

    // 全局变量,solidity预留关键字
    function global() external view returns (address, uint, bytes memory) {
        address sender = msg.sender;
        uint blockNum = block.number;
        bytes memory data = msg.data;
        return (sender, blockNum, data);
    }
}
