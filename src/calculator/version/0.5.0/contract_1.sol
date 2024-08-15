pragma solidity ^0.5.0;

contract Calculator {
    function add(uint256 _x) public returns(uint256, address) {

    }
}

contract contract_1 {

    uint256 public number;
    address public sender;

    Calculator public c;
    address    public other_contract;

    constructor(address _address) public {
        c              = Calculator(_address);
        other_contract = _address;
        number         = 0;
    }

    function addCallMethod(uint256 _x) external returns(uint256, address) {
        return c.add(_x);
    }

}