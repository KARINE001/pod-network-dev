# Deployed Contracts on Pod Network V1 Devnet

**Deployment Date**: September 2025  
**Network**: Pod Network V1 Devnet  
**Chain ID**: 1293  
**Deployer**: 0x195360E885254f71F3c0644fb0AA83feCae5Ea2C

## Live Contract Addresses

|Contract|Address|Explorer Link|Status|
|--------|-------|-------------|------|
|Voting  |`0xb75B65C0e733ccBb0Ef8F16056890866f24dB0c9`|[View](https://explorer.v1.pod.network/address/0xb75B65C0e733ccBb0Ef8F16056890866f24dB0c9)|✅ Live|
|NFTs    |`0xFC020892353fabfDf89319A5fAAa6e45E6D46910`|[View](https://explorer.v1.pod.network/address/0xFC020892353fabfDf89319A5fAAa6e45E6D46910)|✅ Live|
|Auction |`0xfE4Ae4B2aAa8B686916F203AAB9939c40b22284B`|[View](https://explorer.v1.pod.network/address/0xfE4Ae4B2aAa8B686916F203AAB9939c40b22284B)|✅ Live|
|Tokens  |`0x6eb77940fD64d791eb3B443b49a0073ad4cF22E0`|[View](https://explorer.v1.pod.network/address/0x6eb77940fD64d791eb3B443b49a0073ad4cF22E0)|✅ Live|

## Performance Metrics

- **Transaction finality**: ~200ms consistently
- **Total deployment cost**: 0.156 POD ETH (~$0.16)
- **Gas prices**: ~60 gwei stable
- **Network uptime**: 100% during testing period
- **RPC response time**: <100ms typically

## Test Interactions

```bash
# Check token supply
cast call 0x6eb77940fD64d791eb3B443b49a0073ad4cF22E0 "totalSupply()" --rpc-url https://rpc.v1.dev.pod.network

# Check token name  
cast call 0x6eb77940fD64d791eb3B443b49a0073ad4cF22E0 "name()" --rpc-url https://rpc.v1.dev.pod.network

# Check balance
cast call 0x6eb77940fD64d791eb3B443b49a0073ad4cF22E0 "balanceOf(address)" 0x195360E885254f71F3c0644fb0AA83feCae5Ea2C --rpc-url https://rpc.v1.dev.pod.network
```

## Deployment Evidence

All contracts successfully deployed with **200ms finality** confirmed on Pod Network V1 Devnet.


