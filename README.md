# Tokenized-Stock-Slam-Game


In this project, we present a tokenized version of the popular board game Stock Slam, where players compete against each other by trading fictional shares. In this project, players will place their ETH into a betting pool and obtain payouts based on the outcome of the game.\\

The rules of the game are defined as follows:
1. There are 5 players.
2. At the start of the game, each player pays 1 ETH to begin the game with 1000 StockTokens (ST) and 2 shares of each stock (5 stocks in total).
3. During the game, players can trade shares with each other. The trading can be done on an order book or bilaterally over-the-counter (OTC).
4. At the end of the game, 1 stock will be considered “in-the-money” (ITM) and worth 100 ST for each share. All other stocks will be considered worthless. 100 ST will be transferred to each holder of ITM shares.
5. The total net worth (in ST) of each trader will determine the payout from the original pool of 5 ETH.

This tokenized implementation of Stock Slam is made up of six contracts: StockToken, Stock, StockMarket, Player, Payout, and Play. 
- StockToken defines an ERC20 token.
- Stock and StockMarket handle trading and asset distribution respectively. These processes are trustless, meaning there is no need for a middleman (clearing house e.g. DTCC) to facilitate trading.
- Player.sol describes a balance of Eth and StockTokens each player has, their trade logs, their active games. 
- Payout.sol experiments with changes to how the game works and includes unique web3 features like airdrops and consensus voting. 
- Finally, Play.sol serves an ad-hoc main file for implementing and invoking a game, which typically lasts five rounds.

