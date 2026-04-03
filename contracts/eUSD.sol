// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import { OFT } from "@layerzerolabs/oft-evm/contracts/OFT.sol";
import { Pausable } from "@openzeppelin/contracts/security/Pausable.sol";

import {
    FHE,
    euint128
} from "@fhenixprotocol/cofhe-contracts/FHE.sol";

contract eUSD is OFT, Pausable {
    uint8 public constant TOKEN_DECIMALS = 6;

    mapping(address => euint128) private _encBalances;
    euint128 private _encTotalSupply;
    euint128 private _encZero;

    event EncryptedBalanceAccessGranted(
        address indexed account,
        address indexed viewer,
        bool transientAccess
    );

    error AmountTooLarge();

    constructor(
        address lzEndpoint,
        address delegate
    ) OFT("Encrypted USD", "eUSD", lzEndpoint, delegate) {
        _encZero = FHE.asEuint128(uint128(0));
        FHE.allowThis(_encZero);
        FHE.allowPublic(_encZero);

        _encTotalSupply = _encZero;
        FHE.allowThis(_encTotalSupply);
        FHE.allowPublic(_encTotalSupply);
    }

    function decimals() public pure override returns (uint8) {
        return TOKEN_DECIMALS;
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }

    function ownerMint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    function ownerBurn(address from, uint256 amount) external onlyOwner {
        _burn(from, amount);
    }

    function confidentialBalanceOf(address account) external view returns (bytes32) {
        return FHE.unwrap(_loadBalance(account));
    }

    function confidentialTotalSupply() external view returns (bytes32) {
        return FHE.unwrap(_encTotalSupply);
    }

    function grantEncryptedBalanceAccess(address viewer) external {
        euint128 bal = _loadBalance(msg.sender);
        FHE.allow(bal, viewer);
        emit EncryptedBalanceAccessGranted(msg.sender, viewer, false);
    }

    function grantEncryptedBalanceAccessTransient(address viewer) external {
        euint128 bal = _loadBalance(msg.sender);
        FHE.allowTransient(bal, viewer);
        emit EncryptedBalanceAccessGranted(msg.sender, viewer, true);
    }

    function allowMyBalanceToSender() external {
        euint128 bal = _loadBalance(msg.sender);
        FHE.allowSender(bal);
    }

    function enableMyBalancePublicDecryption() external {
        euint128 bal = _loadBalance(msg.sender);
        FHE.allowPublic(bal);
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount)
        internal
        override
        whenNotPaused
    {
        super._beforeTokenTransfer(from, to, amount);
    }

    function _afterTokenTransfer(address from, address to, uint256 amount) internal override {
        super._afterTokenTransfer(from, to, amount);

        if (amount == 0) return;
        if (amount > type(uint128).max) revert AmountTooLarge();

        euint128 encAmount = FHE.asEuint128(uint128(amount));
        FHE.allowThis(encAmount);

        if (from == address(0)) {
            _encBalances[to] = FHE.add(_loadBalance(to), encAmount);
            _encTotalSupply = FHE.add(_encTotalSupply, encAmount);

            _grantStandardAccess(_encBalances[to], to);
            _grantStandardAccess(_encTotalSupply, address(0));
            return;
        }

        if (to == address(0)) {
            _encBalances[from] = FHE.sub(_loadBalance(from), encAmount);
            _encTotalSupply = FHE.sub(_encTotalSupply, encAmount);

            _grantStandardAccess(_encBalances[from], from);
            _grantStandardAccess(_encTotalSupply, address(0));
            return;
        }

        _encBalances[from] = FHE.sub(_loadBalance(from), encAmount);
        _encBalances[to] = FHE.add(_loadBalance(to), encAmount);

        _grantStandardAccess(_encBalances[from], from);
        _grantStandardAccess(_encBalances[to], to);
    }

    function _loadBalance(address account) internal view returns (euint128) {
        euint128 bal = _encBalances[account];
        return FHE.isInitialized(bal) ? bal : _encZero;
    }

    function _grantStandardAccess(euint128 value, address account) internal {
        FHE.allowThis(value);
        if (account != address(0)) {
            FHE.allow(value, account);
        }
    }
}