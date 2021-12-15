// SPDX-License-Identifier: MIF
pragma solidity 0.8.10;

contract Adoption {

  struct Item{
    uint id;
    string name;
    string picture;
    string keycaps;
    string ffactor;
    string switches;
    address owner;
  }

uint public keyboardCount = 0;
Item[] public keyboards;
uint public keyboardId = 0;

constructor(){
  add("ID80", "images/ID80.png", "Laser", "75%", "BOBA U4T");
  add("Candy Bar", "images/Classic.png", "Botanical", "65%", "Cherry MX Brown");
  add("ID80", "images/CandyBar.png", "VileBloom", "50%", "BOBA Gum");
  add("Halo", "images/CandyBar.png", "Halo", "96%", "Gateron Yellow");
}

function add(string memory name, string memory picture, string memory keycaps, string memory ffactor, string memory switches) public{
keyboards.push(Item(keyboardId, name, picture, keycaps, ffactor, switches, address(0)));
keyboardCount++;
keyboardId++;
}

function getName(uint id)public view returns(string memory){
  return keyboards[id].name;
}
function getPicture(uint id)public view returns(string memory){
  return keyboards[id].picture;
}
function getKeycaps(uint id)public view returns(string memory){
  return keyboards[id].keycaps;
}
function getFfactor(uint id)public view returns(string memory){
  return keyboards[id].ffactor;
}
function getSwitches(uint id)public view returns(string memory){
  return keyboards[id].switches;
}
function getOwner(uint id)public view returns(address){
  return keyboards[id].owner;
}

//checking if a person already owns the item
function checkBuyer(uint itemId, address wallet)public view returns (bool){
if(wallet == keyboards[itemId].owner){
  return false;
}else return true;
}

// buying a keyboard
function buy(uint kbId) public view returns (uint) {
  require(checkBuyer(kbId, msg.sender), "item already owned");
  require((kbId >= 0 && kbId < keyboardCount), "Invalid ID");
  for(uint i = 0; i < keyboardCount; i++){
    if(keyboards[i].id == kbId){
      keyboards[i].owner == msg.sender;
    }
  }
  return kbId;
}

// Retrieving the owners
function getOwners() public view returns (address[] memory) {
address[] memory arrayOfOwners;

  for (uint i=0; i < keyboardCount; i++) {
			arrayOfOwners[i] = keyboards[i].owner;
		}
  return arrayOfOwners;
}

}