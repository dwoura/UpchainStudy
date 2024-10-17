// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract MyERC721 is ERC721URIStorage {
    uint private _tokenIds;

    constructor() ERC721(unicode"Wensili", "Dwoura") {}

    function mint(address student, string memory tokenURI) public returns (uint256) {
        _tokenIds+=1;

        uint256 newItemId = _tokenIds;
        _mint(student, newItemId);
        _setTokenURI(newItemId, tokenURI);

        return newItemId;
    }
}