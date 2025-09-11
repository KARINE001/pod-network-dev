# 🚀 Deploy to Pod Network V1 Devnet - Complete Manual Guide

**Deploy 4 smart contracts with 200ms finality in 45 minutes**

[![Pod Network](https://img.shields.io/badge/Pod_Network-V1_Devnet-blue.svg)](https://pod.network)
[![Foundry](https://img.shields.io/badge/Built_with-Foundry-green.svg)](https://getfoundry.sh/)
[![Tested](https://img.shields.io/badge/Status-Working_✓-brightgreen.svg)]()

## 🎯 What You'll Deploy

4 working smart contracts:
- 🗳️ **Voting** - Governance with proposals
- 🖼️ **NFTs** - Digital collectibles  
- 🏛️ **Auction** - Bidding system
- 🪙 **Tokens** - Your own cryptocurrency

**Total cost**: ~$0.16 (vs $200+ on Ethereum!)

---

## 📋 Prerequisites

- Linux/macOS terminal
- MetaMask browser extension
- Git installed
- 45 minutes of time

---

## 🔧 Step 1: Setup Wallet & Get POD ETH

### Add Pod Network to MetaMask

1. **Go to**: https://docs.v1.pod.network/devnet
2. **Click**: "Add to Wallet" button  
3. **Approve** in MetaMask when prompted

✅ **Network added automatically!** 🎯

### Create Development Wallet

⚠️ **IMPORTANT**: **NEVER use real funds** on devnet!

1. **Open MetaMask**
2. **Click** account icon → "Create Account"  
3. **Name it**: "Pod Network Devnet"
4. **Save** the wallet address

### Get Free POD ETH

1. **Connect Twitter account** to Pod Network faucet
2. **Get 0.1 POD ETH/day** automatically 🎁  
3. **Daily reset** - enough for development

**Steps**:
- Follow instructions on https://docs.v1.pod.network/devnet
- Connect your Twitter account  
- Receive 0.1 POD ETH per day

---

## ⚙️ Step 2: Install Development Tools

### Install Foundry

```bash
# Install Foundry (Solidity development framework)
curl -L https://foundry.paradigm.xyz | bash

# Reload terminal
source ~/.bashrc

# Update to latest version
foundryup

# Verify installation
forge --version
```

### Install Git (if not installed)

```bash
# Ubuntu/Debian
sudo apt update && sudo apt install git

# macOS
brew install git

# Verify
git --version
```

---

## 📁 Step 3: Clone Pod Network SDK

### Clone Official Repository

```bash
# Create working directory
mkdir pod-network-dev && cd pod-network-dev

# Clone official Pod Network SDK
git clone https://github.com/podnetwork/pod-sdk.git

# Check what we got
ls pod-sdk/
```

### Explore SDK Structure

```bash
# Look at available contracts
ls pod-sdk/examples/

# Available contracts:
# - voting/          (Governance contract)
# - nfts/           (NFT collection)  
# - solidity/       (Auction contract)
# - tokens/         (Token contract)
```

---

## 🏗️ Step 4: Setup Foundry Project

### Create Foundry Project

```bash
# Create new Foundry project
mkdir pod-foundry && cd pod-foundry
forge init --force .

# Check structure
ls -la
```

### Configure for Pod Network

```bash
# Create Pod Network specific configuration
cat > foundry.toml << 'TOML_EOF'
[profile.default]
src = "src"
out = "out"
libs = ["lib"]
solc_version = "0.8.28"
evm_version = "prague"

[rpc_endpoints]
poddevnet = "https://rpc.v1.dev.pod.network"

[etherscan]
poddevnet = { key = "dummy", url = "https://explorer.v1.pod.network" }
TOML_EOF
```

### Install Pod SDK Dependency

```bash
# Install Pod Network SDK as library
forge install podnetwork/pod-sdk --no-commit

# Configure import mappings (CRITICAL!)
echo "pod-sdk/=lib/pod-sdk/solidity-sdk/src/" > remappings.txt

# Verify installation
ls lib/pod-sdk/
```

---

## 📄 Step 5: Copy & Fix Contract Files

### Copy Contract Files from SDK

```bash
# Copy the 4 main contracts
cp ../pod-sdk/examples/voting/contract/src/Voting.sol src/
cp ../pod-sdk/examples/nfts/NFTs.sol src/
cp ../pod-sdk/examples/solidity/src/Auction.sol src/
cp ../pod-sdk/examples/tokens/contracts/Tokens.sol src/

# Check copied files
ls src/
```

### Fix Import Paths (Required!)

The SDK examples have broken import paths. Fix them:

```bash
# Fix NFTs contract imports
sed -i 's|pod-sdk/solidity-sdk/src/pod/Quorum.sol|pod-sdk/Quorum.sol|g' src/NFTs.sol

# Fix Tokens contract imports  
sed -i 's|pod-sdk/solidity-sdk/src/pod/Quorum.sol|pod-sdk/Quorum.sol|g' src/Tokens.sol

# Fix Solidity syntax for newer versions
sed -i 's|string tokenName,|string memory tokenName,|g' src/Tokens.sol
sed -i 's|string tokenSymbol,|string memory tokenSymbol,|g' src/Tokens.sol
```

### Test Compilation

```bash
# Compile all contracts
forge build --force

# If successful, you'll see:
# "Compiler run successful!"
```

**If compilation fails**: Check import paths and syntax errors.

---

## 🔑 Step 6: Configure Environment

### Create Environment File

```bash
# Create environment configuration
cp .env.example .env

# Edit with your wallet details
nano .env
```

### Add Your Wallet Information

1. **Get your private key** from MetaMask:
   - Settings → Security & Privacy → Export Private Key
   - ⚠️ Only for devnet wallet!

2. **Replace in .env file**:
   ```bash
   PRIVATE_KEY=0x1234567890abcdef...
   WALLET_ADDRESS=0xYourWalletAddress...
   ```

### Load Environment

```bash
# Load environment variables
source .env

# Verify configuration
echo "Wallet: $WALLET_ADDRESS"
echo "RPC: $RPC_URL"
```

---

## 🚀 Step 7: Deploy Contracts

### Check Balance

```bash
# Check your POD ETH balance
cast balance $WALLET_ADDRESS --rpc-url $RPC_URL

# Convert to readable format
cast balance $WALLET_ADDRESS --rpc-url $RPC_URL | cast to-unit - ether
```

**Need more POD ETH?** Wait for daily faucet reset or request in community.

### Deploy All Contracts

Use our automated deployment script:

```bash
# Make script executable
chmod +x scripts/deploy.sh

# Run deployment
./scripts/deploy.sh
```

Or deploy manually one by one:

```bash
# Deploy Voting
forge create src/Voting.sol:Voting \
  --rpc-url $RPC_URL --private-key $PRIVATE_KEY --broadcast

# Deploy NFTs
forge create src/NFTs.sol:NFTs \
  --rpc-url $RPC_URL --private-key $PRIVATE_KEY --broadcast

# Deploy Auction
forge create src/Auction.sol:Auction \
  --rpc-url $RPC_URL --private-key $PRIVATE_KEY --broadcast

# Deploy Tokens
forge create src/Tokens.sol:Tokens \
  --constructor-args "PodToken" "PTK" 1000000000000000000000 \
  --rpc-url $RPC_URL --private-key $PRIVATE_KEY --broadcast
```

---

## ✅ Step 8: Verify Deployment

### Check on Explorer

Visit https://explorer.v1.pod.network and search for your contract addresses.

You should see:
- ✅ Contract creation transactions
- ✅ Verified bytecode
- ✅ ~200ms confirmation times

### Test Basic Interactions

```bash
# Test token total supply
cast call TOKEN_ADDRESS "totalSupply()" --rpc-url $RPC_URL

# Test token name
cast call TOKEN_ADDRESS "name()" --rpc-url $RPC_URL
```

---

## 🎉 Success!

You've successfully deployed 4 smart contracts on Pod Network V1 Devnet with **200ms finality**!

**See [proof/](proof/) for real deployment examples and [feedback/](feedback/) for developer experience.**

---

## 🐛 Troubleshooting

### Common Issues & Solutions

**❌ "Source not found" error**
```bash
# Check remappings are correct
cat remappings.txt
# Should show: pod-sdk/=lib/pod-sdk/solidity-sdk/src/
```

**❌ "Constructor arguments error"**
```bash
# Use exact format for Tokens:
--constructor-args "TokenName" "SYMBOL" 1000000000000000000000
```

**❌ "Connection refused"**
```bash
# Verify RPC URL
curl -X POST $RPC_URL \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}'
```

---

## 📊 Real Deployment Results

Check [proof/deployed-contracts.md](proof/deployed-contracts.md) for live contract addresses and transaction details.

**Total cost**: ~0.16 POD ETH (~$0.16)  
**Ethereum equivalent**: $50-200+  
**Savings**: 99%+ cost reduction

---

## 🔗 Resources

- **Pod Network**: https://pod.network
- **Documentation**: https://docs.v1.pod.network
- **Explorer**: https://explorer.v1.pod.network
- **GitHub SDK**: https://github.com/podnetwork/pod-sdk

---

## 📱 Connect

Found this helpful? 

- ⭐ **Star this repo**
- 🔄 **Share with other developers**
- 💬 **Open issues** for questions or improvements

---

*This guide is based on real deployment experience. Pod Network is developed by Common Prefix.*
