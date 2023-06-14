pragma solidity ^0.4.17;

contract Count {
    /**
     * Variable status 
     */
    uint256 count;

    function Count(uint256 _count) public {
        count = _count;
    }

    function setCount(uint256 _count) public {
        count = _count;
    }

    function incrementCount() public {
        count += 1;
    }

    function getCount() public view returns(uint256) {
        return count;
    }

    function getNumber() public pure returns(uint256) {
        return 34;
    }
}