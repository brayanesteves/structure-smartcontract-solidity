pragma solidity ^0.5.0;

contract IteratingLists {

    mapping(address => address) public users;
    uint256          public listSize;
    address constant public FIRST_ADDRESS = address(1);

    struct User {
        string firstName;
        string lastName;
        string email;
    }

    mapping(address => User) dataUsers;

    constructor() public {
        users[FIRST_ADDRESS] = FIRST_ADDRESS;
    }

    function isInList(address _address) internal view returns(bool) {
        return users[_address] != address(0);
    }

    function getPrevUser(address _address) internal view returns(address) {
        address currentAddress = FIRST_ADDRESS;
        while(users[currentAddress] != FIRST_ADDRESS) {
            if(users[currentAddress] == _address) {
                return currentAddress;
            }
            currentAddress = users[currentAddress];
        }
        return FIRST_ADDRESS;
    }

    function getAllUsers() public view returns(address[] memory) {
        address[] memory usersArray     = new address[](listSize);
        address          currentAddress = users[FIRST_ADDRESS];
        for(uint256 i = 0; currentAddress != FIRST_ADDRESS; i++) {
            usersArray[i]  = currentAddress;
            currentAddress = users[currentAddress];
        }
        return usersArray;
    }

    function removeUser(address _address) public {
        require(isInList(_address));
        address prevUsuer = getPrevUser(_address);
        users[prevUsuer]  = users[_address];
        users[_address]   = address(0);
        listSize--;
    }

    function addUser(address _address) public {
        require(!isInList(_address));
        users[_address]      =  users[FIRST_ADDRESS];
        users[FIRST_ADDRESS] = _address;
        listSize++;
    }
}