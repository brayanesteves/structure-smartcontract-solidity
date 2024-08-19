pragma solidity >=0.6.0 <0.8.0;

library MathLib {
    function add(uint256 _num1, uint256 _num2) internal pure returns(uint256) {
        return _num1 + _num2;
    }
}

contract Matematics {
    using MathLib for uint256;

    function add(uint256 _num1, uint256 _num2) public pure returns(uint256) {
        return _num1.add(_num2);
    }
}