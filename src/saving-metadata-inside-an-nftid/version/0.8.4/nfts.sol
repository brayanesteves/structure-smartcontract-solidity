// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract Travel is ERC721 {

    // <STATE> //
    uint256 constant REF_BOOKING_OFFSET     = 192; //  64 Bits.
    uint256 constant PRICE_BOOKING_OFFSET   =  80; // 112 Bits.
    uint256 constant TIMESTAMP_END_OFFSET   =  40; //  40 Bits.
    uint256 constant TIMESTAMP_START_OFFSET =   0; //  40 Bits.
    // <.STATE> //

    
    // <CONSTRUCTOR> //
    constructor() ERC721("TravelToken", "TTK") { }
    // <.CONSTRUCTOR> //

    
    // <PUBLIC FUNCTIONS> //
    // <SETTERS> //
    function safeMintNft(address to, uint256 ref, uint256 price, uint256 end, uint256 p_start) public {
        require(ref   <= 18446744073709551615,                                   "Error: Reference.");
        require(price <= 5192296858534827628530496329220095,                     "Error: Price.");
        require(end   <= 1099511627775 && start <= 1099511627775 && end > start, "Error: Times.");

        uint256 _ref     =  ref   << REF_BOOKING_OFFSET;
        uint256 _price   =  price << PRICE_BOOKING_OFFSET;
        uint256 _end     =  end   << TIMESTAMP_END_OFFSET;
        uint256  tokenId = _ref + _price + _end + start;

        _safeMint(to, tokenId);
    }
    // <.SETTERS> //

    // <GETTERS> //
    function getRef(uint256 tokenId) public pure returns(uint256) {
        uint256 refMask = 0xFFFFFFFFFFFFFFFF << REF_BOOKING_OFFSET;
        uint256 ref     = ((tokenId & refMask) >> REF_BOOKING_OFFSET);
        /**
        * Example Nº0:
        *  1100111 &
        *  0011100
        * ----------
        *  0000100
        *
        * Example Nº1:
        *  11010111 &
        *  11110000   --> |1111|0000 (Mask)
        * ----------
        *  11010000
        */
        return ref;
    }

    function getPrice(uint256 tokenId) public pure returns(uint256) {
        uint256 priceMask = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF << PRICE_BOOKING_OFFSET;
        uint256 price     = ((tokenId & priceMask) >> PRICE_BOOKING_OFFSET);
        
        return price;
    }

    function getEnd(uint256 tokenId) public pure returns(uint256) {
        uint256 timeMask = 0xFFFFFFFFFF << TIMESTAMP_END_OFFSET;
        uint256 time     = ((tokenId & timeMask) >> TIMESTAMP_END_OFFSET);
        
        return time;
    }

    function getStart(uint256 tokenId) public pure returns(uint256) {
        uint256 timeMask = 0xFFFFFFFFFF << TIMESTAMP_START_OFFSET;
        uint256 time     = ((tokenId & timeMask) >> TIMESTAMP_START_OFFSET);
        
        return time;
    }
    // <.GETTERS> //

    // <.PUBLIC FUNCTIONS> //
}