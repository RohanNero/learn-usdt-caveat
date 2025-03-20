// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {PremiumCounter} from "../src/PremiumCounter.sol";

import {IUSDT} from "../src/interfaces/IUSDT.sol";
import {IERC20} from "../src/interfaces/IERC20.sol";

/**@notice Used to showcase the differences in behavior when interacting with tokens that don't accurately match the ERC-20 standard. 
 * @dev From the tests we can conclude a couple of things:
 *      1. When using tokens that conform to the ERC20 standard, the functions that traditionally return values, don't necessarily need to return the value.
 *         e.g. You can remove the `returns (bool success)` from the `transferFrom()` function in the IERC20 interface and the code will still work.
 *      2. When using tokens that don't conform to the ERC20 standard by excluding certain return values, you need to use the inaccurate/modified function signatures 
 *         or the call will fail.
*/
contract PremiumCounterTest is Test {
    PremiumCounter public premiumCounter;

    /**@notice We impersonate this address for our calls since it eternally holds USDC, USDT, and DAI on Mainnet. */
    address private constant boss = 0x000000000000000000000000000000000000dEaD;

    /**@notice Hard-code three stablecoin addresses on Etheruem mainnet for demonstration purposes. */
    address private constant usdt = 0xdAC17F958D2ee523a2206206994597C13D831ec7;
    address private constant usdc = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address private constant dai = 0x6B175474E89094C44Da98b954EedeAC495271d0F;

    function setUp() public {
        premiumCounter = new PremiumCounter();
    }

    /**@notice Tests using accurate IERC20 methods with USDC. */
    function test_setNumberStandardUSDC() public {
        /** Setup */
        vm.startPrank(boss);
        IERC20 token = IERC20(usdc);
        token.approve(address(premiumCounter), 1e6);
        uint initialBal = token.balanceOf(boss);
        
        premiumCounter.setNumberStandard(7, usdc);

        /** Assertions */
        uint bal = token.balanceOf(boss);
        assertEq(premiumCounter.number(), 7);
        /** Since USDC uses 6 decimals it should take 1_000_000 from boss */
        assertEq(initialBal - 1e6, bal);
        vm.stopPrank();
    }
    
    /**@notice Tests using inaccurate USDT methods with USDC. 
     * @dev I.e. `transferFrom()` doesnt return a boolean. */
    function test_setNumberNonStandardUSDC() public {
        /** Setup */
        vm.startPrank(boss);
        IERC20 token = IERC20(usdc);
        token.approve(address(premiumCounter), 1e6);
        uint initialBal = token.balanceOf(boss);
        
        premiumCounter.setNumberNonStandard(7, usdc);

        /** Assertions */
        uint bal = token.balanceOf(boss);
        assertEq(premiumCounter.number(), 7);

        /** Since USDC uses 6 decimals it should take 1_000_000 from boss */
        assertEq(initialBal - 1e6, bal);
        vm.stopPrank();
    }

    /**@notice Test viewing the return data from an ERC20 transfer made with `call`.*/
    function test_callUSDC() public {
        /** Setup */
        vm.startPrank(boss);
        IERC20 token = IERC20(usdc);
        token.approve(boss, 1e6);
        uint initialBal = token.balanceOf(boss);
        
        (bool success, bytes memory data) = usdc.call(abi.encodeWithSignature("transferFrom(address,address,uint256)", boss, address(premiumCounter), 1e6));

        /** Assertions */
        uint bal = token.balanceOf(boss);
        assertEq(initialBal - 1e6, bal);
        assertTrue(success);
        assertTrue(abi.decode(data,(bool)));
        vm.stopPrank();
    }

    /**@notice Tests using accurate IERC20 methods with USDT. */
    function testFail_setNumberStandardUSDT() public {
        /** Setup */
        vm.startPrank(boss);
        IUSDT token = IUSDT(usdt);
        token.approve(address(premiumCounter), 1e8);
        uint initialBal = token.balanceOf(boss);
        uint initialNum = premiumCounter.number();
        
        /** Since the ERC20 method expects a non-existent bool to be returned, the transferFrom() fails */
        premiumCounter.setNumberStandard(7, usdt);

        /** Assertions */
        assertEq(premiumCounter.number(), initialNum);

        /** Since the call fails the balance is unchanged */
         uint bal = token.balanceOf(boss);
        assertEq(initialBal, bal);
        vm.stopPrank();
    }
    
    /**@notice Tests using inaccurate USDT methods with USDT. 
     * @dev I.e. `transferFrom()` doesnt return a boolean. */
    function test_setNumberNonStandardUSDT() public {
        /** Setup */
        vm.startPrank(boss);
        IUSDT token = IUSDT(usdt);
        token.approve(address(premiumCounter), 1e6);
        uint initialBal = token.balanceOf(boss);
        
        premiumCounter.setNumberNonStandard(7, usdt);

        /** Assertions */
        assertEq(premiumCounter.number(), 7);
        /** Since USDC uses 6 decimals it should take 1_000_000 from boss */
        uint bal = token.balanceOf(boss);
        assertEq(initialBal - 1e6, bal);
        vm.stopPrank();
    }

    /**@notice Test viewing the return data from an ERC20 transfer made with `call`.*/
    function test_callUSDT() public {
        /** Setup */
        vm.startPrank(boss);
        IUSDT token = IUSDT(usdt);
        token.approve(boss, 1e6);
        uint initialBal = token.balanceOf(boss);
        
        (bool success, bytes memory data) = usdt.call(abi.encodeWithSignature("transferFrom(address,address,uint256)", boss, address(premiumCounter), 1e6));
        
        /** Assertions */
        uint bal = token.balanceOf(boss);
        assertEq(initialBal - 1e6, bal);
        assertTrue(success);
        assertEq(data.length, 0);
        assertEq(data, hex"");
        vm.stopPrank();
    }



    /**@notice Tests using accurate IERC20 methods with USDT. */
    function test_setNumberStandardDAI() public {
        /** Setup */
        vm.startPrank(boss);
        IERC20 token = IERC20(dai);
        token.approve(address(premiumCounter), 1e18);
        uint initialBal = token.balanceOf(boss);
        
        premiumCounter.setNumberStandard(7, dai);

        /** Assertions */
        uint bal = token.balanceOf(boss);
        assertEq(premiumCounter.number(), 7);

        /** Since DAI uses 18 decimals it should take 1_000000_000000_000000 from boss */
        assertEq(initialBal - 1e18, bal);
        vm.stopPrank();
    }
    
    /**@notice Tests using inaccurate USDT methods with DAI. 
     * @dev I.e. `transferFrom()` doesnt return a boolean. */
    function test_setNumberNonStandardDAI() public {
        /** Setup */
        vm.startPrank(boss);
        IERC20 token = IERC20(dai);
        token.approve(address(premiumCounter), 1e18);
        uint initialBal = token.balanceOf(boss);
        
        premiumCounter.setNumberNonStandard(7, dai);

        /** Assertions */
        uint bal = token.balanceOf(boss);
        assertEq(premiumCounter.number(), 7);

        /** Since DAI uses 18 decimals it should take 1_000000_000000_000000 from boss */
        assertEq(initialBal - 1e18, bal);
        vm.stopPrank();
    }
    
}
