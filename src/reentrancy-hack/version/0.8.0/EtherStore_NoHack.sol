// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EtherStore_NoHack {
    mapping(address => uint256) public balances;

    function depositFounds() public payable {
        balances[msg.sender] += msg.value;
    }

    modifier security() {
        require(!flag, "ERROR.");
        flag = true;
        _;
        flag = false;
    }

    function withdraw() public security {
        // bool flag;
        // require(!flag, "ERROR.");
        // flag = true;

        uint256 _balance = balances[msg.sender];
        require(_balance > 0);

        /**
         * Avoid the hack.
         * The problem is that the contract is not able to send Ether to the user.
         */
        delete balances[msg.sender];
        // balances[msg.sender] = 0;

        (bool success, ) = msg.sender.call{value: _balance}("");
        require(success, "ERROR.");

    }

    function getBalances() public view returns (uint256) {
        return address(this).balance;
    }
}