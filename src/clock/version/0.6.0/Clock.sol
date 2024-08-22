// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import "@chainlink/contracts/src/v0.6/ChainlinkClient.sol";

contract Clock is ChainlinkClient {

    bool public alarmDone;

    address private oracle;
    bytes32 private jobId;
    uint256 private fee;

    constructor() public {
        setChainlinkToken(0xa36085F69e2889c224210F603D836748e7dC0088);
        oracle    = 0x2f90A6D021db21e1B2A077c5a3783C7E75D15b7e;
        jobId     = "a7ab70d561d34eb49e9b1612fd2e044b";
        fee       = 0.1 * 10**18; // 0.1 LINK.
        alarmDone = false;
    }

    function requestAlarmClock(uint256 durationInSeconds) public returns (bytes32 requestId) {
        Chainlink.Request memory request = buildChainlinkRequest(jobId, address(this), this.fulfillAlarm.selector);
        request.addUint("until", block.timestamp + durationInSeconds);
        return sendChainlinkRequestTo(oracle, request, fee);
    }

    function fulfillAlarm(bytes32 _requestId) public recordChainlinkFulfillment(_requestId) {
        alarmDone = true;
    }

    function withdrawLink() external {
        LinkTokenInterface linkToken = LinkTokenInterface(chainlinkTokenAddress());
        require(linkToken.transfer(msg.sender, linkToken.balanceOf(address(this))), "Unable to transfer");
    }
}