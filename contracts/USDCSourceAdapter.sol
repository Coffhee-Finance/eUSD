// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import { OFTAdapter } from "@layerzerolabs/oft-evm/contracts/OFTAdapter.sol";

/**
 * @title USDCSourceAdapter
 * @notice Source-chain adapter that escrows Sepolia USDC and participates
 *         in the OFT mesh with destination-chain eUSD.
 */
contract USDCSourceAdapter is OFTAdapter {
    constructor(
        address usdc,
        address lzEndpoint,
        address delegate
    ) OFTAdapter(usdc, lzEndpoint, delegate) {}
}