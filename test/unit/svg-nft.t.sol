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

  string private constant SVG_IMAGE =
    '<svg width="1024px" height="1024px" viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">'
    '<path fill="#333" d="M512 64C264.6 64 64 264.6 64 512s200.6 448 448 448 448-200.6 448-448S759.4 64 512 64zm0 820c-205.4 0-372-166.6-372-372s166.6-372 372-372 372 166.6 372 372-166.6 372-372 372z"/>'
    '<path fill="#E6E6E6" d="M512 140c-205.4 0-372 166.6-372 372s166.6 372 372 372 372-166.6 372-372-166.6-372-372-372zM288 421a48.01 48.01 0 0 1 96 0 48.01 48.01 0 0 1-96 0zm376 272h-48.1c-4.2 0-7.8-3.2-8.1-7.4C604 636.1 562.5 597 512 597s-92.1 39.1-95.8 88.6c-.3 4.2-3.9 7.4-8.1 7.4H360a8 8 0 0 1-8-8.4c4.4-84.3 74.5-151.6 160-151.6s155.6 67.3 160 151.6a8 8 0 0 1-8 8.4zm24-224a48.01 48.01 0 0 1 0-96 48.01 48.01 0 0 1 0 96z"/>'
    '<path fill="#333" d="M288 421a48 48 0 1 0 96 0 48 48 0 1 0-96 0zm224 112c-85.5 0-155.6 67.3-160 151.6a8 8 0 0 0 8 8.4h48.1c4.2 0 7.8-3.2 8.1-7.4 3.7-49.5 45.3-88.6 95.8-88.6s92 39.1 95.8 88.6c.3 4.2 3.9 7.4 8.1 7.4H664a8 8 0 0 0 8-8.4C667.6 600.3 597.5 533 512 533zm128-112a48 48 0 1 0 96 0 48 48 0 1 0-96 0z"/>'
    '</svg>';

  string public constant EXPECTED_TOKEN_URI_1 =
    "data:application/json;base64,eyJuYW1lIjoiU1ZHIE5GVCAjMSIsImRlc2NyaXB0aW9uIjoiQW4gb24tY2hhaW4gU1ZHIE5GVCIsImltYWdlIjoiZGF0YTppbWFnZS9zdmcreG1sO2Jhc2U2NCxQSE4yWnlCM2FXUjBhRDBpTVRBeU5IQjRJaUJvWldsbmFIUTlJakV3TWpSd2VDSWdkbWxsZDBKdmVEMGlNQ0F3SURFd01qUWdNVEF5TkNJZ2VHMXNibk05SW1oMGRIQTZMeTkzZDNjdWR6TXViM0puTHpJd01EQXZjM1puSWo0OGNHRjBhQ0JtYVd4c1BTSWpNek16SWlCa1BTSk5OVEV5SURZMFF6STJOQzQySURZMElEWTBJREkyTkM0MklEWTBJRFV4TW5NeU1EQXVOaUEwTkRnZ05EUTRJRFEwT0NBME5EZ3RNakF3TGpZZ05EUTRMVFEwT0ZNM05Ua3VOQ0EyTkNBMU1USWdOalI2YlRBZ09ESXdZeTB5TURVdU5DQXdMVE0zTWkweE5qWXVOaTB6TnpJdE16Y3ljekUyTmk0MkxUTTNNaUF6TnpJdE16Y3lJRE0zTWlBeE5qWXVOaUF6TnpJZ016Y3lMVEUyTmk0MklETTNNaTB6TnpJZ016Y3llaUl2UGp4d1lYUm9JR1pwYkd3OUlpTkZOa1UyUlRZaUlHUTlJazAxTVRJZ01UUXdZeTB5TURVdU5DQXdMVE0zTWlBeE5qWXVOaTB6TnpJZ016Y3ljekUyTmk0MklETTNNaUF6TnpJZ016Y3lJRE0zTWkweE5qWXVOaUF6TnpJdE16Y3lMVEUyTmk0MkxUTTNNaTB6TnpJdE16Y3llazB5T0RnZ05ESXhZVFE0TGpBeElEUTRMakF4SURBZ01DQXhJRGsySURBZ05EZ3VNREVnTkRndU1ERWdNQ0F3SURFdE9UWWdNSHB0TXpjMklESTNNbWd0TkRndU1XTXROQzR5SURBdE55NDRMVE11TWkwNExqRXROeTQwUXpZd05DQTJNell1TVNBMU5qSXVOU0ExT1RjZ05URXlJRFU1TjNNdE9USXVNU0F6T1M0eExUazFMamdnT0RndU5tTXRMak1nTkM0eUxUTXVPU0EzTGpRdE9DNHhJRGN1TkVnek5qQmhPQ0E0SURBZ01DQXhMVGd0T0M0MFl6UXVOQzA0TkM0eklEYzBMalV0TVRVeExqWWdNVFl3TFRFMU1TNDJjekUxTlM0MklEWTNMak1nTVRZd0lERTFNUzQyWVRnZ09DQXdJREFnTVMwNElEZ3VOSHB0TWpRdE1qSTBZVFE0TGpBeElEUTRMakF4SURBZ01DQXhJREF0T1RZZ05EZ3VNREVnTkRndU1ERWdNQ0F3SURFZ01DQTVObm9pTHo0OGNHRjBhQ0JtYVd4c1BTSWpNek16SWlCa1BTSk5Namc0SURReU1XRTBPQ0EwT0NBd0lERWdNQ0E1TmlBd0lEUTRJRFE0SURBZ01TQXdMVGsySURCNmJUSXlOQ0F4TVRKakxUZzFMalVnTUMweE5UVXVOaUEyTnk0ekxURTJNQ0F4TlRFdU5tRTRJRGdnTUNBd0lEQWdPQ0E0TGpSb05EZ3VNV00wTGpJZ01DQTNMamd0TXk0eUlEZ3VNUzAzTGpRZ015NDNMVFE1TGpVZ05EVXVNeTA0T0M0MklEazFMamd0T0RndU5uTTVNaUF6T1M0eElEazFMamdnT0RndU5tTXVNeUEwTGpJZ015NDVJRGN1TkNBNExqRWdOeTQwU0RZMk5HRTRJRGdnTUNBd0lEQWdPQzA0TGpSRE5qWTNMallnTmpBd0xqTWdOVGszTGpVZ05UTXpJRFV4TWlBMU16TjZiVEV5T0MweE1USmhORGdnTkRnZ01DQXhJREFnT1RZZ01DQTBPQ0EwT0NBd0lERWdNQzA1TmlBd2VpSXZQand2YzNablBnPT0iLCJhdHRyaWJ1dGVzIjpbXX0=";

  function setUp() public {
    Deploy_SVG_NFT deployer = new Deploy_SVG_NFT();
    svgNft = deployer.run();
  }

  function testNameAndSymbolAreSet() public view {
    // arrange
    string memory expectedName = "SVG NFT";
    string memory expectedSymbol = "SVGNFT";

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
    svgNft.mintNft();
    string memory result = svgNft.tokenURI(1);

    // assert
    assert(svgNft.balanceOf(user) == 1);
    assert(svgNft.ownerOf(1) == user);
    assert(keccak256(bytes(result)) == keccak256(bytes(EXPECTED_TOKEN_URI_1)));
  }

  // function testTokenURIReturnsExpectedExactString() public {
  //   // arrange
  //   vm.prank(user);
  //   svgNft.mintNft();

  //   // act
  //   string memory actualUri = svgNft.tokenURI(1);

  //   // assert
  //   assertEq(actualUri, EXPECTED_TOKEN_URI_1);
  //   assert(keccak256(bytes(actualUri)) == keccak256(bytes(EXPECTED_TOKEN_URI_1)));
  // }

  // function testTokenURIStartsWithDataUriPrefix() public {
  //   // arrange
  //   vm.prank(user);
  //   svgNft.mintNft();

  //   // act
  //   string memory actualUri = svgNft.tokenURI(1);
  //   string memory expectedPrefix = "data:application/json;base64,";

  //   // assert
  //   bytes memory actualBytes = bytes(actualUri);
  //   bytes memory prefixBytes = bytes(expectedPrefix);
  //   assertTrue(actualBytes.length >= prefixBytes.length);

  //   for (uint256 i = 0; i < prefixBytes.length; i++) {
  //     assertEq(actualBytes[i], prefixBytes[i]);
  //   }
  // }

  // function testTokenURIDynamicMatchesComputedMetadata() public {
  //   // arrange
  //   vm.prank(user);
  //   svgNft.mintNft();

  //   // act
  //   string memory actualUri = svgNft.tokenURI(1);
  //   string memory expectedUri = _getExpectedTokenUri(1);

  //   // assert
  //   assertEq(actualUri, expectedUri);
  // }

  // function testTokenURIChangesWithTokenId() public {
  //   // arrange
  //   address user2 = makeAddr("user2");

  //   vm.prank(user);
  //   svgNft.mintNft(); // tokenId 1

  //   vm.prank(user2);
  //   svgNft.mintNft(); // tokenId 2

  //   // act
  //   string memory uriToken1 = svgNft.tokenURI(1);
  //   string memory uriToken2 = svgNft.tokenURI(2);

  //   // assert
  //   assertTrue(keccak256(bytes(uriToken1)) != keccak256(bytes(uriToken2)));
  //   assertEq(uriToken1, _getExpectedTokenUri(1));
  //   assertEq(uriToken2, _getExpectedTokenUri(2));
  // }

  function testGetNextTokenIdInitial() public view {
    // arrange
    uint256 expectedInitialId = 1;

    // act
    uint256 actualInitialId = svgNft.getNextTokenId();

    // assert
    assertEq(actualInitialId, expectedInitialId);
  }

  //////////////////////////////////////////////
  // helper functions
  //////////////////////////////////////////////

  function _getExpectedTokenUri(uint256 tokenId) internal pure returns (string memory) {
    string memory base64SVG = Base64.encode(bytes(SVG_IMAGE));

    bytes memory metadata = abi.encodePacked(
      '{"name":"SVG NFT #', Strings.toString(tokenId), '",',
      '"description":"An on-chain SVG NFT",',
      '"image":"data:image/svg+xml;base64,', base64SVG, '",'
      '"attributes":[]}'
    );

    return string(abi.encodePacked(
      "data:application/json;base64,",
      Base64.encode(metadata)
    ));
  }
}
