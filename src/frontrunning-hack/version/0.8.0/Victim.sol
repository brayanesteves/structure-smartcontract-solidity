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

contract ExampleHack1 {
    address public s_owner;
    string  public s_registration;
    uint256 public s_price;
    uint256        s_blockNum;
    address        DAI_ADDRESS = 0x6B17574E89894C44Da98b954EedeAC495271d0F;

    constructor(string memory p_registration) {
        s_owner        = msg.sender;
        s_registration = p_registration;
    }

    function setPrice(uint256 p_price) public {
        require(msg.sender == s_owner, "Not owner.");
        require(s_blockNum < block.number, "ERROR.");

        s_price = p_price;
    }

    function buy(address p_newOwner) public {
        require(s_price > 0, "Not for sales.");
        require(IERC20(DAI_ADDRESS).balanceOf(msg.sender) > s_price, "Insufficient funds.");
        require(IERC20(DAI_ADDRESS).allowence(msg.sender, address(this)) >= s_price, "Insufficient funds.");

        IERC20(DAI_ADDRESS).transferFrom(msg.sender, s_owner, s_price);

        s_owner = p_newOwner;
        delete s_price;

        s_blockNum = block.number;
    }
}