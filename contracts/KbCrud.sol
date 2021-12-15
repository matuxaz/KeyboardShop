// SPDX-License-Identifier: MIF
pragma solidity 0.8.10;

contract KbCrud{

struct keyboard{
    string name;
    string picture;
    string keycaps;
    string ffactor;
    string switches;
}
uint public totalKeyboards = 3;
uint public itemId = 0;

uint[3] public keyboardArray;

//hash tables for keyboards and ownership
mapping(uint => keyboard) public keyboards;
mapping(uint => address) public owners;

constructor() public{
    insert("ID80", "images/ID80.png", "laser", "75%", "BOBA U4t");
    insert("The Classic", "images/Classic.png", "Botanical", "65%", "Cherry MX Brown");
    insert("Candy Bar", "images/CandyBar.png", "VileBloom", "50%", "BOBA Gum");
}

event NewKeyboard(string name, string picture, string keycaps, string ffactor, string switches);

event SpecsUpdated(string name, string picture, string keycaps, string ffactor, string switches);

event KeyboardDelete(string name);

event KeyboardBuy(string name);

function insert(string memory name, string memory picture, string memory keycaps, string memory ffactor, string memory switches) public {
    keyboards[itemId] = keyboard(name, picture, keycaps, ffactor, switches);
    owners[itemId] = address(0);
    itemId++;
    //emit event
    emit NewKeyboard(name, picture, keycaps, ffactor, switches);
}

function update(uint id, string memory newName, string memory newPicture, string memory newKeycaps, string memory newFfactor, string memory newSwitches) public{
            keyboards[id].name = newName;
            keyboards[id].picture = newPicture;
            keyboards[id].keycaps = newKeycaps;
            keyboards[id].ffactor = newFfactor;
            keyboards[id].switches = newSwitches;
            emit SpecsUpdated(newName, newPicture, newKeycaps, newFfactor, newSwitches);
}
function deleteKeyboard(uint id) public{
            keyboards[id] = keyboards[totalKeyboards-1]; //pushing last keyboard into current array and deleting it
            delete keyboards[totalKeyboards-1];
            totalKeyboards--;
            emit KeyboardDelete(keyboards[id].name);
    }
function getKeyboard(uint id) public view returns(string memory name, string memory picture, string memory keycaps, string  memory ffactor, string memory switches){
    require(id >= 0 && id < totalKeyboards, "Item does not exist");
    return (keyboards[id].name, keyboards[id].picture, keyboards[id].keycaps, keyboards[id].ffactor, keyboards[id].switches);
}

    function getName (uint _itemId) public view returns (string memory) {
		require(_itemId >= 0 && _itemId < totalKeyboards, "Item does not exist");

		return keyboards[_itemId].name;
	}
    function getPicture (uint _itemId) public view returns (string memory) {
		require(_itemId >= 0 && _itemId < totalKeyboards, "Item does not exist");

		return keyboards[_itemId].picture;
	}
    function getKeycaps (uint _itemId) public view returns (string memory) {
		require(_itemId >= 0 && _itemId < totalKeyboards, "Item does not exist");

		return keyboards[_itemId].keycaps;
	}
    function getFfactor (uint _itemId) public view returns (string memory) {
		require(_itemId >= 0 && _itemId < totalKeyboards, "Item does not exist");
		return keyboards[_itemId].ffactor;
	}
    function getSwitches (uint _itemId) public view returns (string memory) {
		require(_itemId >= 0 && _itemId < totalKeyboards, "Item does not exist");

		return keyboards[_itemId].switches;
	}

function buyKeyboard(uint _itemId) public returns (uint){
    require(_itemId >= 0 && _itemId < totalKeyboards, "buying non-existant item");
    require(checkOwner(_itemId, msg.sender), "Trying to buy already owned item");
    owners[_itemId] = msg.sender;

    emit KeyboardBuy(keyboards[_itemId].name);

    return _itemId;
}

function checkOwner (uint _itemId, address person_wallet) public view returns (bool) {
		if (person_wallet == owners[_itemId]) {
			return false;
		} else {
			return true;
		}
	}

}