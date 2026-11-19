// SPDX-License-Identifier: MIT
pragma solidity ^0.8.38;

import { Test, console } from "lib/forge-std/src/Test.sol";
import { Deploy_SVG_NFT } from "../../script/deploy-nft.s.sol";
import { SVG_NFT } from "../../src/svg-nft.sol";
import { Base64 } from "@openzeppelin/contracts/utils/Base64.sol";
import { Strings } from "@openzeppelin/contracts/utils/Strings.sol";

contract SVG_NFT_Test is Test {
  SVG_NFT public svgNft;
  address public user = makeAddr("user");

  // string public constant EXPECTED_TOKEN_URI_1 =
  //   "data:application/json;base64,eyJuYW1lIjoiU1ZHIE5GVCAjMSIsImRlc2NyaXB0aW9uIjoiQW4gb24tY2hhaW4gU1ZHIE5GVCIsImltYWdlIjoiZGF0YTppbWFnZS9zdmcreG1sO2Jhc2U2NCxQSE4yWnlCM2FXUjBhRDBpTVRBeU5IQjRJaUJvWldsbmFIUTlJakV3TWpSd2VDSWdkbWxsZDBKdmVEMGlNQ0F3SURFd01qUWdNVEF5TkNJZ2VHMXNibk05SW1oMGRIQTZMeTkzZDNjdWR6TXViM0puTHpJd01EQXZjM1puSWo0OGNHRjBhQ0JtYVd4c1BTSWpNek16SWlCa1BTSk5OVEV5SURZMFF6STJOQzQySURZMElEWTBJREkyTkM0MklEWTBJRFV4TW5NeU1EQXVOaUEwTkRnZ05EUTRJRFEwT0NBME5EZ3RNakF3TGpZZ05EUTRMVFEwT0ZNM05Ua3VOQ0EyTkNBMU1USWdOalI2YlRBZ09ESXdZeTB5TURVdU5DQXdMVE0zTWkweE5qWXVOaTB6TnpJdE16Y3ljekUyTmk0MkxUTTNNaUF6TnpJdE16Y3lJRE0zTWlBeE5qWXVOaUF6TnpJZ016Y3lMVEUyTmk0MklETTNNaTB6TnpJZ016Y3llaUl2UGp4d1lYUm9JR1pwYkd3OUlpTkZOa1UyUlRZaUlHUTlJazAxTVRJZ01UUXdZeTB5TURVdU5DQXdMVE0zTWlBeE5qWXVOaTB6TnpJZ016Y3ljekUyTmk0MklETTNNaUF6TnpJZ016Y3lJRE0zTWkweE5qWXVOaUF6TnpJdE16Y3lMVEUyTmk0MkxUTTNNaTB6TnpJdE16Y3llazB5T0RnZ05ESXhZVFE0TGpBeElEUTRMakF4SURBZ01DQXhJRGsySURBZ05EZ3VNREVnTkRndU1ERWdNQ0F3SURFdE9UWWdNSHB0TXpjMklESTNNbWd0TkRndU1XTXROQzR5SURBdE55NDRMVE11TWkwNExqRXROeTQwUXpZd05DQTJNell1TVNBMU5qSXVOU0ExT1RjZ05URXlJRFU1TjNNdE9USXVNU0F6T1M0eExUazFMamdnT0RndU5tTXRMak1nTkM0eUxUTXVPU0EzTGpRdE9DNHhJRGN1TkVnek5qQmhPQ0E0SURBZ01DQXhMVGd0T0M0MFl6UXVOQzA0TkM0eklEYzBMalV0TVRVeExqWWdNVFl3TFRFMU1TNDJjekUxTlM0MklEWTNMak1nTVRZd0lERTFNUzQyWVRnZ09DQXdJREFnTVMwNElEZ3VOSHB0TWpRdE1qSTBZVFE0TGpBeElEUTRMakF4SURBZ01DQXhJREF0T1RZZ05EZ3VNREVnTkRndU1ERWdNQ0F3SURFZ01DQTVObm9pTHo0OGNHRjBhQ0JtYVd4c1BTSWpNek16SWlCa1BTSk5Namc0SURReU1XRTBPQ0EwT0NBd0lERWdNQ0E1TmlBd0lEUTRJRFE0SURBZ01TQXdMVGsySURCNmJUSXlOQ0F4TVRKakxUZzFMalVnTUMweE5UVXVOaUEyTnk0ekxURTJNQ0F4TlRFdU5tRTRJRGdnTUNBd0lEQWdPQ0E0TGpSb05EZ3VNV00wTGpJZ01DQTNMamd0TXk0eUlEZ3VNUzAzTGpRZ015NDNMVFE1TGpVZ05EVXVNeTA0T0M0MklEazFMamd0T0RndU5uTTVNaUF6T1M0eElEazFMamdnT0RndU5tTXVNeUEwTGpJZ015NDVJRGN1TkNBNExqRWdOeTQwU0RZMk5HRTRJRGdnTUNBd0lEQWdPQzA0TGpSRE5qWTNMallnTmpBd0xqTWdOVGszTGpVZ05UTXpJRFV4TWlBMU16TjZiVEV5T0MweE1USmhORGdnTkRnZ01DQXhJREFnT1RZZ01DQTBPQ0EwT0NBd0lERWdNQzA1TmlBd2VpSXZQand2YzNablBnPT0iLCJhdHRyaWJ1dGVzIjpbXX0=";

  function setUp() public {
    Deploy_SVG_NFT deployer = new Deploy_SVG_NFT();
    svgNft = deployer.run();
  }

  function testNameAndSymbolAreSet() public view {
    // arrange
    string memory expectedName = "MIZZY NFT";
    string memory expectedSymbol = "MIZZY";

    // act
    string memory actualName = svgNft.name();
    string memory actualSymbol = svgNft.symbol();

    // assert
    assert(keccak256(bytes(expectedName)) == keccak256(bytes(actualName)));
    assert(keccak256(bytes(expectedSymbol)) == keccak256(bytes(actualSymbol)));
  }

  function testMintNftSuccess() public {
    // arrange
    vm.prank(user);

    // act
    svgNft.mint('yellow');
    // string memory result = svgNft.tokenURI(1);

    // assert
    assert(svgNft.balanceOf(user) == 1);
    assert(svgNft.ownerOf(1) == user);
    // assert(keccak256(bytes(result)) == keccak256(bytes(EXPECTED_TOKEN_URI_1)));
  }

  // function testGetLatestTokenIdInitial() public {
  //   // arrange
  //   uint256 expectedInitialId = 1;

  //   // act
  //   // svgNft.mintNft('brown');
  //   uint256 actualInitialId = svgNft.getLatestTokenId();

  //   // assert
  //   assertEq(actualInitialId, expectedInitialId);
  // }

  //////////////////////////////////////////////
  // helper functions
  //////////////////////////////////////////////

  // function _getExpectedTokenUri(uint256 tokenId) internal pure returns (string memory) {
  //   string memory base64SVG = Base64.encode(bytes(SVG_IMAGE));

  //   bytes memory metadata = abi.encodePacked(
  //     '{"name":"SVG NFT #', Strings.toString(tokenId), '",',
  //     '"description":"An on-chain SVG NFT",',
  //     '"image":"data:image/svg+xml;base64,', base64SVG, '",'
  //     '"attributes":[]}'
  //   );

  //   return string(abi.encodePacked(
  //     "data:application/json;base64,",
  //     Base64.encode(metadata)
  //   ));
  // }
}
