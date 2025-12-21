// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract Pair {
    address public factory;
    address public token0;
    address public token1;
    bool public initialized;

    constructor() payable {
        factory = msg.sender;
    }

    function initialize(address _token0, address _token1) external {
        require(msg.sender == factory, "UniswapV2: Forbidden");
        require(!initialized, "Already initialized");
        require(_token0 != address(0) && _token1 != address(0), "Zero address");
        initialized = true;
        token0 = _token0;
        token1 = _token1;
    }
}

contract PairFactory {
    mapping(address => mapping(address => address)) public getPair;
    address[] public allPairs;

    function createPair(
        address tokenA,
        address tokenB
    ) external returns (address pairAddr) {
        require(tokenA != tokenB, "Identical_addresses");
        require(tokenA != address(0) && tokenB != address(0), "Zero address");
        require(getPair[tokenA][tokenB] == address(0), "Pair exists");
        Pair pair = new Pair();
        pair.initialize(tokenA, tokenB);
        pairAddr = address(pair);
        allPairs.push(pairAddr);
        getPair[tokenA][tokenB] = pairAddr;
        getPair[tokenB][tokenA] = pairAddr;
    }
}

contract PairFactory2 {
    mapping(address => mapping(address => address)) public getPair;
    address[] public allPairs;

    function createPair2(
        address tokenA,
        address tokenB
    ) external returns (address pairAddr) {
        require(tokenA != tokenB, "Identical_addresses");
        require(tokenA != address(0) && tokenB != address(0), "Zero address");
        require(getPair[tokenA][tokenB] == address(0), "Pair exists");
        (address token0, address token1) = tokenA < tokenB
            ? (tokenA, tokenB)
            : (tokenB, tokenA);
        bytes32 salt = keccak256(abi.encodePacked(token0, token1));
        Pair pair = new Pair{salt: salt}();
        pair.initialize(tokenA, tokenB);
        pairAddr = address(pair);
        allPairs.push(pairAddr);
        getPair[tokenA][tokenB] = pairAddr;
        getPair[tokenB][tokenA] = pairAddr;
    }

    function calculateAddr(
        address tokenA,
        address tokenB
    ) external view returns (address predictedAddress) {
        require(tokenA != tokenB, "Identical_addresses");
        require(tokenA != address(0) && tokenB != address(0), "Zero address");
        (address token0, address token1) = tokenA < tokenB
            ? (tokenA, tokenB)
            : (tokenB, tokenA);
        bytes32 salt = keccak256(abi.encodePacked(token0, token1));
        predictedAddress = address(
            uint160(
                uint256(
                    keccak256(
                        abi.encodePacked(
                            bytes1(0xff),
                            address(this),
                            salt,
                            keccak256(type(Pair).creationCode)
                        )
                    )
                )
            )
        );
    }
}
