// SPDX-License-Identifier: MIT
pragma solidity ^0.8.38;

import { Script } from "lib/forge-std/src/Script.sol";
import { DevOpsTools } from "lib/foundry-devops/src/DevOpsTools.sol";
import { BasicNft } from "../src/basic-nft.sol";

contract MintBasicNft is Script {
  string constant PUG = "https://bafkreihdpkml2wi3qn3hmf4mut23chh3ks7eeng353agc4m2emefaqjksq.ipfs.dweb.link?filename=pug.png";

  function run() external {
    address mostRecentlyDeployedBasicNft = DevOpsTools
      .get_most_recent_deployment("BasicNft", block.chainid);
    _mintNftOnContract(mostRecentlyDeployedBasicNft);
  }

  //////////////////////////////////////////////
  // helpers
  //////////////////////////////////////////////

  function _mintNftOnContract(address basicNftAddress) public {
    vm.startBroadcast();
    BasicNft(basicNftAddress).mintNft(PUG);
    vm.stopBroadcast();
  }
}
