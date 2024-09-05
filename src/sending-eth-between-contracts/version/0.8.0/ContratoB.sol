// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

interface IContratoA {    
    function setNumber(uint256 num) external payable;
}

contract ContratoB {
    address    payable addressA;
    IContratoA private ContractA;

    constructor(address payable _addressA) {
        addressA  = _addressA;
        ContractA = IContratoA(addressA);
    }

    function setNumber() public payable {
        ContractA.setNumber{value: msg.value}(5);
    }

    function callSetNumber() public payable {
        (bool sent, ) = addressA.call{value:msg.value, gas:100000}(abi.encodeWithSignature("setNumber(5)", 5));
        require(sent, "ERROR.");
    }

    function sendETH() public payable {
        bool sent = addressA.send(msg.value);
        require(sent, "ERROR.");
    }

    function transferETH() public payable {
        addressA.transfer(msg.value);
    }

    function callETH() public payable {
        (bool sent, ) = addressA.call{value:msg.value, gas:100000}("");
        require(sent, "ERROR.");
    }

    function callXETH() public payable {
        (bool sent, ) = addressA.call{value:msg.value, gas:100000}(abi.encodedWithSignature("x(uint256)", 5));
        require(sent, "ERROR.");
    }
}