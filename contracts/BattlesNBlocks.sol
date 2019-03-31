pragma solidity ^0.5.0;


import "./Ownable.sol";
import "./HitchensUnorderedAddressSet.sol";

contract BattlesNBlocks is Ownable {
  address public owner;
  using HitchensUnorderedAddressSetLib for HitchensUnorderedAddressSetLib.Set;
  HitchensUnorderedAddressSetLib.Set heroSet;

  struct Hero {
    string name;
    uint position;
    mapping (uint => Item) inventory;
  }

  struct Item {
    string name;
    uint id;
    address owner;
  }

  mapping(address => Hero) public heroes;
    
  event LogNewHero(address sender, address key, string name, uint position);
  event LogUpdateHero(address sender, address key, string name,  uint position);    
  event LogRemHero(address sender, address key);
  

  constructor() public {
    owner = msg.sender;
  }
    
  function newHero(address key, string memory name, uint position) public { 
      heroSet.insert(key); // Note that this will fail automatically if the key already exists.
      Hero storage h = heroes[key];
      h.name = name;
      h.position = position;
      emit LogNewHero(msg.sender, key, name, position);
  }
  
  function updateHero(address key, string memory name, uint position) public {
      require(heroSet.exists(key), "Can't update a Hero that doesn't exist.");
      Hero storage h = heroes[key];
      h.name = name;
      h.position = position;
      emit LogUpdateHero(msg.sender, key, name, position);
  }
  
  function remHero(address key) public onlyOwner {
      heroSet.remove(key); // Note that this will fail automatically if the key doesn't exist
      delete heroes[key];
      emit LogRemHero(msg.sender, key);
  }
  
  function getHero(address key) public view returns(string memory name, uint position) {
      require(heroSet.exists(key), "Can't get a Hero that doesn't exist.");
      Hero storage h = heroes[key];
      return(h.name, h.position);
  }
  
  function getHeroCount() public view returns(uint count) {
      return heroSet.count();
  }
  
  function getHeroAtIndex(uint index) public view returns(address key) {
      return heroSet.keyAtIndex(index);
  }
}

