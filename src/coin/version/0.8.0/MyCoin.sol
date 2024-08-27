// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract MyCoin is IERC20 {
    address private owner;

    string public name;
    string public symbol;
    uint8  public decimals;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowed;

    uint256 private _totlaSupply;

    constructor(string memory name_, string memory symbol_, uint8 decimals_, uint256 suply_) {
         name                 = name_;
         symbol               = symbol_;
         decimals             = decimals_;
        _totlaSupply          = suply_ * (uint256(10)**decimals);
         owner                = msg.sender;
        _balances[msg.sender] = _totlaSupply;
    }

    function totalSupply() public view override returns (uint256) {
        return _totlaSupply;
    }

    function balanceOf(address _owner) public view override returns (uint256) {
        return _balances[_owner];
    }

    function allowance(address _owner, address spender) public view override returns (uint256) {
        return _allowed[_owner][spender];
    }

    function transfer(address to, uint256 value) public override returns (bool) {
        require(value <= _balances[msg.sender]);
        require(to != address(0));

        _balances[msg.sender] -= value;
        _balances[to]         += value;

        emit Transfer(msg.sender, to, value);

        return true;
    }

    function approve(address spender, uint256 value) public override returns (bool) {
        require(spender != address(0));

        _allowed[msg.sender][spender] = value;

        emit Approval(msg.sender, spender, value);

        return true;
    }

    function transferFrom(address from, address to, uint256 value) public override returns (bool) {
        require(value <= _balances[from]);
        require(value <= _allowed[from][msg.sender]);
        require(to != address(0));

        _balances[from]            -= value;
        _balances[to]              += value;
        _allowed[from][msg.sender] -= value;

        emit Transfer(from, to, value);

        return true;
    }
}