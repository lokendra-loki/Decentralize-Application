

async function main() {
  const [deployer] = await ethers.getSigners();

  // We get the contract to deploy
  const Token = await ethers.getContractFactory("Token"); //instance
  const token = await Token.deploy("Hello, Hardhat!"); //deploy
  console.log("Token address:", token.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
