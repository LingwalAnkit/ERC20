// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {MyToken} from "../src/token.sol";

contract TokenTest is Test {
    MyToken public mytoken;
    address owner;
    address user;
    event Transfer(address indexed from, address indexed to, uint256 value);

    function setUp() public {
        mytoken = new MyToken();
        owner = address(this);
        user = address(0xABCD);
    }

    function testMint() public {
        mytoken.mint(owner, 100);
        assertEq(mytoken.balanceOf(owner), 100, "Owner should have 100 tokens");
    }

    function testTransfer() public {
        mytoken.mint(owner, 100);
        mytoken.transfer(user, 40);
        assertEq(mytoken.balanceOf(user), 40, "User should have 40 tokens");
        assertEq(mytoken.balanceOf(owner), 60, "Owner should have 60 tokens");
    }

    function testApproveAndTransferFrom() public {
        mytoken.mint(owner, 100);
        mytoken.approve(user, 50);

        vm.prank(user);
        mytoken.transferFrom(owner, user, 30);

        assertEq(mytoken.balanceOf(user), 30, "User should have 30 tokens");
        assertEq(
            mytoken.allowance(owner, user),
            20,
            "Remaining allowance should be 20"
        );
        assertEq(mytoken.balanceOf(owner), 70, "Owner should have 70 tokens");
    }

    function test_approvalOverLimitTransfer_reverts() public {
        mytoken.mint(owner, 100);
        mytoken.approve(user, 20);

        vm.prank(user);
        vm.expectRevert(); // or pass the selector / reason string
        mytoken.transferFrom(owner, user, 100);
    }

    function test_transfer_reverts() public {
        mytoken.mint(owner, 100);
        vm.expectRevert();
        mytoken.transfer(user, 200);
    }

    function testTranferEmits() public {
        mytoken.mint(owner , 100);
        vm.expectEmit(true, true, false, true); // match from to and value the false means we don't care about the 3rd indexed field
        emit Transfer(owner, user, 50);
        mytoken.transfer(user, 50);
    }

    function testDeal() public {
        address user2 = address(0x1234);
        vm.deal(user2, 10 ether);

        assertEq(user2.balance, 10 ether);
    }

    function testHoax() public {
        hoax(user , 10 ether); // This will set the msg.sender to user and transfer 10 ether to user
        mytoken.test{value: 1 ether}(); // This will call the test function in MyToken with 1 ether sent
        assertEq(user.balance, 9 ether);
        assertEq(mytoken.getEthBalance(), 1 ether);
    }
}
