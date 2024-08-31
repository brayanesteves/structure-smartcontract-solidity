// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

interface ICounter {
    function lastExecuted() external view returns (uint256);
    function increment()    external;
}

contract CounterResolver {
    address public immutable COUNTER;

    constructor(address _counter) {
        COUNTER = _counter;
    }

    function checker() external view returns (bool canExec, bytes memory execPayload) {
        uint256 lastExecuted = ICounter(COUNTER).lastExecuted();

        canExec = (block.timestamp - lastExecuted) > 20;

        execPayload = abi.encodedWithSelector(ICounter.increase.selector);
    }
}