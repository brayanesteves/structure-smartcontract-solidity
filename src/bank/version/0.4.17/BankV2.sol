pragma solidity ^0.4.17;

contract BankV2 {

    address owner;

    modifier onlyOwner {
        /**
         * If to owner, continue.
         */
        require(msg.sender == owner);
        /**
         * Continue.
         */
        _;
    }

    /**
     * Reassign.
     */
    function newOwner(address _newOwner) public onlyOwner {
        owner = _newOwner;
    }

    function getOwner() view public returns(address) {
        return owner;
    }

    function getBalance() view public returns(uint256) {
        return address(this).balance;
    }

    /**
     * 'payable' Received money.
     */
    function BankV2() payable public {
        /**
         * Save in 'owner'.
         */
        owner = msg.sender;
    }

    function incrementBalance(uint256 amount) payable public {
        require(msg.value == amount);
    }

    function withdrawBalance() public onlyOwner {        
        msg.sender.transfer(address(this).balance);
    }

}