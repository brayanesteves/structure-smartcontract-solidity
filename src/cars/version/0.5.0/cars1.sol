pragma solidity ^0.5.0;

contract Cars {
    address   owner;
    uint256   price;
    uint256[] identifiers;

    mapping(address => Car) cars;

    struct Car {
        uint256 identifier;
        string  brand;
        uint32  horses;
        uint32  kilometres;
    }

    modifier priceFilter(uint256 _price) {
        require(_price == price);
        _;
    }

    constructor(uint256 _price) public {
        owner = msg.sender;
        price = _price;
    }

    function addCar(uint256 _id, string _brand, uint32 _horses, uint32 _kilometres) public priceFilter(msg.value) payable {
        identifiers.push(_id);
        cars[msg.sender].identifier  = _id;
        cars[msg.sender].brand       = _brand;
        cars[msg.sender].horses      = _horses;
        cars[msg.sender].kilometres  = _kilometres;
    }

    function getIdentifiers() external view returns(uint256) {
        return identifiers.length;
    }

    function getCars() external view returns(string memory brand, uint32 horses, uint32 kilometres) {
        brand      = cars[msg.sender].brand;
        horses     = cars[msg.sender].horses;
        kilometres = cars[msg.sender].kilometres;        
    }

}