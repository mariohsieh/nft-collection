// SPDX-License-Identifier: MIT
pragma solidity ^0.8.38;

import { Test } from "lib/forge-std/src/Test.sol";
import { DeployBasicNft } from "../script/deploy-basic-nft.s.sol";
import { BasicNft } from "../src/basic-nft.sol";

contract BasicNftTest is Test {
  BasicNft public basicNft;
  address public user = makeAddr("user");
  string constant PUG = "https://bafkreihdpkml2wi3qn3hmf4mut23chh3ks7eeng353agc4m2emefaqjksq.ipfs.dweb.link?filename=pug.png";

  function setUp() public {
    DeployBasicNft deployer = new DeployBasicNft();
    basicNft = deployer.run();
  }

  function testNameAndSymbolAreSet() public view {
    // arrange
    string memory expectedName = "Doggy";
    string memory expectedSymbol = "DOG";

    // act
    string memory actualName = basicNft.name();
    string memory actualSymbol = basicNft.symbol();

    // assert
    assert(keccak256(bytes(expectedName)) == keccak256(bytes(actualName)));
    assert(keccak256(bytes(expectedSymbol)) == keccak256(bytes(actualSymbol)));
  }

  function testMintNftSuccess() public {
    // arrange
    vm.prank(user);

    // act
    basicNft.mintNft(PUG);

    // assert
    assert(basicNft.balanceOf(user) == 1);
    assert(keccak256(abi.encodePacked(PUG)) == keccak256(abi.encodePacked(basicNft.tokenURI(0))));
  }
}
