# Tokenized-Stock-Slam-Game
In this project, we present a tokenized version of the popular board game Stock Slam, where players compete against each other by trading fictional shares. In this project, players will place their ETH into a betting pool and obtain payouts based on the outcome of the game.\

### The rules of the game are defined as follows:

There are 5 players.
At the start of the game, each player pays 1 ETH to begin the game with 1000 StockTokens (ST) and 2 shares of each stock (5 stocks in total).
During the game, players can trade shares with each other. The trading can be done on an order book or bilaterally over-the-counter (OTC).
At the end of the game, 1 stock will be considered “in-the-money” (ITM) and worth 100 ST for each share. All other stocks will be considered worthless. 100 ST will be transferred to each holder of ITM shares.
The total net worth (in ST) of each trader will determine the payout from the original pool of 5 ETH.
This tokenized implementation of Stock Slam is made up of six contracts: StockToken, Stock, StockMarket, Player, Payout, and Play.

### StockToken defines an ERC20 token.
Stock and StockMarket handle trading and asset distribution respectively. These processes are trustless, meaning there is no need for a middleman (clearing house e.g. DTCC) to facilitate trading.
Player.sol describes a balance of Eth and StockTokens each player has, their trade logs, their active games.
Payout.sol experiments with changes to how the game works and includes unique web3 features like airdrops and consensus voting.
Finally, Play.sol serves an ad-hoc main file for implementing and invoking a game, which typically lasts five rounds.

# Install Instructions
## Prerequisites
Before you begin, please ensure that you have the following tools installed on your local machine:
- Docker
- Node
- Truffle Suite Ganache

Download Docker, LTS Node and Truffle Ganache for your OS from the Docker website.

Project Setup
```
Clone this repository and navigate to the project directory.
git clone https://github.com/ag3nt3154/Tokenized-Stock-Slam-Game
cd Tokenized-Stock-Slam-Game
```

Install project dependencies using npm.
```
npm install
```
Launch Ganache to set up a local Ethereum blockchain.
Deploy the smart contracts to the local Ethereum blockchain using Remix Ethereum IDE.
Update the project configuration to use the contract addresses obtained from the deployment step.


Create a Docker image for the project.
```
To launch 
docker build -t tokenized-stock-slam .
```
To test truffle: 
```
truffle compile 
truffle compile
```

