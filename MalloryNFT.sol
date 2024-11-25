// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.24;

// Import the openzepplin contracts
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

// This is an ERC721 = import ERC721 and follows ERC721 contracr from openzeppelin
contract MalloryNFT is ERC721 {
    constructor() ERC721("MalloryNFT", "MNT") {
        // mint an NFT to yourself
        _mint(msg.sender, 1);
    }
}