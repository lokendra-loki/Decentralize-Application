// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.0 <0.9.0;


contract CroudFunding {
    mapping(address=>uint) public contributors; //address linking to contributors
    address public manager;
    uint public minContribution;
    uint public deadline;
    uint public target;
    uint public raisedAmount;
    uint public noOfContributors;

   //manager defines the target and deadline
   //constructor is the first function- that gets executed when contract is deployed
    constructor(uint _target,uint _deadline){
        target=_target; //like 20000 is target
        deadline=block.timestamp+_deadline;//current block ko timestamp (unix form) + 3600sec(1hour)
        minContribution=100 wei;
        manager=msg.sender;

    }

    //Contributors will transfer the ether
    function sendEther() public payable{
        //check if deadline already acossed or not
        require(block.timestamp < deadline ,"Deadline has bassed you cannot donate !");
        //minimum contribution check
        require(msg.value >= minContribution ,"Minimum contributiion is not met");

        //all requirement met
        if (contributors[msg.sender]==0){  //by default noOfContributors is zero
            noOfContributors++; //increase by 1
        }

        //if contributor contributed more than 1 times
        contributors[msg.sender]+=msg.value;
        raisedAmount+=msg.value;

    }

    //checking balance of contract
    function  getContractBalance() public view returns (uint){
        return address(this).balance;
    }

    //if target dont met contributor get the refunded
    function refund() public{
        //refund if deadline crossed and target didnot match
        require(block.timestamp > deadline && raisedAmount < target,"You are not eligible for refund");

        //checking if contributor sent ether or not 
        //otherwise some user can get refund althgough they never send ethet to contract then only we will refund
        require(contributors[msg.sender]>0);

        //if these condition match  then refund 
        //msg.sender is requesting for refund
        address payable user =payable(msg.sender); //address reuquestg for refund
        user.transfer(contributors[msg.sender]);
        contributors[msg.sender]=0;
    }

    //manager can access the ether only when 50% of the contributor agree
    

}