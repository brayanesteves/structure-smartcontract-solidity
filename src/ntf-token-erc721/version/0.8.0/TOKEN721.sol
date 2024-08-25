// SPDC-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./CONTRACTS/ERC165.sol";
import "./INTERFACES/IERC721.sol";
import "./INTERFACES/IERC721Receiver.sol";

contract TOKEN721 is ERC165, IERC721 {

    // [ENG] What is 'address', owner of the token.
    // [ESP] Cuál es el 'address', dueña del token.
    mapping(uint256 => address) private _owners;
    // [ENG] How many tokens does an address have.
    // [ESP] Cuántos 'token' tiene una 'address'.
    mapping(address => uint256) private _balances;
    // [ENG] List of 'tokens' with 'addresses' approved for management.
    // [ESP] Relación de los 'token' con las 'address' aprobados para su gestión.
    mapping(uint256 => address) private _tokenApprovals;
    // [ENG] List of 'addresses' that can manage 'tokens' from other addresses.
    // [ESP] Relación de 'address' que pueden gestionar 'tokens' de otras 'address'.
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    // ============================== //

    function supportsInterface(bytes4 interfaceId) public view override(ERC165, IERC165) returns (bool) {
        return interfaceId == type(IERC721).interfaceId || super.supportsInterface(interfaceId);
    }

    // ============================== //

    function balanceOf(address owner) public view virtual override returns (uint256) {
        require(owner != address(0), "ERC721 ERROR: Zero address.");
        return _balances[owner];
    }

    function ownerOf(uint256 tokenId) public view virtual override returns (address) {
        address owner = _owners[tokenId];
        require(owner != address(0), "ERC721 ERROR: Token 'id' does not exist.");
        return owner;
    }

    function approve(address to, uint256 tokenId) public virtual override {
        address owner = ownerOf(tokenId);
        require(to != owner, "ERC721 ERROR: Destination 'address' must be different.");
        require(msg.sender == owner || isApprovedForAll(owner, msg.sender), "ERC721 ERROR: You are not the owner or you do not have permissions.");
        _approve(to, tokenId);
    }

    function _approve(address to, uint256 toknId) internal virtual {
        _tokenApprovals[tokenId] = to;
        emit Approval(ownerOf(tokenId), to, tokenId);
    }

    function getApproved(uint256 tokenId) public view virtual override returns (address) {
        require(_exists(tokenId), "ERC721 ERROR: Token 'id' does not exist.");
        return _tokenApprovals[tokenId];
    }

    function setApprovalForAll(address operator, bool approved) public virtual override {
        require(operator != msg.sender, "ERC721 ERROR: Operator 'address' must be different.");
        _operatorApprovals[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);
    }

    function isApprovedForAll(address owner, address operator) {
        return _operatorApprovals[owner][operator];
    }

    function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
        safeTransferFrom(from, to, tokenId, "");
    }

    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
        require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721 ERROR: You are not the 'owner' or you do not have permissions.");
        _safeTransfer(from, to, token, _data);
    }

    function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
        _transfer(from, to, tokenId);
        require(_checkOnERC721Received(address(from), to, tokenId, _data), "ERC721 ERROR: Transfer to non 'ERC721Receiver' implementer.");
    }

    function transferFrom(address from, address to, uint256 tokenId) public virtual override {
        require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721 ERROR: You are not the owner or you do not have permissions.");
        _transfer(from, to, tokenId);
    }

    function _transfer(address from, address to, uint256 tokenId) internal virtual {
        require(ownerOf(tokenId) == from, "ERC721 ERROR: Token 'id' does not exist.");
        require(to != address(0), "ERC721: Transfer to the 'zero' address.");

        _beforeTokenTransfer(from, to, tokenId);

        _approve(address(0), tokenId);

        _balances[from] -= 1;
        _balances[to]   += 1;
        _owners[tokenId] = to;

        emit Transfer(from, to, tokenId);
    }

    // ============================== //

    function _safeMint(address to, uint256 tokenId) public {
        _safeMint(to, tokenId, "");
    }

    function _safeMint(address to, uint256 tokenId, bytes memory _data) public {
        _mint(to, tokenId);
        require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721 ERROR: transfer to non ERC721Receiver implementer.");
    }

    function _min(address to, uint256 tokenId) internal virtual {
        require(to != address(0), "ERC721 ERROR: mint to the zero address.");
        require(!_exists(tokenId), "ERC721 ERROR: token already minted.");

        _beforeTokenTransfer(address(0), to, tokenId);

        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(address(0), to, tokenId);
    }

    // ============================== //

    function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data) private returns (bool) {
        if(isContract(to)) {
            try IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data) returns (bytes4 retval) {
                return retval == IERC721Receiver(to).onERC721Received.selector;
            } catch(bytes memory reason) {
                if(reason.length == 0) {
                    revert("ERC721: transfer to non ERC721Receiver implementer.");
                } else {
                    // solhint-disable-next-line no-inline-assembly.
                    assembly {
                            revert(add(32, reason), mload(reason))
                    }
                }
            }
        } else {
            return true;
        }
    }
    

    function isContract(address _addr) private view returns (bool) {
        uint32 size;
        assembly {
            size := extcodesize(_addr)
        }
        return(size > 0);
    }

    function _exists(uint256 tokenId) internal view virtual returns (bool) {
        return _owners[tokenId] != address(0);
    }

    function  _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual {

    }

    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
        require(_exists(tokenId), "ERC721 ERROR: Token 'id' does not exist.");
        address owner = ownerOf(tokenId);
        return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
    }

}