// SPDX-License-Identifier: MIT
pragma solidity ^0.8.38;

// import { Script } from "forge-std/Script.sol";
import { Script } from "lib/forge-std/src/Script.sol";
import { Basic_NFT } from "../src/basic-nft.sol";
import { SVG_NFT } from "../src/svg-nft.sol";

contract Deploy_Basic_NFT is Script {
  function run() external returns(Basic_NFT) {
    vm.startBroadcast();
    Basic_NFT basicNft = new Basic_NFT();
    vm.stopBroadcast();
    return basicNft;
  }
}

contract Deploy_SVG_NFT is Script {
  function run() external returns(SVG_NFT) {
    vm.startBroadcast();
    SVG_NFT svgNft = new SVG_NFT();
    vm.stopBroadcast();
    return svgNft;
  }
}
