# Troubleshooting Guide - Pod Network V1 Devnet

Based on real issues encountered during deployment.

## 🚨 Critical Issues & Solutions

### 1. Contract Compilation Failures

**❌ Error**: `Source not found`
```bash
Error: Source "pod-sdk/solidity-sdk/src/pod/Quorum.sol" not found
```

**✅ Solution**: Fix import paths in contract files
```bash
# Fix NFTs contract
sed -i 's|pod-sdk/solidity-sdk/src/pod/Quorum.sol|pod-sdk/Quorum.sol|g' src/NFTs.sol

# Fix Tokens contract  
sed -i 's|pod-sdk/solidity-sdk/src/pod/Quorum.sol|pod-sdk/Quorum.sol|g' src/Tokens.sol
```

**Root cause**: SDK examples have outdated import paths

---

### 2. Foundry RPC Connection Issues

**❌ Error**: `Connection refused (os error 111)`
```bash
Error: Failed to connect to RPC at localhost:8545
```

**✅ Solution**: Set environment variables for Foundry
```bash
export ETH_RPC_URL=https://rpc.v1.dev.pod.network
export FOUNDRY_ETH_RPC_URL=https://rpc.v1.dev.pod.network
```

**Root cause**: Foundry sometimes ignores --rpc-url flag

---

### 3. Constructor Argument Errors

**❌ Error**: `Invalid constructor arguments`
```bash
Error: Failed to decode constructor arguments
```

**✅ Solution**: Use correct format for Tokens contract
```bash
# Correct format
forge create src/Tokens.sol:Tokens \
  --constructor-args "PodToken" "PTK" 1000000000000000000000

# Wrong formats that fail:
# --constructor-args PodToken PTK 1000  ❌
# --constructor-args "PodToken,PTK,1000" ❌
```

**Root cause**: Constructor expects string memory parameters

---

### 4. Insufficient Funds Errors

**❌ Error**: `Insufficient funds for gas`
```bash
Error: Transaction reverted: insufficient funds
```

**✅ Solution**: Check and request POD ETH
```bash
# Check current balance
cast balance $WALLET_ADDRESS --rpc-url $RPC_URL

# Convert to readable format
cast balance $WALLET_ADDRESS --rpc-url $RPC_URL | cast to-unit - ether

# Request more POD ETH via Twitter faucet (0.1/day)
```

**Root cause**: Need ~0.2 POD ETH for full deployment

---

### 5. Network Not Found in MetaMask

**❌ Error**: `Network not found` or `Wrong chain ID`

**✅ Solution**: Manually add network
```javascript
// Network details
Network Name: Pod Network V1 Devnet
RPC URL: https://rpc.v1.dev.pod.network  
Chain ID: 1293
Currency Symbol: POD ETH
Block Explorer: https://explorer.v1.pod.network
```

**Alternative**: Visit https://docs.v1.pod.network/devnet and click "Add to Wallet"

---

## 🔧 Configuration Issues

### Remappings Not Working

**❌ Symptom**: Import paths still failing after fixes

**✅ Check remappings.txt**:
```bash
cat remappings.txt
# Should show: pod-sdk/=lib/pod-sdk/solidity-sdk/src/
```

**✅ Recreate if needed**:
```bash
echo "pod-sdk/=lib/pod-sdk/solidity-sdk/src/" > remappings.txt
```

### Foundry Configuration Issues

**❌ Symptom**: Wrong Solidity version or compilation errors

**✅ Check foundry.toml**:
```toml
[profile.default]
src = "src"
out = "out"
libs = ["lib"]
solc_version = "0.8.28"  # Critical: must be 0.8.28
evm_version = "prague"   # Critical: must be prague

[rpc_endpoints]
poddevnet = "https://rpc.v1.dev.pod.network"
```

---

## 🌐 Network Issues

### RPC Connectivity Test

**Test connection**:
```bash
curl -X POST https://rpc.v1.dev.pod.network \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}'

# Should return: {"jsonrpc":"2.0","id":1,"result":"0x..."}
```

