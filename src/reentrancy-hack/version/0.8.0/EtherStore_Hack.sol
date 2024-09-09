// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EtherStore_Hack {
    mapping(address => uint256) public balances;

    function depositFounds() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() public {
        uint256 _balance = balances[msg.sender];
        require(_balance > 0);

        (bool success, ) = msg.sender.call{value: _balance}("");
        require(success, "ERROR.");

        delete balances[msg.sender];
        // balances[msg.sender] = 0;
    }

    function getBalances() public view returns (uint256) {
        return address(this).balance;
    }
}