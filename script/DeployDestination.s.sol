// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "forge-std/Script.sol";
import "../contracts/eUSD.sol";

//0xC3EbB3266D66Ab178e60c1741Dc2611b961f32f6 eusd ArbSepolia
contract DeployDestinationScript is Script {
    function run() external {
        uint256 pk = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(pk);

        address arbSepoliaEndpoint = 0x6EDCE65403992e310A62460808c4b910D972f10f; // replace

        vm.startBroadcast(pk);

        eUSD token = new eUSD(
            arbSepoliaEndpoint,
            deployer
        );

        vm.stopBroadcast();

        console2.log("eUSD:", address(token));
    }
}