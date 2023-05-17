//SPDX=License-Inditifier: MIT
pragma solidity 0.8.19;

contract VendingMachine {
    address payable public owner;
    uint256 public sodasAvailable;
    mapping(address => uint256) public balances;
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can make this call");
        _;
    }

    constructor() {
        owner = payable(msg.sender); // ADDRESS OF OWNER
        sodasAvailable = 100;
    }

    function buySoda() public payable {
        require(msg.value >= 1 ether, "You need to send 1 ether to get a soda");
        //require(sodasAvailable > 0, "No sodas left, please come back later");
        uint256 numSodasToBuy = msg.value / (1 ether);  // Calculate the number of sodas to buy
        require(numSodasToBuy <= sodasAvailable, "Not enough sodas available");


        sodasAvailable -= numSodasToBuy;
        balances[msg.sender] += numSodasToBuy * (1 ether);  // Increment the buyer's balance accordingly
    }

    function withdrawFunds() public payable onlyOwner() {
        require(address(this).balance > 0, "No funds available to withdraw");

        uint256 contractBalance = address(this).balance;
        owner.transfer(contractBalance);
    }

    function restock(uint256 _amount) public onlyOwner {
        sodasAvailable += _amount;
    }

    
}
