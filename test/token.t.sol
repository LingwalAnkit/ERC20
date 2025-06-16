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
        mytoken.mint(address(this), 100);
        uint256 expected = 100;
        assertEq(mytoken.balanceOf(address(this)), expected, "OKK");
    }
}
