const StockToken = artifacts.require("StockToken");
const Stock = artifacts.require("Stock");

module.exports = async (deployer, network, accounts) => {
    await deployer.deploy(StockToken, web3.utils.toWei("0.02", "ether"));
    await deployer.deploy(Stock, StockToken.address, [accounts[1], accounts[2], accounts[3], accounts[4], accounts[5]]);
};