// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

contract Hello {
    string public message;

    function getMessage() public view returns (string memory) {
        return message;
    }

    function setMessage(string memory message_) public {
        message = message_;
    }
}