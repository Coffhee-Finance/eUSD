// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "forge-std/Script.sol";

interface ILayerZeroPeer {
    function setPeer(uint32 eid, bytes32 peer) external;
}

contract SetPeersScript is Script {
    function run() external {
        uint256 pk = vm.envUint("PRIVATE_KEY");

        // Replace these with your deployed contract addresses
        address sourceAdapter = vm.envAddress("SOURCE_ADAPTER");
        address destinationEUSD = vm.envAddress("DESTINATION_EUSD");

        // Replace these with the correct LayerZero endpoint IDs
        uint32 sepoliaEid = uint32(vm.envUint("SEPOLIA_EID"));
        uint32 arbSepoliaEid = uint32(vm.envUint("ARBSEPOLIA_EID"));

        vm.startBroadcast(pk);

        ILayerZeroPeer(sourceAdapter).setPeer(
            arbSepoliaEid,
            bytes32(uint256(uint160(destinationEUSD)))
        );

        ILayerZeroPeer(destinationEUSD).setPeer(
            sepoliaEid,
            bytes32(uint256(uint160(sourceAdapter)))
        );

        vm.stopBroadcast();

        console2.log("Source adapter peer set to eUSD");
        console2.log("Destination eUSD peer set to source adapter");
    }
}