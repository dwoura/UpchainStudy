// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test,console} from "forge-std/Test.sol";
import {Bank} from "../src/Bank.sol";

contract BankTest is Test{
    Bank public bank;
    address bob = makeAddr("bob");

    function setUp() public{
        bank = new Bank();
        vm.deal(bob, 100 ether);
    }


    function test_EventDeposit() public {
        uint depositAmount = 1 ether;

        vm.expectEmit(true, false, false, false);
        emit Bank.Deposit(bob, depositAmount);
        
        vm.startPrank(bob);
        bank.depositETH{value: depositAmount}();
        vm.stopPrank();

        assert(bank.balanceOf(bob) == depositAmount);
    }

    function test_DepositValueUpdate() public {
        uint balanceBefore = bank.balanceOf(bob);
        vm.prank(bob);
        bank.depositETH{value: 1 ether}();
        uint balanceAfter = bank.balanceOf(bob);
        assert(balanceAfter == balanceBefore + 1 ether);
    }
}