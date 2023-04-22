pragma solidity ^0.8.0;

import "./Stock.sol";
import "./StockToken.sol";

contract StockMarket {
    struct Order {
        uint256 price;
        address seller;
    }

    mapping (uint256 => mapping (uint256 => Order)) public orderBook;
    mapping (address => mapping (uint256 => Order)) public buyBook;
    uint256 STOCK_COUNT = 5;
    uint256 SHARE_COUNT = 10;

    Stock private stock;
    StockToken private stockToken;

    event NewSellOrder(address indexed seller, address indexed stock, uint256 amount, uint256 price);
    event NewBuyOrder(address indexed buyer, address indexed stock, uint256 amount, uint256 price);

    constructor(StockToken _stockToken, Stock _stock) {
        stock = _stock;
        stockToken = _stockToken;
    }

    function list(uint256 stockId, uint256 shareId) public {
        require(stockId < STOCK_COUNT && shareId < SHARE_COUNT, "Invalid stock or share ID");
        require(stock.getOwner(stockId, shareId) == msg.sender, "Only the share owner can list the share");

        stock.transfer(stockId, shareId, address(this));
     
        Order memory newOrder = Order({
        price: stock.getPrice(stockId, shareId),
        seller: stock.getprevOwner(stockId, shareId)
        });

        // add new order to the order book for the stock and share
        orderBook[stockId][shareId] = newOrder;
    }

    function refreshOrderBook() public {
        for (uint256 i = 0; i < STOCK_COUNT; i++) {
            for (uint256 j = 0; j < SHARE_COUNT; j++) {
                orderBook[i][j].price = stock.getPrice(i, j);
                orderBook[i][j].seller = stock.getprevOwner(i, j);
            }
        }
    }

    function seeLowestPrice(uint256 stockId) public view returns (uint256, uint256, uint256) {
        refreshOrderBook;
        uint256 lowestPrice = 0;
        bool found = false;
        uint256 lowestshareId;

        for (uint256 i = 0; i < SHARE_COUNT; i++) {
            if (orderBook[stockId][i].seller != address(0)) {
                if (!found || orderBook[stockId][i].price < lowestPrice) {
                    lowestPrice = orderBook[stockId][i].price;
                    lowestshareId = i;
                    found = true;
                }
            }
        }

        require(found, "No shares listed for the given stock");
        return (stockId, lowestshareId, lowestPrice);
    }

    function buy(uint256 stockId, uint256 shareId, uint256 price) public {
        
        refreshOrderBook;
        require(stockId < STOCK_COUNT && shareId < SHARE_COUNT, "Invalid stock or share ID");
        Order memory order = orderBook[stockId][shareId];
        require(order.seller != address(0), "No order available for this share");
        require(msg.sender != order.seller, "Buyer cannot be the seller");
        require(price == order.price, "Price doesn't match the listed order price");

        // Transfer the stock from the market contract to the buyer
        stock.sellShare(stockId, shareId, msg.sender);
        // Transfer ST from the buyer to the seller
        stockToken.transfer(order.seller, price);

        // Remove the order from the order book
        delete orderBook[stockId][shareId];

        emit NewBuyOrder(msg.sender, address(stock), shareId, price);

    }

    function unlist(uint256 stockId, uint256 shareId) public {
        Order memory order = orderBook[stockId][shareId];
        require(order.seller == msg.sender, "Only seller can unlist");
        stock.transfer(stockId, shareId, msg.sender);
        delete orderBook[stockId][shareId];
    }
    
}