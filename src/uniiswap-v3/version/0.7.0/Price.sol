// SPDC-License-Identifier: MIT
pragma solidity ^0.7.0;

import "@uniswap/v3-periphery/contracts/libraries/OracleLibrary.sol";

interface IUNISWAPFACTORY {
    function getPool(address tokenA, address tokenB, uint24 fee) external view returns (address pool);
}

contract Price {
    address public s_pool;

    constructor(address p_token) {
        s_pool = IUNISWAPFACTORY(0x1F98431c8aD98523631AE4a59f267346ea31F984).getPool(0xc778417E063141139Fce010982780140Aa0cD5Ab, p_token, 3000);
    }

    function tokenAmount(uint128 p_amount) public view returns (uint256) {
        (uint24 tick,) = OracleLibrary.consult(s_pool, 60);

        return OracleLibrary.getQuoteAtTick(tick, p_amount, 0xfA7bA37bEA569f26C96AEdaEB0134a7172b4534, 0xC778417E063141139Fce01098278014Aa0cD5Ab);
    }

    function ethAmount(uint128 p_amount) public view returns (uint256) {
        (uint24 tick,) = OracleLibrary.consult(s_pool, 60);

        return OracleLibrary.getQuoteAtTick(tick, p_amount, 0xc778417E063141139Fce010982780140Aa0cD5Ab, 0xfA7bA37bEA569f26C96AEdaEB0134a7172b4534);
    }
}