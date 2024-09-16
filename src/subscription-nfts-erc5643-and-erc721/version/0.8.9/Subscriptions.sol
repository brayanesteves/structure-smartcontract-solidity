// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface IERC5643 {
    event SubscriptionUpdate(uint256 indexed tokenId, uint64 expiration);
    
    function renewSubscription (uint256 tokenId, uint64 duration) external payable;
    function cancelSubscription(uint256 tokenId)                  external payable;
    function expiresAt         (uint256 tokenId)                  external view returns(uint64);
    function isRenewable       (uint256 tokenId)                  external view returns(bool);
}

contract Subscriptions is ERC721, Ownable, IERC5643 {
    
    uint256 count;

    mapping(uint256 => uint64)  private _expirations;
    
    // <CONSTRUCTOR>
    constructor(string memory name, string memory symbol) ERC721(name, symbol) { }
    // <.CONSTRUCTOR>
    
    // <PUBLIC FUUNCTIONS> //
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IERC5643).interfaceId || super.supportsInterface(interfaceId);
    }

    function safeMint(address to) public payable onlyOwner {
        _safeMint(to, count);

        uint64 newExpiration   = uint64(block.timestamp) + uint64(45642);
        _expirations[count]    = newExpiration;
        emit SubscriptionUpdate(count, newExpiration);

        count++;
    }
    function safeMint(address to, uint256 tokenId) public onlyOwner {
        _safeMint(to, tokenId);
    }

    function renewSubscription(uint256 tokenId, uint64 duration) public payable override {
        // RECEIVE MONEY.
        require(_isApprovedOrOwner(msg.sender, tokenId), "Caller is not owner nor approved.");

        uint64 currentExpiration = _expirations[tokenId];

        if (currentExpiration != 0) {            
            if(!_isRenewable(tokenId)) {
                revert("ERROR.");
            }
        }

        uint256 newExpiration = uint64(block.timestamp) + duration;
        
        _expirations[tokenId] = newExpiration;

        emit SubscriptionUpdate(tokenId, newExpiration);
    }

    function cancelSubscription(uint256 tokenId) public payable override {
        // Bussiness logical.
        require(_isApprovedOrOwner(msg.sender, tokenId), "Caller is not owner nor approved.");

        delete _expirations[tokenId];
        emit SubscriptionUpdate(tokenId, 0);
    }

    function expiresAt(uint256 tokenId) public view override returns(uint64) {
        return _expirations[tokenId];
    }

    function isRenewable(uint256 tokenId) internal pure returns(bool) {
        return _isRenewable(tokenId);
    }
    function _isRenewable(uint256 tokenId) internal pure returns(bool) {
        // Bussiness logical.
        return true;
    }
    // <.PUBLIC FUUNCTIONS> //
}