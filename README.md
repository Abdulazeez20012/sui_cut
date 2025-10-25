# SuiCut - Decentralized Video Creation & Remix Platform

SuiCut is a fully on-chain Web3 video creation, remix, and royalty platform built on the Sui blockchain. It enables creators to upload, remix, and monetize videos while maintaining transparent ownership, royalties, and provenance.

## Features

- **Video Management**: Mint, update, transfer, and delete video objects
- **Creator Profiles**: Register and manage creator profiles with zkLogin authentication
- **Royalty System**: Automatic royalty calculation and distribution for original and remix creators
- **Remix Tracking**: Complete lineage tracking for remix videos
- **Gas Sponsorship**: Enoki integration for sponsored transactions (zkLogin users don't need SUI tokens)

## Prerequisites

- [Sui CLI](https://docs.sui.io/devnet/build/install)
- [Rust](https://www.rust-lang.org/tools/install) (for Sui development)

## Project Structure

```
SuiCut/
├── Move.toml
├── sources/
│   ├── Video.move
│   ├── CreatorProfile.move
│   ├── Royalty.move
│   ├── Remix.move
│   └── Sponsor.move
├── tests/
│   ├── video_test.move
│   ├── remix_test.move
│   ├── royalty_test.move
│   ├── sponsor_test.move
│   └── profile_test.move
└── README.md
```

## Modules Overview

### Video.move
Manages video objects with:
- Creator address
- Walrus CID for decentralized storage
- Video title
- Royalty percentage (capped at 50%)
- Remix origin tracking

### CreatorProfile.move
Handles creator registration and profiles with:
- zkLogin verified identity
- Creator name and bio
- Earnings balance management

### Royalty.move
Implements royalty calculations and distribution:
- Basis point calculations
- Single and multi-level remix royalty splitting

### Remix.move
Tracks remix relationships:
- Parent-child video relationships
- Original creator tracking for royalties

### Sponsor.move
Integrates Enoki for gas sponsorship:
- Sponsor registration
- Transaction sponsorship
- Sponsorship verification

## Build

To build the SuiCut smart contract:

```bash
sui move build
```

## Test

To run all tests:

```bash
sui move test
```

To run tests with coverage:

```bash
sui move test --coverage
```

### Test Cases

1. Minting a new video
2. Failing to mint with invalid royalty (>50%)
3. Creating a remix video
4. Royalty calculation
5. Transferring video ownership
6. Multi-tier remix lineage tracking
7. Profile registration
8. Enoki-sponsored transaction
9. Remix royalty distribution
10. Unauthorized access prevention

## Deploy to Sui Testnet

1. Ensure you have Sui CLI installed and configured for Testnet
2. Publish the package:

```bash
sui client publish --network testnet --gas-budget 100000000
```

3. Note the package ID from the output for future interactions

## zkLogin Integration

SuiCut uses zkLogin for passwordless authentication via Google, Discord, or Twitter.

### How it works:
1. Users authenticate with OAuth providers (Google, Discord, Twitter)
2. Providers return JWTs
3. zkLogin validates JWTs and creates verified identities
4. All on-chain operations resolve to zkLogin addresses

### For Users:
1. Visit the Sui zkLogin demo to create your identity
2. Use the same OAuth account to interact with SuiCut
3. All video ownerships and actions are tied to your zkLogin identity

## Walrus Integration

SuiCut integrates with Walrus for decentralized video storage.

### How it works:
1. Videos are stored off-chain on Walrus
2. Content IDs (CIDs) are stored on-chain in video objects
3. CIDs are verified during minting

### For Creators:
1. Upload your video to Walrus to get a CID
2. Use the CID when minting videos on SuiCut
3. Viewers can retrieve videos using the stored CIDs

## Enoki Gas Sponsorship

New zkLogin users can interact with SuiCut without holding SUI tokens through Enoki's gas sponsorship.

### How it works:
1. Sponsors register with the Sponsor module
2. Transactions are sponsored using Enoki's paymaster
3. zkLogin users can mint, remix, and publish without gas fees

### For Sponsors:
1. Register as a sponsor using `register_sponsor()`
2. Fund the sponsor cap with SUI tokens
3. Sponsor transactions using `sponsor_transaction()`

### For Users:
1. zkLogin users automatically benefit from sponsorship
2. No SUI token balance required for basic operations
3. Complex operations may still require gas fees

## Interacting with SuiCut

### Mint a New Video
Call `Video::mint_video()` with:
- Creator address (your zkLogin address)
- Video title
- Walrus CID
- Royalty percentage (0-5000 basis points)

### Create a Remix
Call `Video::mint_remix_video()` with:
- Creator address
- Video title
- Walrus CID
- Royalty percentage
- Original creator address

### Register as a Creator
Call `CreatorProfile::register_creator()` with:
- Your zkLogin verified identity
- Creator name
- Bio/description

### Sponsor a Transaction
As a sponsor, call `Sponsor::sponsor_transaction()` with:
- Sponsor object
- Transaction hash
- Current clock

## Security Considerations

1. All video ownerships are tied to verified zkLogin identities
2. Royalty percentages are capped at 50% to prevent abuse
3. Remix relationships are immutable once created
4. Only creators can update their own videos
5. Gas sponsorship is managed through secure Enoki patterns

## Future Enhancements

1. NFT marketplace for video trading
2. Advanced royalty splitting algorithms
3. Video metadata indexing
4. Content recommendation system
5. Community governance features