// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import {Test, console} from "forge-std/Test.sol";
import {Lira} from "../src/Lira.sol";
import {DeployLira} from "../script/DeployLira.s.sol";

contract LiraTest is Test {
    Lira public lira;
    DeployLira public deployLira;
    // Addresses for testing
    address Mohamed = makeAddr("Mohamed");
    address Ali = makeAddr("Ali");
    uint256 MohamedInitialBalance = 1000 * 10 ** 18; // 1000 LIRA with 18 decimals

    function setUp() public {
        deployLira = new DeployLira();
        // Deploy the Lira contract with the initial supply
        lira = deployLira.run();

        vm.prank(msg.sender);
        lira.transfer(Mohamed, MohamedInitialBalance);
    }

    function testName() public view {
        assertEq(lira.name(), "Lira");
    }

    function testSymbol() public view {
        assertEq(lira.symbol(), "LIRA");
    }

    function testMohamedBalance() public view {
        uint256 balance = lira.balanceOf(Mohamed);
        assertEq(
            balance,
            MohamedInitialBalance,
            "Mohamed's balance should be 1000 LIRA"
        );
    }
}
