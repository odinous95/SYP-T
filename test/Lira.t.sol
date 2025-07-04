// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Lira} from "../src/Lira.sol";
import {DeployLira} from "../script/DeployLira.s.sol";

contract LiraTest is Test {
    Lira public lira;
    DeployLira public deployLira;

    address Mohamed = makeAddr("Mohamed");
    address Ali = makeAddr("Ali");
    address SmartContract = makeAddr("SmartContract");
    uint256 MohamedInitialBalance = 1000 * 10 ** 18;

    function setUp() public {
        deployLira = new DeployLira();
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

    function testDecimals() public view {
        assertEq(lira.decimals(), 18);
    }

    function testTotalSupply() public view {
        assertEq(lira.totalSupply(), 1_000_000 * 10 ** 18);
    }

    function testBalanceOf() public view {
        assertEq(lira.balanceOf(Mohamed), MohamedInitialBalance);
    }

    function testTransfer() public {
        vm.prank(Mohamed);
        lira.transfer(Ali, 200 * 10 ** 18);

        assertEq(lira.balanceOf(Ali), 200 * 10 ** 18);
        assertEq(
            lira.balanceOf(Mohamed),
            MohamedInitialBalance - 200 * 10 ** 18
        );
    }

    function testTransferFailsWhenInsufficientBalance() public {
        vm.expectRevert();
        vm.prank(Ali);
        lira.transfer(Mohamed, 10 * 10 ** 18);
    }

    function testApproveAndAllowance() public {
        vm.prank(Mohamed);
        lira.approve(SmartContract, 100 * 10 ** 18);
        assertEq(lira.allowance(Mohamed, SmartContract), 100 * 10 ** 18);
    }

    function testApproveMultiple() public {
        vm.startPrank(Mohamed);
        lira.approve(SmartContract, 50 * 10 ** 18);
        lira.approve(Ali, 30 * 10 ** 18);
        vm.stopPrank();

        assertEq(lira.allowance(Mohamed, SmartContract), 50 * 10 ** 18);
        assertEq(lira.allowance(Mohamed, Ali), 30 * 10 ** 18);
    }

    function testApproveOverwrite() public {
        vm.prank(Mohamed);
        lira.approve(Ali, 100 * 10 ** 18);
        vm.prank(Mohamed);
        lira.approve(Ali, 50 * 10 ** 18);

        assertEq(lira.allowance(Mohamed, Ali), 50 * 10 ** 18);
    }

    function testTransferFromSuccess() public {
        vm.prank(Mohamed);
        lira.approve(SmartContract, 100 * 10 ** 18);

        vm.prank(SmartContract);
        lira.transferFrom(Mohamed, SmartContract, 60 * 10 ** 18);

        assertEq(lira.balanceOf(SmartContract), 60 * 10 ** 18);
        assertEq(lira.allowance(Mohamed, SmartContract), 40 * 10 ** 18);
        assertEq(
            lira.balanceOf(Mohamed),
            MohamedInitialBalance - 60 * 10 ** 18
        );
    }

    function testTransferFromFailsWhenNoApproval() public {
        vm.expectRevert();
        vm.prank(SmartContract);
        lira.transferFrom(Mohamed, SmartContract, 10 * 10 ** 18);
    }

    function testTransferFromFailsWhenInsufficientBalance() public {
        vm.prank(Mohamed);
        lira.approve(SmartContract, 2000 * 10 ** 18);

        vm.expectRevert();
        vm.prank(SmartContract);
        lira.transferFrom(Mohamed, SmartContract, 1500 * 10 ** 18);
    }

    function testApproveSelfTransferFrom() public {
        vm.prank(Mohamed);
        lira.approve(Mohamed, 100 * 10 ** 18);

        vm.prank(Mohamed);
        lira.transferFrom(Mohamed, Mohamed, 50 * 10 ** 18);

        assertEq(lira.balanceOf(Mohamed), MohamedInitialBalance);
        assertEq(lira.allowance(Mohamed, Mohamed), 50 * 10 ** 18);
    }
}
