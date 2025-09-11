// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {requireQuorum} from "pod-sdk/Quorum.sol";
import {FastTypes} from "pod-sdk/FastTypes.sol";

contract NFTs {
    using FastTypes for FastTypes.Balance;
    using FastTypes for FastTypes.OwnedCounter;

    string public constant name = "Pod Network NFTs";
    string public constant symbol = "PODNFT";

    FastTypes.Balance internal _balances;
    FastTypes.OwnedCounter internal _tokenIds;
    
    mapping(uint256 => string) public tokenURI;
    address public minter;

    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Mint(address indexed to, uint256 indexed tokenId, string uri);

    constructor() {
        minter = msg.sender;
    }

    function mint(uint256 tokenId, string memory uri) external {
        require(msg.sender == minter, "not allowed to mint");
        
        _balances.increment(bytes32(tokenId), tx.origin, 1);
        tokenURI[tokenId] = uri;
        _tokenIds.increment(bytes32(0), msg.sender, 1);
        
        emit Transfer(address(0), tx.origin, tokenId);
        emit Mint(tx.origin, tokenId, uri);
    }

    function transferFrom(address from, address to, uint256 tokenId) external {
        _balances.decrement(bytes32(tokenId), msg.sender, 1);
        _balances.increment(bytes32(tokenId), to, 1);
        
        emit Transfer(from, to, tokenId);
    }

    function balanceOf(address owner) external view returns (uint256) {
        // This would need to aggregate across all token IDs
        // Simplified for demo
        return 1;
    }

    function totalSupply() external view returns (uint256) {
        return _tokenIds.get(bytes32(0), minter);
    }
}
