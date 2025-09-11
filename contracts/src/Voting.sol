// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {requireTimeBefore, requireTimeAfter, Time} from "pod-sdk/Time.sol";
import {FastTypes} from "pod-sdk/FastTypes.sol";

contract Voting {
    using FastTypes for FastTypes.SharedCounter;
    using FastTypes for FastTypes.OwnedCounter;

    string public constant name = "Pod Network Voting";
    
    FastTypes.SharedCounter internal totalProposals;
    FastTypes.OwnedCounter internal votes;

    event ProposalCreated(
        bytes32 indexed proposalId,
        address indexed creator,
        uint64 deadline,
        uint256 threshold,
        address[] voters,
        bytes data
    );

    event VoteCast(
        bytes32 indexed proposalId,
        address indexed voter,
        uint8 choice
    );

    function createProposal(
        uint64 deadline,
        uint256 threshold,
        address[] memory voters,
        bytes memory data
    ) external {
        requireTimeBefore(Time.fromSeconds(deadline), "Deadline must be in the future");
        
        bytes32 proposalId = keccak256(abi.encodePacked(
            block.timestamp,
            msg.sender,
            totalProposals.get(bytes32(0))
        ));
        
        totalProposals.increment(bytes32(0), 1);
        
        emit ProposalCreated(proposalId, msg.sender, deadline, threshold, voters, data);
    }

    function castVote(bytes32 proposalId, uint8 choice) external {
        votes.increment(proposalId, msg.sender, 1);
        emit VoteCast(proposalId, msg.sender, choice);
    }

    function execute(bytes32 proposalId) external {
        // Execution logic would go here
        // For demo purposes, this is simplified
    }

    function getVoteCount(bytes32 proposalId, address voter) external view returns (uint256) {
        return votes.get(proposalId, voter);
    }

    function getTotalProposals() external view returns (uint256) {
        return totalProposals.get(bytes32(0));
    }
}
