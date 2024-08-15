pragma solidity ^0.5.0;

contract Calculator {
    function add(uint256 _x) public returns(uint256, address) {

    }
}

contract contract_1_continue {

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

    function addCall1Method(uint256 _x) external returns(uint256, address) {
        (bool success, bytes memory data) = other_contract.call(abi.encodeWithSignature('add(uint256)', _x));
        
        // other_contract.call(bytes4(keccak256(add(uint256))), _x);
        
        require(success, "Error");

        (uint256 num, address address_sender) = abi.decode(data, (uint256, address));
    
        return (num, address_sender);
    }

    function addDelegateCall(uint256 _x) external returns(uint256, address) {
        (bool success, bytes memory data) = other_contract.delegatecall(abi.encodeWithSignature('add(uint256)', _x));

        require(success, "Error");

        (uint256 num, address address_sender) = abi.decode(data, (uint256, address));
    
        return (num, address_sender);
    }

}