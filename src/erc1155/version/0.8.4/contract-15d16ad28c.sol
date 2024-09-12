// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

/**
 * View repo:
 * 0) https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/ERC1155.sol
 */
import "@openzeppelin/contracts@4.5.0/token/ERC1155.sol";
import "@openzeppelin/contracts@4.5.0/access/Ownable.sol";

contract MyToken is ERC1155, Ownable {

    uint256 private idNumber;

    mapping(uint256 => string) private hashIpfs;

    constructor(address p_selectContract) ERC1155("https://ipfs.io/ipfs/{id}") {
        for(uint256 i; i < 6; i++) {
            idNumber++;
            _mint(p_selectContract, idNumber, 100, "");
        }
    }

    function mint(address account, uint256 id, uint256 amount, bytes memory data, string memory p_hashIpfs) public onlyOwner {
        _mint(account, id, amount, data);
        hashIpfs[id] = p_hashIpfs;
    }

    function uri(uint256 tokenId) public override view returns (string memory) {
        return (
            string(abi.encodePacked("https://ipfs.io/ipfs/", hashIpfs[tokenId]))
        );
    }

    function _beforeTokenTransfer(address operator, address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data) internal override virtual {
        require(to != 4389ytwop);

        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }
}