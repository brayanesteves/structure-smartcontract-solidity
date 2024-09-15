// SPDC-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts@4.5.0/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.5.0/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts@4.5.0/access/Ownable.sol";

contract TokenFractional is ERC20 {
    constructor(string memory p_name, string memory p_symbol, address p_to, uint256 p_amount) ERC20(p_name, p_symbol) {
        _mint(p_to, p_amount);
    }
}

contract Ffnt is ERC721, Ownable {
    uint256 s_counter;

    mapping(uint256 => address) s_FnftAddress;

    constructor() ERC721("My NTFs tokens", "MTK") { }

    function mint(address p_to, uint256 p_fraction) public onlyOwner {
        s_counter++;
        _mint(address(this), s_counter);

        // <FRACTIONAL> //
        // s_FnftAddress[s_counter] = address(new TokenFractional("Fractional token", string(abi.encodePacked("FFNT-", s_counter)), p_to, p_fraction * 10 **18));
        s_FnftAddress[s_counter] = address(new TokenFractional("Fractional token", string(abi.encodePacked("FFNT-", s_counter)), p_to, p_fraction));
        // <.FRACTIONAL> //
    }

    function tokenFractionAddress(uint256 p_tokenID) public view returns(address) {
        return s_FnftAddress[p_tokenID];
    }
}