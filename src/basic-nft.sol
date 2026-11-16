// SPDX-License-Identifier: MIT
pragma solidity ^0.8.38;

import { ERC721 } from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract BasicNft is ERC721 {
  // track how many tokens have been issued
  uint256 private s_tokenCounter;
  // create mapping for token ID -> token URI
  mapping(uint256 => string) private s_tokenIdToUri;

  constructor() ERC721("Doggy", "DOG") {
    // initialize counter to 0
    s_tokenCounter = 0;
  }

  function mintNft(string memory tokenUri) public {
    // set token ID to token URI from argument
    s_tokenIdToUri[s_tokenCounter] = tokenUri;
    // set token ID to user address
    _safeMint(msg.sender, s_tokenCounter);
    // increment counter for the next token minting
    s_tokenCounter++;
  }

  function tokenURI(uint256 tokenId) public view override returns (string memory) {
    return s_tokenIdToUri[tokenId];
  }
}
