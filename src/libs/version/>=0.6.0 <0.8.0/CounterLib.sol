// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

library CounterLib {
    struct Counter {
        uint256 i;
    }

    event Incremented(uint256);

    function increment(Counter storage _counter) internal returns(uint256) {
        return ++_counter.i;
    }

    function increment_diff(Counter storage _counter) internal returns(uint256) {
        uint256 total = _counter.i + 1;
        emit Incremented(total);
        return ++_counter.i;
    }
}

contract CounterContract {
    using CounterLib for CounterLib.Counter;

    CounterLib.Counter counter;

    function increment() public returns(uint256) {
        return counter.increment();
    }

    function increment_diff() public returns(uint256) {
        return counter.increment_diff();
    }
}