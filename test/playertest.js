const Player = artifacts.require("Player");

contract("Player", (accounts) => {
  let player;

  beforeEach(async () => {
    player = await Player.new();
  });

  it("should initialize player with zero balance", async () => {
    const balance = await player.balance();
    assert.equal(balance.toNumber(), 0, "Initial balance should be zero");
  });

  it("should update player balance after receiving tokens", async () => {
    await player.receiveTokens(100, { from: accounts[0] });
    const balance = await player.balance();
    assert.equal(balance.toNumber(), 100, "Balance should be updated after receiving tokens");
  });

  it("should allow a player to set permission for an asset", async () => {
    await player.setAssetPermission(1, true, { from: accounts[0] });
    const permission = await player.getAssetPermission(1);
    assert.equal(permission, true, "Asset permission should be set correctly");
  });

  it("should add a trade to the trade log", async () => {
    const trade = {
      stockId: 1,
      shareId: 2,
      price: 50,
      buy: true,
    };

    await player.addTrade(trade.stockId, trade.shareId, trade.price, trade.buy, { from: accounts[0] });
    const tradeLogCount = await player.getTradeLogCount();
    const loggedTrade = await player.getTrade(tradeLogCount - 1);

    assert.equal(tradeLogCount.toNumber(), 1, "Trade log count should be incremented");
    assert.equal(loggedTrade.stockId.toNumber(), trade.stockId, "Stock ID should match");
    assert.equal(loggedTrade.shareId.toNumber(), trade.shareId, "Share ID should match");
    assert.equal(loggedTrade.price.toNumber(), trade.price, "Price should match");
    assert.equal(loggedTrade.buy, trade.buy, "Buy/sell indicator should match");
  });
});

