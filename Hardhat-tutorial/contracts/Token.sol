// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.0 <0.9.0;

import "../node_modules/hardhat/console.sol";

//Contract
contract Token {
    string public name = "Hardhat Token";
    string public symbol = "HHT";
    uint256 public totalSupply = 10000;
    address public owner;
    mapping(address => uint256) balances; //13444 has 50 token and 13443 has 50 token like this

    //constructor
    constructor() {
        balances[msg.sender] = totalSupply; //whoever deoloying this contract will get totalSupply token in his address
        owner = msg.sender; //whoever deploying this contract will be the owner
    }

    //Token transfer function
    function transfer(address to, uint256 amount) external {
        console.log("***Sender's balance is %s token", balances[msg.sender]); //debug //*** iis given to detect easily these line in console
        console.log("***Sender is sending %s token to %s address", amount, to); //debug
        require(balances[msg.sender] >= amount, "Not enough Token"); //Checking balance of sender
        //if true reduce balance from sender
        balances[msg.sender] -= amount; //balances[msg.sender]=balances[msg.sender]-amount
        balances[to] += amount; //add balance to ther receiver account
    }

    //balance checking function
    function balanceOf(address account) external view returns (uint256) {
        return balances[account];
    }
}
