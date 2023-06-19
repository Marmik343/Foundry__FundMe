// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

// 1. Deploy mocks on local anvil chain
// 2. keep track of addresses
// as sepolia eth/usd has a diff address
// and mainnet eth/usd has a different address

import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";
import {Script} from "forge-std/Script.sol";

contract HelperConfig is Script{
    // 1. if on local anvil, deploy mocks
    // else use address from live network(sepolia, mainnet)
    
    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e8;

    struct NetwrokConfig {
        address priceFeed; // eth/usd price feed address 
    }

    NetwrokConfig public activeNetworkConfig;

    constructor(){
        if(block.chainid == 11155111){
           activeNetworkConfig = getSepoliaEthConfig();
        } else {
            activeNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }
     
    function getSepoliaEthConfig() public pure returns(NetwrokConfig memory){
        //Price feed address
        NetwrokConfig memory sepoliaConfig = NetwrokConfig({priceFeed:0x694AA1769357215DE4FAC081bf1f309aDC325306});
        return(sepoliaConfig);
    } 

    function getOrCreateAnvilEthConfig() public returns(NetwrokConfig memory){
        //Price feed address
        if(activeNetworkConfig.priceFeed != address(0)){
            return activeNetworkConfig;
        }

        //Since the contract doesnt exist on Anvil..

        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(DECIMALS,INITIAL_PRICE);
        vm.stopBroadcast();

        NetwrokConfig memory anvilConfig = NetwrokConfig({priceFeed:address(mockPriceFeed)});
        return anvilConfig;



    }


}
