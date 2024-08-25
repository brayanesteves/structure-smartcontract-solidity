// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract MultipleWithdraw {

    address private owner;

    modifier isOwner() {
        require(msg.sender == owner, "You are not authorized.");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function multipleWithdraw(address payable[] memory addresses, uint256[] memory amounts) public payable isOwner {
        require(addresses.length == amounts.length, "The length of the two 'arrays' must be equal.");
        
        uint256 totalAmounts = 0;
        
        for (uint256 i = 0; i < amounts.length; i++) {
            totalAmounts += amounts[i] * 1 wei;
        }

        require(totalAmounts == msg.value, "The value does not match.");

        for (uint256 i = 0; i < addresses.length; i++) {
            uint256 receiverAmount = amounts[i] * 1 wei;

            addresses[i].transfer(receiverAmount);
        }
    }

}