const Play = artifacts.require("Play");
const StockToken = artifacts.require("StockToken");
const StockMarket = artifacts.require("StockMarket");

contract("Play", (accounts) => {
  let play;
  let stockToken;
  let stockMarket;

  beforeEach(async () => {
    stockToken = await StockToken.new(100);
    stockMarket = await StockMarket.new(stockToken.address);
    play = await Play.new(stockToken.address, stockMarket.address);
  });

  it("should allow a player to join the game by buying StockTokens", async () => {
    await play.joinGame({ value: web3.utils.toWei("1", "ether"), from: accounts[1] });
    const balance = await stockToken.balanceOf(accounts[1]);
    assert.equal(balance.toNumber(), 1000, "Player should have 1000 StockTokens after joining the game");
  });

  it("should allow a player to play a round", async () => {
    await play.joinGame({ value: web3.utils.toWei("1", "ether"), from: accounts[1] });
    await play.playRound({ from: accounts[1] });
    // Add assertions to verify that the round has been played and the state of the game has changed accordingly
  });

 
});

