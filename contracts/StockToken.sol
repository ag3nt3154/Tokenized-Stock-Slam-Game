// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

interface IERC20 {

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event end_game(uint256 value);

    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

}

contract StockToken is IERC20 {
    string public constant name = "StockToken";
    string public constant symbol = "ST";
    uint8 public constant decimals = 18;
    mapping (address => uint256) private accounts;
    mapping (address => mapping (address => uint256)) private _allowances;
    uint256 public total_supply = 6000;
    uint public player_count = 0;
    uint256 commission_fee;

    mapping (uint => address) private id_to_address;

    

    constructor(uint256 _commissionFee) {
        commission_fee = _commissionFee;
    }

    function totalSupply() public view override returns (uint256) {
        return total_supply;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return accounts[account];
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        require(amount <= accounts[msg.sender], "Insufficient balance");
        accounts[msg.sender] -= amount;
        accounts[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        require(amount <= accounts[sender], "Insufficient balance");
        require(amount <= _allowances[sender][msg.sender], "Insufficient allowance");
        accounts[sender] -= amount;
        accounts[recipient] += amount;
        _allowances[sender][msg.sender] -= amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }

    function topUpST() public payable {
        require(msg.value == 1 ether + commission_fee, "Please pay 1 ether + commission fee");
        require(balanceOf(msg.sender) == 0, "Sender already owns ST");
        require(total_supply > 0, "Too many players");

        total_supply -= 1000;
        accounts[msg.sender] = 1000;
        
        id_to_address[player_count] = msg.sender;

        address addr = id_to_address[player_count];

        require(balanceOf(addr) == 1000, 'account balance');

        player_count++;

        // id = 0 is the game master
        payable(id_to_address[0]).transfer(msg.value);
    }

    function distributeEther() public payable{
        // called by game master
        require(msg.value == 5 ether, "Pay 5 ether to settle the game");
        require(total_supply == 0, "There must be a game ongoing");

        uint256 totalST = 6000;
        uint256 stBalance;
        uint256 amountToSend;

        for (uint256 i = 1; i <= 5; i ++) {
            require(id_to_address[i] != address(0), 'valid address');
            stBalance = balanceOf(id_to_address[i]);

            amountToSend = msg.value * stBalance / totalST ;

            payable(id_to_address[i]).transfer(amountToSend);
        }
    }
}