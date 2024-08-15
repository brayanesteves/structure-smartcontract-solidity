pragma solidity ^0.5.0;

contract Calculator {

    uint256 public number;
    address public sender;

    constructor() public {
        number = 0;
    }

    function add(uint256 _x) public returns(uint256, address) {
        require(_x > 0 && _x < 10, 'Error');
        sender  = msg.sender;
        number += _x;
        return(number, sender);
    }

}