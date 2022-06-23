const { expect } = require("chai"); //chai library for testing


describe("Token contract", function () {
  it("Deployment should assign the totalSupply of token to the owner", async function () {
    const [owner] = await ethers.getSigners(); //getSigners is an object through which we can access the account information
    console.log("Signers object: ", owner);

    //Instance of a contract
    const Token = await ethers.getContractFactory("Token"); //creating instance

    //deploying this instance
    const hardhatToken = await Token.deploy(); //deploy contract

    //checking owner balance
    const ownerBalance = await hardhatToken.balanceOf(owner.address);//owner balance 10000
    console.log(owner.address);

    expect (await hardhatToken.totalSupply()).to.equal(ownerBalance);//totalSupply=owner balance
  });
});
