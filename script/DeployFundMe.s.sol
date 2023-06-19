// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script{

    function run() external returns(FundMe){    

        //Note: anything before a broadcast, is not "real" tx
        //so we save gas doing this
        HelperConfig helperConfig = new HelperConfig();
        (address ethUsdPriceFeed) = helperConfig.activeNetworkConfig();

        vm.startBroadcast();
        FundMe fundMe = new FundMe(ethUsdPriceFeed); //here FundMe is the main contract, 
        vm.stopBroadcast();
        return (fundMe);
        
        // vm.startBroadcast();
        // FundMe fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306); //here FundMe is the main contract, 
        // //We dont want to hardcode the address. the address mentioned above works only on sepolia, we deploy mocks...
        // //So now we will create a HelperConfig.s.sol, check it out!
        // vm.stopBroadcast();
        // return (fundMe);
    }

} 