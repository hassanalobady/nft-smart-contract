// contracts/GameItem.sol
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;
import "@openzeppelin/contracts@4.4.2/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts@4.4.2/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import"@openzeppelin/contracts/security/ReentrancyGuard.sol";

  contract Arenaplanet is ERC1155, Ownable, ReentrancyGuard{
    constructor() ERC1155("ipfs://Qmc9o86M3sH1xKP2tFKoNNguK9pAWKaCbsV5nry6EiJs6r/metadata.json") {}
    uint256 public mintRate = 0.02 ether;
    uint256 public publicamount =2;
    uint256 public OGamount=2;
    mapping(address => bool) public whitelist;
    mapping(address => bool) public OGlist;
    event AddedToWhitelist(address indexed account);
    event RemovedFromWhitelist(address indexed account);
    event AddedToOG(address indexed account);
    event RemovedFromOG(address indexed account);
    address[] public addresses;

    uint256 public id = 1;
    uint256[] public minted = [0];
    uint256[] public supplies = [2000];
    mapping(address => bool) public whitelistClaimed;
    mapping(address => uint256) public mintedPublictokens;
    mapping(address => uint256) public mintedOGtokens;
  
    bool public whitelistMintEnabled = false;
    bool public ogMintEnabled = false;
    bool public publicMintEnabled = false;
    
  function setURI(string memory newuri) public onlyOwner {
    _setURI(newuri);
  }
  function publicmint(uint256 _amount)
    payable
    public
  { 
    mintedPublictokens[msg.sender] = mintedPublictokens[msg.sender] + _amount;
    require(publicMintEnabled, "The public sale is not enabled!");
    require(id <= supplies.length, "Token doesn't exist");
    require(id > 0, "Token doesn't exist");
    require(minted[id-1] + _amount <= supplies[id -1], "not enought supply left");
    require(mintedPublictokens[msg.sender]<= publicamount, "You already own 2 tokens, you cannot have one more");
    require(msg.value >= mintRate * _amount , "Not enough ETH sent; check price!");
    _mint(msg.sender, id, _amount, "");
  }
  function ownermint(uint256 _amount)
    payable
    public
    onlyOwner
  { 

    require(id <= supplies.length, "Token doesn't exist");
    require(id > 0, "Token doesn't exist");
    require(supplies[0] - _amount > 0, "not enought supply left");
    supplies[0] = supplies[0] - _amount;
    _mint(msg.sender, id, _amount, "");
  }
  function whitelistMint() public payable {
    // Verify whitelist requirements
    require(whitelistMintEnabled, "The whitelist sale is not enabled!");
    require(supplies[0] - 1 > 0, "not enought supply left");
    supplies[0] = supplies[0] - 1;
    require(whitelist[msg.sender] == true, "You are not added to whitelist.");
    require(!whitelistClaimed[msg.sender], "whitelist Address already claimed!");
    require(msg.value >= mintRate * 1 , "Not enough ETH sent; check price!");

    whitelistClaimed[msg.sender] = true;
    _mint(msg.sender, id, 1, "");
  }

  function OGMint(uint256 _amount) public payable {
    // Verify whitelist requirements
    mintedOGtokens[msg.sender] = mintedOGtokens[msg.sender] + _amount;
    require(ogMintEnabled, "The OG sale is not enabled!");
    require(supplies[0] - 1 > 0, "not enought supply left");
    supplies[0] = supplies[0] - 1;
    require(OGlist[msg.sender] == true, "You are not included in OG list.");
    require(mintedOGtokens[msg.sender]<= OGamount, "You already own 2 tokens, you cannot have one more");
    require(msg.value >= mintRate * 1 , "Not enough ETH sent; check price!");

    _mint(msg.sender, id, _amount, "");
  }
   function setWhitelistMintEnabled() public onlyOwner {
    whitelistMintEnabled = true;
  }

  function setOGMintEnabled() public onlyOwner {
    ogMintEnabled = true;
  }

  function setPublicMintEnabled() public onlyOwner {
    publicMintEnabled = true;
  }
  function setmintRate(uint256 _mintRate) public onlyOwner {
    mintRate = _mintRate;
  }

  function setOGamount(uint256 _OGamount) public onlyOwner {
    OGamount = _OGamount;
  }

  function setPublicamount(uint256 _publicamount) public onlyOwner {
    publicamount = _publicamount;
  }

    function addWhiteList(address[] memory _addresses) public onlyOwner {
        for (uint256 i = 0; i < _addresses.length; i++) {
          whitelist[_addresses[i]] = true;
          emit AddedToWhitelist(_addresses[i]);
        }
    }

    function removewhitelist(address[] memory _addresses) public onlyOwner {
      for (uint256 i = 0; i < _addresses.length; i++) {
          whitelist[_addresses[i]] = false;
          emit RemovedFromWhitelist(_addresses[i]);
      }
    }

    function isWhitelisted(address _address) public view returns(bool) {
        return whitelist[_address];
    }

    function addOG(address[] memory _addresses) public onlyOwner {
      for (uint256 i = 0; i < _addresses.length; i++) {
          OGlist[_addresses[i]] = true;
          emit AddedToOG(_addresses[i]);
      }
    }

    function removeOG(address[] memory _addresses) public onlyOwner {
      for (uint256 i = 0; i < _addresses.length; i++) {
          OGlist[_addresses[i]] = false;
          emit RemovedFromOG(_addresses[i]);
      }
    }

    function isOG(address _address) public view returns(bool) {
        return OGlist[_address];
    }

    function withdraw() public onlyOwner nonReentrant {

    // =============================================================================
    (bool os, ) = payable(owner()).call{value: address(this).balance}("");
    require(os);
    // =============================================================================
  }

}