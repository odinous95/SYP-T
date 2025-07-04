// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Lira} from "../src/Lira.sol";

contract DeployLira is Script {
    uint256 public initialSupply = 1000000 * 10 ** 18; // 1 million LIRA with 18 decimals

    function run() public returns (Lira) {
        vm.startBroadcast();
        Lira lira = new Lira(initialSupply);
        vm.stopBroadcast();
        return lira;
    }
}
