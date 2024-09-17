pragma solidity ^0.5.0;

contract Oracle {
    address owner;
    uint public numberAsteroids;

    event __callbackNewData();

    modifier onlyOwner() {
        require(msg.sender == owner, 'Only owner.');
        _;
    }

    constructor() public {
        owner = msg.sender;
    }

    function update() public onlyOwner {
        emit __callbackNewData();
    }

    function setNumberAsteroids(uint _num) public onlyOwner {
        numberAsteroids = _num;
    }
}