### Explorer Not Loading

**Issue**: Contract addresses not showing on explorer

**Solutions**:
1. Wait 1-2 minutes for indexing
2. Check exact address formatting
3. Verify transaction succeeded with cast:
   ```bash
   cast tx TX_HASH --rpc-url $RPC_URL
   ```

---

## 💰 Token & Faucet Issues

### Faucet Not Working

**Issue**: No POD ETH received from faucet

**Solutions**:
1. **Verify Twitter connection** properly setup
2. **Wait 24 hours** for daily reset  
3. **Check wallet** on correct network (Chain ID 1293)
4. **Request help** in Pod Network community

### Token Interactions Failing

**Issue**: `cast call` commands returning errors

**Debug steps**:
```bash
# 1. Verify contract deployed
cast code $TOKEN_ADDRESS --rpc-url $RPC_URL

# 2. Test simple call
cast call $TOKEN_ADDRESS "name()" --rpc-url $RPC_URL

# 3. Check ABI matches
cast call $TOKEN_ADDRESS "totalSupply()" --rpc-url $RPC_URL
```

---

## 🚀 Performance Issues

### Slow Transaction Confirmation

**Expected**: ~200ms finality  
**If experiencing**: >5 seconds

**Check**:
1. **Network congestion**: Check explorer for activity
2. **Gas price**: Try increasing gas limit
3. **RPC endpoint**: Test different RPC if available

### High Gas Costs

**Expected**: ~60 gwei  
**If experiencing**: >200 gwei

**Solutions**:
1. **Wait for lower congestion**
2. **Check network status**  
3. **Verify correct network** (not Ethereum mainnet!)

---

## 📋 Diagnostic Commands

### Complete System Check

```bash
# 1. Check Foundry installation
forge --version

# 2. Check network connectivity  
curl -s https://rpc.v1.dev.pod.network > /dev/null && echo "✅ RPC OK" || echo "❌ RPC Failed"

# 3. Check wallet balance
cast balance $WALLET_ADDRESS --rpc-url $RPC_URL | cast to-unit - ether

# 4. Test compilation
forge build --force

# 5. Verify environment
echo "Wallet: $WALLET_ADDRESS"
echo "RPC: $RPC_URL"
echo "Chain ID: $CHAIN_ID"
```

### Quick Fix Script

```bash
#!/bin/bash
# Fix common issues automatically

echo "🔧 Applying common fixes..."

# Fix import paths
sed -i 's|pod-sdk/solidity-sdk/src/pod/Quorum.sol|pod-sdk/Quorum.sol|g' src/NFTs.sol 2>/dev/null
sed -i 's|pod-sdk/solidity-sdk/src/pod/Quorum.sol|pod-sdk/Quorum.sol|g' src/Tokens.sol 2>/dev/null

# Fix Solidity syntax
sed -i 's|string tokenName,|string memory tokenName,|g' src/Tokens.sol 2>/dev/null
sed -i 's|string tokenSymbol,|string memory tokenSymbol,|g' src/Tokens.sol 2>/dev/null

# Set environment variables
export ETH_RPC_URL=https://rpc.v1.dev.pod.network
export FOUNDRY_ETH_RPC_URL=https://rpc.v1.dev.pod.network

# Verify remappings
echo "pod-sdk/=lib/pod-sdk/solidity-sdk/src/" > remappings.txt

echo "✅ Common fixes applied!"
```

---

## 🆘 Getting Help

### Community Support

1. **Pod Network Discord**: Active developer community
2. **GitHub Issues**: Report bugs in pod-sdk repository  
3. **Documentation**: https://docs.v1.pod.network
4. **Explorer**: https://explorer.v1.pod.network for transaction debugging

### When Reporting Issues

Include this information:
- **Error message** (exact text)
- **Command executed** 
- **Environment** (OS, Foundry version)
- **Network details** (balance, RPC connectivity)
- **Contract addresses** (if applicable)

---

*This troubleshooting guide covers all issues encountered during real Pod Network V1 Devnet development.*
