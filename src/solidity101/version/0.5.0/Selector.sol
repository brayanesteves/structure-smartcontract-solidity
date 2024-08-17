pragma solidity ^0.5.0;

interface Solidity101 {
    function hello()    external pure;
    function world(int) external pure;
}

contract Selector {
    function calculateSelector() public pure returns(bytes4) {
        Solidity101 i;
        return i.hello.selector ^ i.world.selector;
    }
}