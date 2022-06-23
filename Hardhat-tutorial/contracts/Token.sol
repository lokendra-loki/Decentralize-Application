// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.0 <0.9.0;

//Contract
contract Token{
    string public name="Hardhat Token";
    string public symbol="HHT";
    uint public totalSupply=10000;
    address public owner;
    mapping(address=>uint) balances;   //13444 has 50 token and 13443 has 50 token like this

    //constructor
    constructor(){
        balances[msg.sender]=totalSupply;  //whoever deoloying this contract will get totalSupply token in his address
        owner=msg.sender; //whoever deploying this contract will be the owner  
    }

    //Token transfer function
    function transfer(address to, uint amount) external{
        require(balances[msg.sender]>=amount,"Not enough Token"); //Checking balance of sender
        //if true reduce balance from sender
        balances[msg.sender]-=amount;  //balances[msg.sender]=balances[msg.sender]-amount
        balances[to]+=amount; //add balance to ther receiver account
    }

    //balance checking function
    function balanceOf(address account) external view returns(uint){
        return balances[account];
    }

}
 