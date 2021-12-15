// SPDX-License-Identifier: MIF
pragma solidity 0.8.10;

contract Adoption {

  struct Item{
    string name;
    string picture;
    string keycaps;
    string ffactor;
    string switches;
  }
uint public keyboardCount = 0;
uint public keyboardId = 0;
uint[] public arrayForItems;
address[16] public adopters;

mapping(uint => Item) public keyboards;
mapping(uint => address) public owners;

constructor(){
  add("ID80","images/ID80.png","Laser","75%","BOBA U4T");
  add("The Classic","images/Classic.png","Botanical","65%","Cherry MX Brown");
  add("Candy Bar","images/CandyBar.png","VileBloom","50%","BOBA Gum");
  add("Halo","images/CandyBar.png","Halo","96%","Gateron Yellow");
}

function add(string memory name, string memory picture, string memory keycaps, string memory ffactor, string memory switches) private{
  keyboards[keyboardId] = Item(name, picture, keycaps, ffactor, switches);
  owners[keyboardId] = address(0);
  keyboardId++;
  keyboardCount++;
}

// Adopting a pet
function adopt(uint petId) public returns (uint) {
  require(petId >= 0 && petId <= keyboardCount);

  adopters[petId] = msg.sender;

  return petId;
}

// Retrieving the adopters
function getAdopters() public view returns (address[16] memory) {
  return adopters;
}

}