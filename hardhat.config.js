require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();
require('@openzeppelin/hardhat-upgrades');

module.exports = {
  solidity: "0.8.19",
  networks: {
    goerli: {
      url: `https://goerli.infura.io/v3/${process.env.apiPublicKeyEthereum}`,
      accounts: [process.env.privateKey]
    },
  }
};