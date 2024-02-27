import { ethers } from "hardhat";

async function main() {
  

  const social = await ethers.deployContract("SocialMedia");

  await social.waitForDeployment();

  console.log(
    `deployed to ${social.target}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
