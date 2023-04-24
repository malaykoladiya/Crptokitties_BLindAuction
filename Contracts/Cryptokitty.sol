pragma solidity ^0.8.0;

import "./ERC721.sol";

contract CryptoKitty is ERC721 {
  struct Kitty {
    uint256 genes;
    uint64 birthTime;
    uint32 kittyIndex;
  }

  Kitty[] kitties;

  mapping (uint256 => address) public kittyIndexToOwner;
  mapping (address => uint256) ownershipTokenCount;

  event KittyBirth(address owner, uint256 genes, uint256 kittyId);

  constructor() ERC721("CryptoKitty", "CK") {}

  function createKitty(uint256 _genes) public returns (uint256) {
    Kitty memory _kitty = Kitty({
      genes: _genes,
      birthTime: uint64(block.timestamp),
      kittyIndex: uint32(kitties.length)
    });

    kitties.push(_kitty);

    emit KittyBirth(msg.sender, _genes, _kitty.kittyIndex);

    _mint(msg.sender, _kitty.kittyIndex);

    return _kitty.kittyIndex;
  }

  function transferKitty(address _to, uint256 _tokenId) public {
    require(_to != address(0), "Cannot transfer to zero address");
    require(_to != address(this), "Cannot transfer to contract address");

    require(kittyIndexToOwner[_tokenId] == msg.sender, "Not the owner of the kitty");

    _transfer(msg.sender, _to, _tokenId);
  }

  function getKitty(uint256 _tokenId) public view returns (uint256 genes, uint64 birthTime, uint32 kittyIndex, address owner) {
    Kitty storage kitty = kitties[_tokenId];
    genes = kitty.genes;
    birthTime = kitty.birthTime;
    kittyIndex = kitty.kittyIndex;
    owner = kittyIndexToOwner[_tokenId];
  }
}
