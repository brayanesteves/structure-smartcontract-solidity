pragma solidity ^0.5.0;

contract VotingOverflow {

    mapping(address => uint8) public users;

    function sumVotes(address _user, uint8 _number) public {
        users[_user] = users[_user] + _number;
    }

    function subtractVotes(address _user, uint8 _number) public {
        users[_user] = users[_user] - _number;
    }

}