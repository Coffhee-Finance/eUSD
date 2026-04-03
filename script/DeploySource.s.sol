// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "forge-std/Script.sol";
import "../contracts/USDCSourceAdapter.sol";

// 0x59De9918eE0cba2a60368104C289bE9EB8973E34 sepolia USDCSourceAdapter
contract DeploySourceScript is Script {
    function run() external {
        uint256 pk = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(pk);

        address sepoliaUsdc = 0x1c7D4B196Cb0C7B01d743Fbc6116a902379C7238;
        address sepoliaEndpoint = 0x6EDCE65403992e310A62460808c4b910D972f10f; // replace

        vm.startBroadcast(pk);

        USDCSourceAdapter sourceAdapter = new USDCSourceAdapter(
            sepoliaUsdc,
            sepoliaEndpoint,
            deployer
        );

        vm.stopBroadcast();

        console2.log("USDCSourceAdapter:", address(sourceAdapter));
    }
}