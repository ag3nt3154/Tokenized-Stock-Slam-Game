pragma solidity ^0.8.0;

import "./StockToken.sol";

contract Player {
    struct AssetPermission {
        uint256 assetId;
        bool isPermitted;
    }

    struct TradeLogEntry {
        uint256 stockId;
        uint256 shareId;
        uint256 price;
        bool isBuy;
        uint256 timestamp;
    }

    address public playerAddress;
    mapping(uint256 => AssetPermission) public assetPermissions;
    TradeLogEntry[] public tradeLog;
    StockToken private stockToken;

    constructor(address _playerAddress, address _stockTokenAddress) {
        playerAddress = _playerAddress;
        stockToken = StockToken(_stockTokenAddress);
    }

    function balance() public view returns (uint256) {
        return stockToken.balanceOf(playerAddress);
    }

    function setAssetPermission(uint256 assetId, bool isPermitted) public {
        require(msg.sender == playerAddress, "Only the player can set asset permissions");
        assetPermissions[assetId] = AssetPermission(assetId, isPermitted);
    }

    function addTradeLogEntry(
        uint256 stockId,
        uint256 shareId,
        uint256 price,
        bool isBuy
    ) public {
        require(msg.sender == playerAddress, "Only the player can add trade log entries");
        tradeLog.push(
            TradeLogEntry(stockId, shareId, price, isBuy, block.timestamp)
        );
    }

    function getTradeLogLength() public view returns (uint256) {
        return tradeLog.length;
    }

    function getTradeLogEntry(uint256 index) public view returns (TradeLogEntry memory) {
        require(index < tradeLog.length, "Invalid trade log entry index");
        return tradeLog[index];
    }
}
