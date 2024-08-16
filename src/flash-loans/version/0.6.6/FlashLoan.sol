pragma solidity ^0.6.6;

import "https://github.com/aave/flashloan-box/blob/Remix/contracts/aave/FlashLoanReceiverBase.sol";         // Base Contract.
import "https://github.com/aave/flashloan-box/blob/Remix/contracts/aave/ILendingPoolAddressesProvider.sol"; //
import "https://github.com/aave/flashloan-box/blob/Remix/contracts/aave/ILendingPool.sol";                  // 

contract FlashLoan is FlashLoanReceiverBase {

    constructor(address _addressProvider) FlashLoanReceiverBase(_addressProvider) public {

    }

    function executeOperation(address _reserve, uint256 _amount, uint256 _fee, bytes calldata _params) external {
        require(_amount <= getBalanceInternal(address(this), _reserve), "Invalid balance, was the flashloan successful?");

        // Your logic goes here.
        // !! Ensure that *this contract* has enough of `_reserve` funds to payback the `_fee` !!

        uint totalDebt = _amount.add(_fee);
        transferFundsBackToPollInternal(_reserve, totalDebt);
    }

    function flashloan(address _asset) public onlyOwner {
        bytes memory data   = "";
        uint         amount = 1 ether; // 100000000000000 = 10^18

        ILendingPool lendingPool = ILendingPool(addressesProvider.getLendingPool());
        lendingPool.flashLoan(address(this), _asset, amount, data);
    }

}