// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract MyNFT is ERC721, Ownable {
    uint256 private s_tokenCounter;
    mapping(uint256 => string) private s_tokenIdToUri;
    
    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) Ownable(msg.sender){
        s_tokenCounter = 0;
    }

    function mintNft(string memory _tokenUri, address _owner) external onlyOwner{
        s_tokenIdToUri[s_tokenCounter] = _tokenUri;
        _safeMint(_owner, s_tokenCounter);
        s_tokenCounter++;
    }

    function tokenURI(
        uint256 _tokenId
    ) public view override returns (string memory) {
        return s_tokenIdToUri[_tokenId];
    }
}