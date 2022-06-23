const { expect } = require("chai"); //chai library for testing

// describe("Token contract", function () {
//   it("Deployment should assign the totalSupply of token to the owner", async function () {
//     const [owner] = await ethers.getSigners(); //getSigners is an object through which we can access the account information
//     console.log("Signers object: ", owner);

//     //Instance of a contract
//     const Token = await ethers.getContractFactory("Token"); //creating instance

//     //deploying this instance
//     const hardhatToken = await Token.deploy(); //deploy contract

//     //checking owner balance
//     const ownerBalance = await hardhatToken.balanceOf(owner.address); //owner balance 10000
//     console.log(owner.address);

//     expect(await hardhatToken.totalSupply()).to.equal(ownerBalance); //totalSupply=owner balance
//   });

//   //Testing for Token transfer function
//   it("Should transfer token between accounts", async function () {
//     const [owner, address1, address2] = await ethers.getSigners();
//     console.log("Signers object: ", owner);

//     //Instance of a contract
//     const Token = await ethers.getContractFactory("Token"); //creating instance

//     //deploying this instance
//     const hardhatToken = await Token.deploy(); //deploy contract

//     //Transfer 10 token from owner to address1
//     await hardhatToken.transfer(address1.address, 10); //transfer 10 token to address1
//     expect(await hardhatToken.balanceOf(address1.address)).to.equal(10);

//     //Transfer 5 token from address1 to address2
//     await hardhatToken.connect(address1).transfer(address2.address,5)//connecting address1 and address2 and transfer 5 token
//     expect(await hardhatToken.balanceOf(address2.address)).to.equal(5);
//   });
// });

//======>This code is absolutely correct but problems is repeated code let make compact using mocha hooks=======>

describe("Token contract", function () {
  let token;
  let hardhatToken;
  let owner;
  let address1;
  let address2;

  // runs before each test in this block
  beforeEach(async function () {
    const Token = await ethers.getContractFactory("Token"); //creating instance of token
    [owner, address1, address2, ...address] = await ethers.getSigners(); //getSigners is an object through which we can access the account information
    hardhatToken = await Token.deploy(); //deploy contract
  });

  describe("Deployment", function () {
    //we have set the owner through constructor in token.sol file //here we are checking owner is set successfully or not
    it("Should set the right owner", async function () {
      expect(await hardhatToken.owner()).to.equal(owner.address);
    });

    //checking constructor of Token.sol
    it("Should assign the totalSupply of token to the owner", async function () {
      const ownerBalance = await hardhatToken.balanceOf(owner.address);
      expect(await hardhatToken.totalSupply()).to.equal(ownerBalance);
    });
  });

  //Checking Transaction
  describe("Transaction", function () {
    it("Should transfer token between accounts", async function () {
      await hardhatToken.transfer(address1.address, 5); //transfer 5 token from owner account to address1//iif we dont specify that means owner account
      const address1Balance = await hardhatToken.balanceOf(address1.address);
      expect(address1Balance).to.equal(5);

      //connecting address1 and address2 and transferring 5 token from address1 to address2 now address1 has 0 token
      await hardhatToken.connect(address1).transfer(address2.address, 5);
      const address2Balance = await hardhatToken.balanceOf(address2.address);
      expect(address2Balance).to.equal(5);
    });

    //Failed
    if (
      ("Should fail sender does not have enough token",
      async function () {
        const initialOwnerBalance = await hardhatToken.balanceOf(owner.address);
        //transfer 1 token from address1 to owner
        //initially address1 has 0 token so we want to confirm that is called test
        await expect(
          hardhatToken.connect(address1).transfer(owner.address, 1)
        ).to.be.revertedWith("Not enough token");

        //checking present balance =initial owner balance i.e, 1000
        expect(await hardhatToken.balanceOf(owner.address)).to.equal(
          initialOwnerBalance
        );
      })
    );

    //After transaction balance update test
    it("Should update balance after transaction", async function () {
      const initialOwnerBalance = await hardhatToken.balanceOf(owner.address);
      await hardhatToken.transfer(address1.address, 5); //owner to address1
      await hardhatToken.transfer(address2.address, 10); //owner to address2
      const finalOwnerBalance = await hardhatToken.balanceOf(owner.address);
      expect(finalOwnerBalance).to.equal(initialOwnerBalance - 15);

      const address1Balance = await hardhatToken.balanceOf(address1.address);
      expect(address1Balance).to.equal(5);

      const address2Balance = await hardhatToken.balanceOf(address2.address);
      expect(address2Balance).to.equal(10);
    });
  });
});
