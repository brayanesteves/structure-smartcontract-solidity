// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

contract Counter {
    uint256 public number;
    uint256 public lastExecuted = block.timestamp;

    function increase() external {
        lastExecuted = block.timestamp;
        number++;
    }
}