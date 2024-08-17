pragma solidity ^0.5.0;

interface ERC165 {
    // @notice Query if a contract implements an interface.
    // @param  interfaceId The interface identifier, as specified in ERC-165.
    // @dev    Interface identification is specified in 'ERC-165'. This function
    //         uses less than '30,000 gas'.
    // @return `true` if the contract implements `interfaceId`
    //         `interfaceId` is not '0xffffffff', `false` otherwise.
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

contract ERC165Mapping is ERC165 {
    mapping(bytes4 => bool) internal supportedInterfaces;

    constructor() internal {
        supportedInterfaces[this.supportedInterfaces.selector] = true;
    }

    function supportedInterfaces(bytes4 interfaceID) external view returns (bool) {
        return supportedInterfaces[interfaceID];
    }
}