pragma solidity ^0.5.0;

import "./libs/openzeppelin-solidity/contracts/math/version/0.5.0/number/8/SafeMath8.sol";

contract VotingUnderflow {

    mapping(address => uint8) public users;

    using SafeMath8 for uint8;

    function sumVotes(address _user, uint8 _number) public {
        users[_user] = users[_user].add(_number);
    }

    function subtractVotes(address _user, uint8 _number) public {
        users[_user] = users[_user].sub(_number);
    }

}