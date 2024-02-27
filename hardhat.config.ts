import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import dotenv from "dotenv";

dotenv.config();

const config: HardhatUserConfig = {
  solidity: "0.8.24",
  networks:{
    mumbai: {
      url: `https://polygon-mumbai.g.alchemy.com/v2/${process.env.ALCHEMY}`,
      accounts: [`${process.env.PRIVATE_KEY}`],
    }
  },
  etherscan: {
    apiKey: `${process.env.POLYGON_SCAN}`,
  }
};

export default config;