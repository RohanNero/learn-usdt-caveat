// SPDX-License-Identifier: GNU General Public License v3.0
pragma solidity ^0.8.13;


import {IUSDT} from "./interfaces/IUSDT.sol";
import {IERC20} from "./interfaces/IERC20.sol";

/**
 * @title PremiumCounter
 * @author Rohan Nero
 * @notice This contract was created to document the caveats of using USDT alongside standard conforming ERC20 tokens.
 */
contract PremiumCounter {

    /**@notice Used when the contract balance isn't updated when setting the number. */
    error PremiumCounter__TransferFailed();

    /**@notice Used to restrict payments to one of the three listed stablecoins for simplicity. */
    error PremiumCounter__InvalidToken();

    /**@notice The variable that users can pay to change. */
    uint256 public number;

    /**@notice Hard-coded stablecoin addresses on Etheruem mainnet for demonstration purposes. */
    address private constant usdt = 0xdAC17F958D2ee523a2206206994597C13D831ec7;
    address private constant usdc = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address private constant dai = 0x6B175474E89094C44Da98b954EedeAC495271d0F;


    /**@notice Allows anyone to set the number by paying 1 USDC/USDT/DAI. 
     * @dev Uses accurate EIP-20 function definitions.
    */
    function setNumberStandard(uint256 newNumber, address tokenAddr) public {
        require(tokenAddr == usdt || tokenAddr == usdc || tokenAddr == dai, PremiumCounter__InvalidToken());

        IERC20 token = IERC20(tokenAddr);
        uint initialBal = token.balanceOf(address(this));
        uint decimals = token.decimals();

        token.transferFrom(msg.sender, address(this), 1 * 10 ** decimals);

        uint bal = token.balanceOf(address(this));

        require(initialBal + 1 * 10 ** decimals == bal, PremiumCounter__TransferFailed());

        number = newNumber;
    }

    /**@notice Allows anyone to set the number by paying 1 USDC/USDT/DAI. 
     * @dev Uses USDT function definitions.
    */
    function setNumberNonStandard(uint256 newNumber, address tokenAddr) public {
        require(tokenAddr == usdt || tokenAddr == usdc || tokenAddr == dai, PremiumCounter__InvalidToken());

        IUSDT token = IUSDT(tokenAddr);
        uint initialBal = token.balanceOf(address(this));
        uint decimals = token.decimals();

        token.transferFrom(msg.sender, address(this), 1 * 10 ** decimals);

        uint bal = token.balanceOf(address(this));

        require(initialBal + 1 * 10 ** decimals == bal, PremiumCounter__TransferFailed());

        number = newNumber;
    }
}
