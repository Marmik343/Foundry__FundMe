//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";
import {StdCheats} from "forge-std/StdCheats.sol";

contract FundMeTest is Test{

    FundMe fundMe;
    address USER = makeAddr("user"); // user this with vm.prank(); make sure to add balance
    /*This is a funtion that is used to deploy the contract, always called first, you can name it anything you like*/
    function setUp() external{
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER,100e18); // this will fund the USER with 100 ETH

    }

    function testMinimumDollarIsFive() public{ 
        //Make sure to use a funtion starting with the word `test` for foundry to identify,
        // eg, test() , test1(), testDemo(). It should start with `test` and can be anything you like.
        // run forge test -vv (max number of `v` is 5, i.e -vvvvv) to print the logs, using only forge test -v OR forge test will not print the logs.

        assertEq(fundMe.MINIMUM_USD(),5e18);
    }

    function testOwnerIsMsgSender() public{
        // assertEq(fundMe.i_owner(),msg.sender); this is the wrong way to check if owner is msg.sender

        // console.log(fundMe.i_owner());
        // console.log(address(this));
        assertEq(fundMe.i_owner(),msg.sender); //this is the correct way to do it, as this contract is the one who deploys the FundMe contract

    }

    //To run a specific test in foundry use: forge test --mt <funtion name>
    //ex: forge test --mt testPriceFeedVersionIsAccurate
    // also you can use -vvv to verbose output
    function testPriceFeedVersionIsAccurate() public{
        assertEq(fundMe.getVersion(), 4);

    //We will get an error when running this command: forge test --mt testPriceFeedVersionIsAccurate -vvv
    //this is because we have not specified the RPC URL, the contract address we are refering to is not the Sepolia Testnet
    //running this command without RPC url will use the local blockchain chain that is, anvil.
    //so, use like this forge test --mt testPriceFeedVersionIsAccurate -vvv --fork-url <RPC URL>

    /*
        In such cases like working with addresses outside the system we can use the following
        1.Unit - Testing a specific part of code.
        2.Integration - Testing how our code works with other parts of code
        3.Forked - Testing on a similuated real environment
        4.Staging - Tesing code on a real environment that is not prod
    
     */ 
    }

    function testFailsWithoutEnoughETH() public{
        vm.expectRevert(); //expect a revert to happen
        fundMe.fund();  
    }

    function testFundUpdatesFundedDataStructure() public{

        vm.prank(USER); // use this to send transaction from USER, kinda like ethers.getSigners();

        fundMe.fund{value:10e18}();
        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(amountFunded,10e18);
    }
}