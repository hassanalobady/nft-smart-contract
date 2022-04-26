const { ethers } = require("hardhat")

async function main() {
  const DerbyVerse = await ethers.getContractFactory("DerbyVerse")
  const derbyVerse = await DerbyVerse.deploy("DerbyVerse", "CBEET")

  await derbyVerse.deployed()
  console.log(`Contract successfully deployed to ${derbyVerse.address}`)

  const newItemId = await derbyVerse.mint("https://gateway.pinata.cloud/ipfs/QmegTwvy9QrwKBDcvPukrDdAQdetmkW1LMDyepLi23shmk")
  console.log(`NFT minted successfully :: ${newItemId}`)
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
