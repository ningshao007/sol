// SPDX-LICENSE-Identifier: MIT 
pragma solidity ^0.8.27; 
contract HelloWeb3 {
    string public _string = 'hello web3';

    function returnMultiple() public pure returns(uint256,bool,uint256[3] memory){
        return(1,true,[uint256(1),uint256(2),uint256(3)]);
    }

    uint[] x = [1,2,3];
    function fStorage() public {
        uint[] storage xStorage = x;
        xStorage[0] = 100;
    }
}