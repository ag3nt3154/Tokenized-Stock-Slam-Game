const _deploy_contracts = require("../migrations/2_deploy_contracts");
const truffleAssert = require('truffle-assertions');
var assert = require('assert');

var StockToken = artifacts.require("../contracts/StockToken.sol");
var Stock = artifacts.require("../contracts/Stock.sol");


contract('StockSlam', function(accounts) {

    before(async () => {

        StockTokenInstance = await StockToken.deployed();
        StockInstance = await Stock.deployed(StockTokenInstance.address, [accounts[1], accounts[2], accounts[3], accounts[4], accounts[5]]);

    });

    console.log("Testing Stock Token Contract");

    it('Join game', async () => {
        let D0 = await StockTokenInstance.topUpST({from: accounts[0], value: web3.utils.toWei("1.02", "ether")});
        let D1 = await StockTokenInstance.topUpST({from: accounts[1], value: web3.utils.toWei("1.02", "ether")});
        let D2 = await StockTokenInstance.topUpST({from: accounts[2], value: web3.utils.toWei("1.02", "ether")});
        let D3 = await StockTokenInstance.topUpST({from: accounts[3], value: web3.utils.toWei("1.02", "ether")});
        let D4 = await StockTokenInstance.topUpST({from: accounts[4], value: web3.utils.toWei("1.02", "ether")});
        let D5 = await StockTokenInstance.topUpST({from: accounts[5], value: web3.utils.toWei("1.02", "ether")});
        

        assert.notStrictEqual(D0, undefined, "Failed to join game 0");
        assert.notStrictEqual(D1, undefined, "Failed to join game 1");
        assert.notStrictEqual(D2, undefined, "Failed to join game 2");
        assert.notStrictEqual(D3, undefined, "Failed to join game 3");
        assert.notStrictEqual(D4, undefined, "Failed to join game 4");
        assert.notStrictEqual(D5, undefined, "Failed to join game 5");

    });

    
    it('change ask price', async () => {
        let C0 = await StockInstance.changeAskPrice(0, 0, 100, {from: accounts[1]})
        
        assert.notStrictEqual(C0, undefined, "Failed to change ask price");
        let ask_price = await StockInstance.getPrice(0, 0, {from: accounts[5]})
        assert.equal(ask_price, 100, "New price incorrect")

    });



    it('distributeEther', async () => {
        
        await StockTokenInstance.transfer(accounts[1], 200, {from: accounts[0]});
        await StockTokenInstance.transfer(accounts[2], 200, {from: accounts[0]});
        await StockTokenInstance.transfer(accounts[3], 200, {from: accounts[0]});
        await StockTokenInstance.transfer(accounts[4], 200, {from: accounts[0]});
        await StockTokenInstance.transfer(accounts[5], 200, {from: accounts[0]});

        let b1 = await StockTokenInstance.balanceOf(accounts[1], {from: accounts[0]});
        assert.equal(b1, 1200, "account balance correct");

        let E0 = await StockTokenInstance.distributeEther({from: accounts[0], value: web3.utils.toWei("5", "ether")});

        assert.notStrictEqual(E0, undefined, "Failed to distributeEther");

    });

    

});



