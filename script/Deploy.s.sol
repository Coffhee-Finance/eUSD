// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "forge-std/Script.sol";
import "../contracts/eUSD.sol";
import "../contracts/USDCSourceAdapter.sol";

contract DeployScript is Script {
    function run() external {
        uint256 pk = vm.envUint("PRIVATE_KEY");

        address sepoliaUsdc = 0x1c7D4B196Cb0C7B01d743Fbc6116a902379C7238;

        address sepoliaEndpoint = 0x0000000000000000000000000000000000000001; // replace
        address arbSepoliaEndpoint = 0x0000000000000000000000000000000000000001; // replace

        address deployer = vm.addr(pk);

        vm.startBroadcast(pk);

        USDCSourceAdapter sourceAdapter = new USDCSourceAdapter(
            sepoliaUsdc,
            sepoliaEndpoint,
            deployer
        );

        eUSD token = new eUSD(
            arbSepoliaEndpoint,
            deployer
        );

        vm.stopBroadcast();

        console2.log("USDCSourceAdapter:", address(sourceAdapter));
        console2.log("eUSD:", address(token));
    }
}