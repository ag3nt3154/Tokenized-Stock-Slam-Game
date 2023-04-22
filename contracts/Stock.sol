// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./StockToken.sol";

contract Stock {
    struct Share {
        address prevOwner;
        address owner;
        uint256 askPrice;
    }
    
    mapping(uint256 => Share[]) private stocks;
    uint256 public constant STOCK_COUNT = 5;
    uint256 public constant SHARE_COUNT = 10;
    StockToken private st;
    
    constructor(address stAddress, address[] memory playerAddresses) {
        require(playerAddresses.length == STOCK_COUNT, "Must provide 5 player addresses");
        st = StockToken(stAddress);
        for (uint256 i = 0; i < STOCK_COUNT; i++) {
            for (uint256 j = 0; j < SHARE_COUNT / 2; j++) {
                uint256 shareIndex = j;
                stocks[i].push(Share(address(this), playerAddresses[shareIndex], 6000));
                stocks[i].push(Share(address(this), playerAddresses[shareIndex], 6000));
            }
        }
    }
    
    function changeAskPrice(uint256 stockId, uint256 shareId, uint256 newPrice) public {
        require(stocks[stockId][shareId].owner == msg.sender, "Only the share owner can change the ask price");
        stocks[stockId][shareId].askPrice = newPrice;
    }
    
    function sellShare(uint256 stockId, uint256 shareId, address recipient) public {
        require(stocks[stockId][shareId].owner == msg.sender, "Only the share owner can transfer the share");
        uint256 price = stocks[stockId][shareId].askPrice;
        require(st.transferFrom(recipient, address(this), price), "Transferring ST failed");
        stocks[stockId][shareId].owner = recipient;
        stocks[stockId][shareId].prevOwner = msg.sender;
    }
    
    function getStock(uint256 stockId) public view returns (Share[] memory) {
        return stocks[stockId];
    }

    function getPrice(uint256 stockId, uint256 shareId) public view returns (uint256 askPrice) {
        return stocks[stockId][shareId].askPrice;
    }

    function getOwner(uint256 stockId, uint256 shareId) public view returns (address owner) {
        return stocks[stockId][shareId].owner;
    }

    function getprevOwner(uint256 stockId, uint256 shareId) public view returns (address preOwner) {
        return stocks[stockId][shareId].prevOwner;
    }

    function transfer(uint256 stockId, uint256 shareId, address marketAddress) public {
        require(stocks[stockId][shareId].owner == msg.sender, "Only the share owner can transfer the share");
        stocks[stockId][shareId].prevOwner = stocks[stockId][shareId].owner;
        stocks[stockId][shareId].owner = marketAddress;
    }
}