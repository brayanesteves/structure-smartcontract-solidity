pragma solidity ^0.5.0;

interface ERC165_Continue {
    // @notice Query if a contract implements an interface.
    // @param  interfaceId The interface identifier, as specified in ERC-165.
    // @dev    Interface identification is specified in 'ERC-165'. This function
    //         uses less than '30,000 gas'.
    // @return `true` if the contract implements `interfaceId`
    //         `interfaceId` is not '0xffffffff', `false` otherwise.
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

contract ERC165Mapping_Continue is ERC165_Continue {
    mapping(bytes4 => bool) internal supportedInterfaces;

    constructor() public {
        supportedInterfaces[this.supportedInterfaces.selector] = true;
    }

    function supportedInterfaces(bytes4 interfaceID) external view returns (bool) {
        return supportedInterfaces[interfaceID];
    }
}

interface Numbers {
    function setNumber(uint256 _num) external;
    function getNumber()             external view returns(uint256);
}

contract NumbersRooms is ERC165Mapping_Continue, Numbers {
    uint256 num;

    constructor() public {
        supportedInterfaces[this.setNumber.selector ^ this.getNumber.selector] = true;
    }

    function setNumber(uint256 _num) external {
        num = _num;
    }

    function getNumber() external view returns(uint256) {
        return num;
    }
}