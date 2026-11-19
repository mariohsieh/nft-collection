// SPDX-License-Identifier: MIT
pragma solidity ^0.8.38;

// import { ERC721 } from "lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import { ERC721 } from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
// import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { Base64 } from "@openzeppelin/contracts/utils/Base64.sol";
import { Strings } from "@openzeppelin/contracts/utils/Strings.sol";

contract SVG_NFT is ERC721 {
  // track how many tokens have been issued
  uint256 private s_tokenId;

  // create mapping for token ID -> color
  mapping (uint256 => string) private s_tokenIdToColor;

  constructor() ERC721("MIZZY NFT", "MIZZY") {
    // initialize token to zero
    s_tokenId = 1;
  }

  // events
  // event Minted(address indexed minterAddress, uint256 indexed tokenId);

  // set error for an invalid/non-existent token
  // error InvalidTokenId(uint256);

  function mint(string memory color) public {
    // mint a new coin
    _safeMint(msg.sender, s_tokenId);

    // set mapping token ID -> color
    s_tokenIdToColor[s_tokenId] = color;

    // emit transaction
    // emit Minted(msg.sender, s_tokenId);

    // increment counter for the next token minting
    s_tokenId++;
  }

  function tokenURI(uint256 tokenId) public view override returns (string memory) {
    // owner check
    _requireOwned(tokenId);
    // if (ownerOf(tokenId) == address(0)) {
    //   revert InvalidTokenId(tokenId);
    // }

    // encode SVG image in base64
    string memory svgImage = Base64.encode(bytes(_generateSVG(s_tokenIdToColor[tokenId])));

    // encode metadata
    string memory metadata = Base64.encode(bytes(string(abi.encodePacked(
      '{',
      '"name":"Mizzy NFT #', Strings.toString(tokenId), '",',
      '"description":"An on-chain dynamic SVG NFT",',
      '"image":"data:image/svg+xml;base64,', svgImage, '",',
      '"attributes":[{"trait_type": "color","value":"',s_tokenIdToColor[tokenId],'"}]',
      '}'
    ))));

    // return full token URI
    return string(
      abi.encodePacked("data:application/json;base64,",
      metadata
    ));
  }

  //////////////////////////////////////////////
  // getter functions
  //////////////////////////////////////////////

  // function getLatestTokenId() external view returns (uint256) {
  //   return s_tokenId;
  // }

  //////////////////////////////////////////////
  // helper functions
  //////////////////////////////////////////////

  function _generateSVG(string memory color) internal pure returns(string memory) {
    return string(abi.encodePacked(
      '<svg width="300" height="300" viewBox="0 0 300 300" xmlns="http://www.w3.org/2000/svg">',
      '<rect width="300" height="300" style="fill:', color, ';" />'
      '</svg>'
    ));
  }
}
