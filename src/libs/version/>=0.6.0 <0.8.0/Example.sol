// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

library L {
    function returnAddress() public view returns() {
        return address(this);
    }
    function returnAddress_Internal() internal view returns() {
        return address(this);
    }
}

contract Main {
    /**
    * Example:
    * Address 'main':     0xd8b934580fcE3Sa11B58C6D73aDeE468a2833fa8
    * Address 'receptor': 0xf8e81D47203A594245E36C48e151709F0C19fBe8
    */
    function a() public view returns(address) {
        return L.returnAddress();
    }

    // Generate 'contract'.
    function a_internal() public view returns(address) {
        return L.returnAddress_Internal();
    }
}