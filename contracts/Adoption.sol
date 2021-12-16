// SPDX-License-Identifier: MIF
pragma solidity 0.8.10;

contract Adoption {

  struct Item{
    uint id;
    string name;
    string picture;
    string switches;
    uint price;
    address uploader;
    address owner;
  }
uint public keyboardId = 0;
Item[] public keyboards;

constructor(){
  add("ID80","images/ID80.png","BOBA U4T", 2);
  add("The Classic","images/Classic.png", "Cherry MX Brown", 3);
  add("Candy Bar","images/CandyBar.png", "BOBA Gum", 4);
  add("Halo","","Gateron Yellow", 5);
}

function add(string memory name, string memory picture, string memory switches, uint price) public{
  if(keccak256(bytes(picture)) == keccak256(bytes(""))){
    keyboards.push(Item(keyboardId, name, "images/notUploaded.png", switches, price, msg.sender, address(0)));
  }else{
    keyboards.push(Item(keyboardId, name, picture, switches, price, msg.sender, address(0)));
  }
  keyboardId++;
}

function get(uint id) public view returns (uint thisKeyboardId, string memory name, string memory picture, string memory switches, uint price, address uploader, address owner){
    for(uint i = 0; i < keyboards.length; i++){
      if(keyboards[i].id == id){
        return (keyboards[i].id, keyboards[i].name, keyboards[i].picture, keyboards[i].switches, keyboards[i].price, keyboards[i].uploader, keyboards[i].owner);
      }
    }
  }

// Buying a keyboard
function buy(uint id) public payable{
  require(keyboards[id].price * 1 ether <= msg.value);

  payable(keyboards[id].uploader).transfer(msg.value);
  for(uint i = 0; i < keyboards.length; i++){
      if (keyboards[i].id == id) {
        keyboards[i].owner = msg.sender;
        return;
      }
}
}

function getOwners() public view returns(address[] memory){
  address[] memory arrayOfOwners;

  for(uint i = 0; i < keyboards.length; i++){
    arrayOfOwners[i] = keyboards[i].owner;
  } 
  return(arrayOfOwners);
}

function getKeyboardsAmount() public view returns (uint256 length){
  return keyboards.length;
}

}