🪙 eBONDS — Encrypted Stablecoin

eUSD is a privacy-preserving, cross-chain stablecoin designed to combine the reliability of fiat-backed assets with the confidentiality of encrypted on-chain balances.

Built using LayerZero’s Omnichain Fungible Token (OFT) architecture and the Fhenix encryption framework, eUSD enables users to transact, hold, and transfer value across chains while keeping sensitive financial data private.

🔐 Key Features
Confidential Balances

eUSD leverages Fhenix’s encryption primitives to provide shielded balances and supply:

Wallet balances are stored as encrypted values
Total supply is tracked confidentially
Users can selectively grant viewing access

This enables financial privacy without sacrificing composability.

🌉 Cross-Chain by Design

eUSD is deployed as an omnichain token using LayerZero:

USDC is locked on the source chain (e.g. Sepolia)
eUSD is minted on the destination chain (e.g. Arbitrum Sepolia)
Supply remains fully collateralized across chains

This ensures:

No double minting
Deterministic cross-chain accounting
Seamless bridging UX
🏦 Fully Collateralized

Each eUSD is backed 1:1 by locked USDC:

Deposits → lock USDC
Cross-chain message → mint eUSD
Reverse flow → burn eUSD, unlock USDC

This model guarantees:

Price stability
Transparent backing
Predictable redemption
🛡️ Controlled Minting

Minting is restricted to trusted cross-chain flows:

Only the authorized adapter (via LayerZero messaging) can mint
Peer contracts must be explicitly set via setPeer(...)
Prevents unauthorized supply inflation
⚙️ Architecture Overview
User (Sepolia)
   │
   ▼
USDC → USDCSourceAdapter (lock)
   │
   ▼  LayerZero Message
   │
   ▼
eUSD (Arbitrum Sepolia) → Mint

Components:

USDCSourceAdapter
Locks USDC on the source chain
Initiates cross-chain message
eUSD
ERC-20 compatible token
Supports encrypted balances
Mints/burns based on cross-chain messages
🔍 Privacy Model

eUSD introduces a hybrid transparency model:

Feature	Visibility
Transfers	Public
Balances	Encrypted
Supply	Encrypted
Access control	User-controlled

Users can:

Grant permanent or temporary access to their encrypted balance
Enable selective decryption when needed
🚀 Use Cases
Private payments and settlements
Confidential DeFi strategies
Cross-chain stablecoin transfers
Enterprise-grade financial privacy
⚠️ Disclaimer

This project is experimental and deployed on testnets.
It is intended for development, testing, and research purposes only.
