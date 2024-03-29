// contracts/GameItem.sol
// SPDX-License-Identifier: MIT

/**
* Smart contract for DerbyVerse.
╭━━━╮╱╱╱╱╭╮╱╱╱╱╱╭╮╱╱╭╮
╰╮╭╮┃╱╱╱╱┃┃╱╱╱╱╱┃╰╮╭╯┃
╱┃┃┃┣━━┳━┫╰━┳╮╱╭╋╮┃┃╭╋━━┳━┳━━┳━━╮
╱┃┃┃┃┃━┫╭┫╭╮┃┃╱┃┃┃╰╯┃┃┃━┫╭┫━━┫┃━┫
╭╯╰╯┃┃━┫┃┃╰╯┃╰━╯┃╰╮╭╯┃┃━┫┃┣━━┃┃━┫
╰━━━┻━━┻╯╰━━┻━╮╭╯╱╰╯╱╰━━┻╯╰━━┻━━╯
╱╱╱╱╱╱╱╱╱╱╱╱╭━╯┃
╱╱╱╱╱╱╱╱╱╱╱╱╰━━╯
*/

pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract DerbyVerse is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) {}

    function mint(string memory tokenURI)
        public
        returns (uint256)
    {
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _mint(msg.sender, newItemId);
        _setTokenURI(newItemId, tokenURI);

        return newItemId;
    }
}