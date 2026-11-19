// SPDX-License-Identifier: MIT
pragma solidity ^0.8.38;

import { Script, console } from "lib/forge-std/src/Script.sol";
import { DevOpsTools } from "lib/foundry-devops/src/DevOpsTools.sol";
import { Basic_NFT } from "../src/basic-nft.sol";
import { SVG_NFT } from "../src/svg-nft.sol";

contract Mint_Basic_NFT is Script {
  string constant PUG = "https://bafkreihdpkml2wi3qn3hmf4mut23chh3ks7eeng353agc4m2emefaqjksq.ipfs.dweb.link?filename=pug.png";

  function run() external {
    address latestDeployedContract = DevOpsTools
      .get_most_recent_deployment("Basic_NFT", block.chainid);
    _mintNftOnContract(latestDeployedContract);
  }

  //////////////////////////////////////////////
  // helper function
  //////////////////////////////////////////////

  function _mintNftOnContract(address nftAddress) public {
    vm.startBroadcast();
    Basic_NFT(nftAddress).mintNft(PUG);
    vm.stopBroadcast();
  }
}

contract Mint_SVG_NFT is Script {
  function run() external {
    address latestDeployedContract = DevOpsTools
      .get_most_recent_deployment("SVG_NFT", block.chainid);
    _mintNftOnContract(latestDeployedContract);
  }

  //////////////////////////////////////////////
  // helper function
  //////////////////////////////////////////////

  function _mintNftOnContract(address nftAddress) public {
    vm.startBroadcast();
    SVG_NFT(nftAddress).mint('aqua');
    vm.stopBroadcast();
  }
}

// contract GetTokenURI is Script {
//   function run() external {
//     address latestDeployedContract = DevOpsTools
//       .get_most_recent_deployment("SVG_NFT", block.chainid);
//     getTokenURI(latestDeployedContract, 1);
//   }

//   function getTokenURI(address nftAddress, uint256 tokenId) public {
//     vm.startBroadcast();
//     string memory result = SVG_NFT(nftAddress).tokenURI(tokenId);
//     console.log('result', result);
//     vm.stopBroadcast();
//   }
// }
