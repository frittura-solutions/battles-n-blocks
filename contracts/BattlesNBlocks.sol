pragma solidity ^0.5.0;


import "./Ownable.sol";
import "./HitchensUnorderedAddressSet.sol";
import { Util } from "./Util.sol";

contract BattlesNBlocks is Ownable {
  address public owner;
  using HitchensUnorderedAddressSetLib for HitchensUnorderedAddressSetLib.Set;
  using Util for *;
  HitchensUnorderedAddressSetLib.Set heroSet;

  struct Hero {
    string name;
    uint position;
    uint strength;
    uint dexterity;
    mapping (uint => Item) inventory;
  }

  struct Item {
    string name;
    uint id;
    address owner;
  }

  mapping(address => Hero) public heroes;
    
  event LogNewHero(address sender, string name, uint position, uint strength, uint dexterity);
  event LogUpdateHero(address sender, string name,  uint position);    
  event LogRemHero(address key);
  

  constructor() public {
    owner = msg.sender;
  }
  
  
    
  function newHero(string memory name, uint strength, uint dexterity) public payable { 
      require(msg.value/1e18 >= (strength + dexterity), "Insufficient msg value for the chosen characteristics.");
      heroSet.insert(msg.sender); // Note that this will fail automatically if the key already exists.
      Hero storage h = heroes[msg.sender];
      h.name = name;
      h.position = block.number;
      uint str = 7 + Util.min(8, strength);
      uint dex = 7 + Util.min(8, dexterity);
      h.strength = str;
      h.dexterity = dex;
      emit LogNewHero(msg.sender, h.name, h.position, h.strength, h.dexterity);
  }
  
  function updateHero(string memory name) public {
      require(heroSet.exists(msg.sender), "Can't update a Hero that doesn't exist.");
      Hero storage h = heroes[msg.sender];
      h.name = name;
      h.position = block.number;
      emit LogUpdateHero(msg.sender, h.name, h.position);
  }
  
  function remHero(address key) public onlyOwner {
      heroSet.remove(key); // Note that this will fail automatically if the key doesn't exist
      delete heroes[key];
      emit LogRemHero(key);
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
