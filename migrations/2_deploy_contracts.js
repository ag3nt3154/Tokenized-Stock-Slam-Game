const StockToken = artifacts.require("StockToken");
const Stock = artifacts.require("Stock");
const StockMarket = artifacts.require("StockMarket");
const Player = artifacts.require("Player");
const Payout = artifacts.require("Payout");
const Play = artifacts.require("Play");

module.exports = async (deployer, network, accounts) => {
    await deployer.deploy(StockToken, web3.utils.toWei("0.02", "ether"));
    const stockToken = await StockToken.deployed();

    await deployer.deploy(Stock, stockToken.address, [accounts[1], accounts[2], accounts[3], accounts[4], accounts[5]]);
    const stock = await Stock.deployed();

    await deployer.deploy(StockMarket, stockToken.address, stock.address);
    const stockMarket = await StockMarket.deployed();

    await deployer.deploy(Player, stockToken.address, stockMarket.address);
    const player = await Player.deployed();

    await deployer.deploy(Payout, stockToken.address, stockMarket.address);
    const payout = await Payout.deployed();

    await deployer.deploy(Play, stockToken.address, stockMarket.address, player.address, payout.address);
};

