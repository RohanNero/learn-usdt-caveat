// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {PremiumCounter} from "../src/PremiumCounter.sol";

contract PremiumCounterScript is Script {
    PremiumCounter public premiumCounter;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        premiumCounter = new PremiumCounter();

        vm.stopBroadcast();
    }
}
