pragma solidity ^0.5.0;

contract MyToken {

    string public name;
    string public symbol;

    uint8   public decimal;
    uint256 public totalSuply;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    uint256 dividendPerToken;
    mapping(address => uint256) dividendBalanceOf;
    mapping(address => uint256) dividendCreditedTo;

    constructor() public {
        name                  = 'My Token';
        symbol                = 'MT';
        decimals              = 18;
        totalSuply            = 1000000 * (uint256(10) ** decimals);
        balanceOf[msg.sender] = totalSuply
    }

    function update(address _address) internal {
        uint256 debit = dividendPerToken - dividendCreditedTo[_address];
        
        dividendBalanceOf [_address] += balanceOf[_address] * debit;
        dividendCreditedTo[_address]  = dividendPerToken;
    }    

    function withdraw() public {
        update(msg.sender);
        uint256 amount = dividendBalanceOf[msg.sender];
        dividendBalanceOf[msg.sender] = 0;
        msg.sender.transfer(amount);
    }

    function deposit() public payable {
        dividendPerToken += msg.value / totalSuply;
    }

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    /**
     * [ENG] Transfer funds from 'address' to 'address'.
     * [ESP] Transferir fondos de 'address' a 'address'.
     */
    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value);
        update(msg.sender);
        update(_to);
                balanceOf[msg.sender] -= _value;
                balanceOf[_to]        += _value;

        emit Transfer(msg.sender, _to, _value);

        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
            allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender,   _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[_from]             >= _value);
        require(allowance[_from][msg.sender] >= _value);

                balanceOf[_from]             -= _value;
                balanceOf[_to]               += _value;
                allowance[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);

        return true;
    }
    
}