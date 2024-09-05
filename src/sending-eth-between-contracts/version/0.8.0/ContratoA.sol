// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

contract ContratoA {
    uint256 public number;
    string  public functionName;

    function balance() public view returns (uint256) {
        return address(this).balance;
    }

    function setNumber(uint256 num) public payable {
        number       = num;
        functionName = "setNumber";
    }

    receive() external payable {
        // number++;
        functionName = "receive";
    }

    fallback() external payable {
        // number++;
        functionName = "fallback";
    }
}