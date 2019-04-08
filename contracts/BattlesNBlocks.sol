pragma solidity ^0.5.0;


import "./Ownable.sol";
import "./HitchensUnorderedAddressSetLib.sol";
import "./Util.sol";

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
    uint resistance;
    uint magic;
    uint HP;
    uint value;
    uint exp;
    mapping (uint => Item) inventory;
    HitchensUnorderedAddressSetLib.Set abilities;
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
  event LogAttack(address attacker, address target, uint damage);
  

  constructor() public {
    owner = msg.sender;
  }
  
  
    
  function newHero(string memory name, uint strength, uint dexterity,  uint resistance, uint magic) public payable { 
      require(msg.value/1e18 >= (strength + dexterity + resistance + magic), "Insufficient msg value for the chosen characteristics.");
      heroSet.insert(msg.sender); // Note that this will fail automatically if the key already exists.
      Hero storage h = heroes[msg.sender];
      h.name = name;
      h.position = block.number;
      uint str = 7 + Util.min(8, strength);
      uint dex = 7 + Util.min(8, dexterity);
      uint res = 7 + Util.min(8, resistance);
      uint mag = 7 + Util.min(8, magic);
      h.strength = str;
      h.dexterity = dex;
      h.resistance = res;
      h.magic = mag;
      h.value = msg.value;
      h.exp = 0;
      h.HP = 10;
      emit LogNewHero(msg.sender, h.name, h.position, h.strength, h.dexterity);
  }
  
  function updateHero(string memory name) public {
      require(heroSet.exists(msg.sender), "Can't update a Hero that doesn't exist.");
      Hero storage h = heroes[msg.sender];
      h.name = name;
      h.position = block.number;
      emit LogUpdateHero(msg.sender, h.name, h.position);
  }

  function _moveHero(address key, uint targetBlock) private {
      require(heroSet.exists(key), "Can't move a Hero that doesn't exist.");
      Hero storage h = heroes[key];
      h.position = targetBlock;
      emit LogUpdateHero(key, h.name, h.position);
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

  function attack(address target) public returns(bool res) {
      require(heroSet.exists(msg.sender), "Create a hero first");
      require(heroSet.exists(target), "Invalid target");
      Hero storage h = heroes[msg.sender];
      Hero storage t = heroes[target];
      uint dmg = h.strength <= t.resistance ? 1: h.strength - t.resistance;
      t.HP = dmg >= t.HP ? 0 : t.HP - dmg;
      emit LogAttack(msg.sender, target, dmg);
      return true;
  }

  
  
}
