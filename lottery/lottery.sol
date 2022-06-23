// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.0 <0.9.0;

contract Lottery{
    address public manager;//addaress of manager
    address payable[] public participants;//when participant win lottery this application send the ether so we use payable.

//manager have control of this contract
    constructor(){
        manager=msg.sender; //global variable
    }

//receive is a sepcial type of func. receive func is used only one time in a contract ,external keyword is compulsory
//and doesbot take any parameters.
//we are using this to transfer ether into contract
    receive() external payable{
        //when we receive ether we register the address of the sender 
        require(msg.value==1 ether);
        participants.push(payable(msg.sender));
    }

    function getBalance()  public view returns(uint){
        require (msg.sender==manager);
        return address (this).balance;
    }

    //select random participant
    function random() public view returns (uint){
       return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp,participants.length))); //This is random selection function//keccak256 is hashing algorithm
    }


    //fetching winner index from randon address
    function selectWinner() public {
        require(msg.sender==manager);    //condition
        require(participants.length>=3);   //condition
        uint r=random();        //r is the random value that is selected
        address payable winner ;
        uint index=r % participants.length;    //This ampercents gives the remaiinder eg 5%4=1
        winner=participants[index];
        winner.transfer(getBalance());//sendiing ether to winner
        participants=new address payable[](0); //resetting our dynamic array

    }
}