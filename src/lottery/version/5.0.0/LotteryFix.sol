pragma solidity ^0.5.0;

contract Lottery {

    address internal owner;
    uint256 internal num;
    uint256 public   numWinner;
    uint256 public   price;
    bool    public   game;
    address public   winner;
    uint256 public   initialInvestment;

    constructor(uint256 _numWinner, uint256 _price) public payable {
        owner             = msg.sender;
        num               = 0;
        numWinner         = _numWinner;
        price             = _price;
        game              = true;
        initialInvestment = msg.value;
    }

    function checkSuccess(uint256 _num) private view returns(bool) {
        if(_num == numWinner) {
            return true;
        } else {
            return false;
        }
    }

    /**
     *  ============================
     * |          RANDOM            |
     *  ============================
     * @Warning (Function vulnerable, possible hack).
     */
    function numberRandom() private view returns(uint256) {
        return uint256(keccak256(abi.encode(now, msg.sender, num))) % 10;
    }

    function participate() external payable returns(bool result, uint256 number) {
        require(game      == true);
        require(msg.value == price);
        uint256 numUser = numberRandom();
        bool    success = checkSuccess(numUser);
        if(success == true) {
            game   = false;
            msg.sender.transfer(initialInvestment + (num * (price / 2)));
            winner = msg.sender;
            result = true;
            number = numUser;
        } else {
            num++;
            result = false;
            number = numUser;
        }
    }

    function seeAward() public view returns(uint256) {
        if(game == true) {
            return initialInvestment + (num * (price / 2));
        } else {
            return 0;
        }
    }

    function withdrawContractFunds() external returns(uint256) {
        require(msg.sender == owner);
        require(game       == false);
        uint256 amount = address(this).balance;
        msg.sender.transfer(amount);
        return amount;
    }
}