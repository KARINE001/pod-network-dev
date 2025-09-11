#!/bin/bash

# Test deployed contracts functionality

source .env

echo "🧪 Testing deployed contracts..."

# Read deployed addresses
source proof/deployed-contracts.md 2>/dev/null || {
    echo "❌ No deployed contracts found. Run deploy.sh first."
    exit 1
}

echo "📋 Testing contract interactions..."

# Test Tokens contract
echo "🪙 Testing Tokens contract..."
echo "Token name:"
cast call $TOKENS_ADDRESS "name()" --rpc-url $RPC_URL | cast to-ascii

echo "Token symbol:"  
cast call $TOKENS_ADDRESS "symbol()" --rpc-url $RPC_URL | cast to-ascii

echo "Total supply:"
cast call $TOKENS_ADDRESS "totalSupply()" --rpc-url $RPC_URL

echo "Your balance:"
cast call $TOKENS_ADDRESS "balanceOf(address)" $WALLET_ADDRESS --rpc-url $RPC_URL

# Test other contracts
echo "🗳️ Testing Voting contract..."
cast call $VOTING_ADDRESS "name()" --rpc-url $RPC_URL | cast to-ascii

echo "🖼️ Testing NFTs contract..."  
cast call $NFTS_ADDRESS "name()" --rpc-url $RPC_URL | cast to-ascii

echo "🏛️ Testing Auction contract..."
cast call $AUCTION_ADDRESS "name()" --rpc-url $RPC_URL | cast to-ascii

echo "✅ All contract tests completed!"
