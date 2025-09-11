// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {requireQuorum} from "pod-sdk/Quorum.sol";
import {FastTypes} from "pod-sdk/FastTypes.sol";

contract Tokens {
    using FastTypes for FastTypes.Balance;

    string public name;
    string public symbol;
    int256 public totalSupply;

    FastTypes.Balance internal _balances;

    event Transfer(address indexed from, address indexed to, int256 value);
    event Approval(address indexed owner, address indexed spender, int256 value);

    constructor(
        string memory tokenName,
        string memory tokenSymbol,
        int256 initialSupply
    ) {
        name = tokenName;
        symbol = tokenSymbol;
        totalSupply = initialSupply;
        
        // Mint initial supply to deployer
        _balances.increment(bytes32(uint256(uint160(symbol))), msg.sender, uint256(initialSupply));
    }

    function transfer(address to, int256 amount) external returns (bool) {
        _balances.decrement(bytes32(uint256(uint160(symbol))), msg.sender, uint256(amount));
        _balances.increment(bytes32(uint256(uint160(symbol))), to, uint256(amount));
        
        emit Transfer(msg.sender, to, amount);
        return true;
    }

    function approve(address spender, int256 amount) external returns (bool) {
        // Simplified approval logic
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function balanceOf(address account) external view returns (uint256) {
        return _balances.get(bytes32(uint256(uint160(symbol))), account);
    }
}
