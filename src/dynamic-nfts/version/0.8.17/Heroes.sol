// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;


import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract Heroes is ERC721 {

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    using Strings for uint256;
    using Strings for uint128;

    // <STRUCT> //
    struct DataNFT {
        string  name;
        string  description;
        string  imageIPFS;
        uint128 level;
        uint128 life;
    }
    // <.STRUCT> //

    // <MAPPING> //
    mapping(uint256 => DataNFT) public tokensData;
    // <.MAPPING> //

    // <CONSTRUCTOR> //
    constructor() ERC721("Heroes", "H") { }
    // <.CONSTRUCTOR> //

    // <FUNCTION MINT> //
    function safeMint(string memory p_name, string memory p_description, string memory p_imageIPFS, uint128 p_level, uint128 p_life) public {
        _tokenIdCounter.increment();
        uint256 currentId = _tokenIdCounter.current();
        
        tokensData[currentId] = DataNFT(p_name, p_description, p_imageIPFS, p_level, uint128(block.timestamp) + p_life);

        _safeMint(msg.sender, currentId);
    }
    // <.FUNCTION MINT> //

    function incrementLevel(uint256 p_tokenId) public {
        tokensData[p_tokenId].level++;
    }
    function decrementLevel(uint256 p_tokenId) public {
        require(tokensData[p_tokenId].level > 0, "Level is zero.");
                tokensData[p_tokenId].level--;
    }

    // <TOKEN URI> //
    function tokenURI(uint256 tokenId) public view override(ERC721) returns (string memory) {
        return getTokenURI(tokenId);
    }
    // <.TOKEN URI> //

    // <GET TOKEN URI> //
    function getTokenURI(uint256 p_tokenId) internal view returns (string memory){
        DataNFT memory data = tokensData[p_tokenId];

        uint256  diffSeconds =   data.life - uint128(block.timestamp);
        uint256 _hours       =   diffSeconds / 1 hours;
        uint256 _minutes     =  (diffSeconds % 1 hours) / 1 minutes;
        uint256 _seconds     = ((diffSeconds % 1 hours) % 1 minutes) / 1 seconds;

        bytes memory dataURI = abi.encodePacked(
            '{',
                '"name": "', data.name, '",',
                '"description": "', data.description, '",',
                '"image": "ipfs://',  data.imageIPFS, '",',
                '"attributes": [',
                    '{', 
                        '"trait_type": "Level",', 
                        '"value": "', data.level.toString(), '"',
                    '},', 
                    '{', 
                        '"trait_type": "Life",', 
                        '"value": "', _hours.toString(), ':', _minutes.toString(), ':', _seconds.toString(), '"'
                    '}', 
                ']'
            '}'
        );

        return string(abi.encodePacked("data:application/json;base64,", Base64.encode(dataURI)));
    }
    // <.GET TOKEN URI> //

}