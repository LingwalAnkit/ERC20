// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {MyToken} from "../src/token.sol";

contract TokenTest is Test {
    MyToken public mytoken;

    function setUp() public {
        mytoken = new MyToken();
    }

    function testMint() public {
        address user = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2;
        address owner = address(this);
        mytoken.mint(owner, 100);
        mytoken.transfer(user, 50);
        uint256 expected = 50;
        assertEq(mytoken.balanceOf(owner), expected, "OKK");
        // this is here the person who deployed the contract
        assertEq(mytoken.balanceOf(user), 50, "OKK2");
        vm.prank(user);
        mytoken.transfer(owner, 50);

        mytoken.approve(user, 10);
        vm.prank(user);
        mytoken.transferFrom(owner, user, 10);
        // makes user to call the function as if they are the owner
        assertEq(mytoken.balanceOf(user), 10, "OKK3");
    }

    function testTransfer() public {
        address user = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2;
        address owner = address(this);
        mytoken.mint(owner, 100);
        mytoken.transfer(user, 50);
        assertEq(mytoken.balanceOf(0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2), 50, "OKK2");
    }

    function testApprove() public {
        address user = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2;
        address owner = address(this);
        mytoken.mint(owner, 100);
        mytoken.transfer(user, 50);

        mytoken.approve(user, 10);
        vm.prank(user);
        mytoken.transferFrom(owner, user, 10);
        // makes user to call the function as if they are the owner
        assertEq(mytoken.balanceOf(user), 60, "OKK3");
    }
}
