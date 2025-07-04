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
    address SmartContract = makeAddr("SmartContract");
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

    function testAllowancesWorks() public {
        uint256 amountToAllow = 100 * 10 ** 18; // 100 LIRA with 18 decimals
        // Mohamed approves another smart contract to spend 100 LIRA
        vm.prank(Mohamed);
        lira.approve(SmartContract, amountToAllow); // Approve 100 LIRA with 18 decimals
        // Check the allowance
        uint256 allowance = lira.allowance(Mohamed, SmartContract);
        assertEq(allowance, amountToAllow, "Allowance should be 100 LIRA");
        // Now, the smart contract can transfer 100 LIRA from Mohamed's account
        vm.prank(SmartContract);
        lira.transferFrom(Mohamed, SmartContract, 50 * 10 ** 18); // SmartContract transfers 50 LIRA from Mohamed's account
        // Check balances after transfer
        uint256 mohamedBalance = lira.balanceOf(Mohamed);
        assertEq(
            mohamedBalance,
            MohamedInitialBalance - 50 * 10 ** 18,
            "Mohamed's balance should be reduced by 50 LIRA"
        );
    }
}
