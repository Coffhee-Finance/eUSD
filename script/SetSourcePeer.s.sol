// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "forge-std/Script.sol";

interface ILayerZeroPeer {
    function setPeer(uint32 eid, bytes32 peer) external;
}

contract SetSourcePeerScript is Script {
    function run() external {
        uint256 pk = vm.envUint("PRIVATE_KEY");

        address sourceAdapter = vm.envAddress("SOURCE_ADAPTER");
        address destinationEUSD = vm.envAddress("DESTINATION_EUSD");
        uint32 arbSepoliaEid = uint32(vm.envUint("ARBSEPOLIA_EID"));

        vm.startBroadcast(pk);

        ILayerZeroPeer(sourceAdapter).setPeer(
            arbSepoliaEid,
            bytes32(uint256(uint160(destinationEUSD)))
        );

        vm.stopBroadcast();

        console2.log("Source adapter peer set");
    }
}