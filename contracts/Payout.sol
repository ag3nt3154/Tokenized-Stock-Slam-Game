// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./StockMarket.sol";

contract Payout is StockMarket {
    // Events
    event PerformanceBonus(address indexed player, uint256 bonus);
    event ProgressiveReward(address indexed player, uint256 reward);
    event Airdrop(address indexed player, uint256 amount);
    event VotingReward(address indexed player, uint256 reward);

    constructor(StockToken _stockToken, Stock _stock) StockMarket(_stockToken, _stock) {}

    // Performance-based bonuses
    function performanceBonus(address player, uint256 bonus) public {
        require(msg.sender == address(stockToken), "Only the StockToken contract can issue performance bonuses");
        stockToken.transfer(player, bonus);
        emit PerformanceBonus(player, bonus);
    }

    // Round-based progressive rewards
    function roundReward(address player, uint256 reward) public {
        require(msg.sender == address(stockToken), "Only the StockToken contract can issue round rewards");
        stockToken.transfer(player, reward);
        emit ProgressiveReward(player, reward);
    }

    // Random "airdrop" events
    function airdrop(address player, uint256 amount) public {
        require(msg.sender == address(stockToken), "Only the StockToken contract can issue airdrops");
        stockToken.transfer(player, amount);
        emit Airdrop(player, amount);
    }

    // Voting-based rewards (market allocation rule changes from the players' consensus)
    function votingReward(address player, uint256 reward) public {
        require(msg.sender == address(stockToken), "Only the StockToken contract can issue voting rewards");
        stockToken.transfer(player, reward);
        emit VotingReward(player, reward);
    }
}
