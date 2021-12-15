// SPDX-License-Identifier: MIF
pragma solidity 0.8.10;

contract KbCrud{

struct keyboard{
    uint id;
    string name;
    string picture;
    string keycaps;
    string ffactor;
    string switches;
}
uint constant totalKeyboards = 4;
uint public itemId = 0;

uint[totalKeyboards] public keyboardArray;

//hash tables for keyboards and ownership
mapping(uint => keyboard) public keyboards;
mapping(uint => address) public owners;

constructor(){
}

event NewKeyboard(uint id, string name, string picture, string keycaps, string ffactor, string switches);

event SpecsUpdated(uint id, string name, string picture, string keycaps, string ffactor, string switches);

event KeyboardDelete(uint id);

function update(uint idCheck, string memory newName, string memory newPicture, string memory newKeycaps, string memory newFfactor, string memory newSwitches) public returns (bool succsess){
    for(uint i = 0; i < totalKeyboards; i++){
        if(keyboards[i].id == idCheck){
            keyboards[i].name = newName;
            keyboards[i].picture = newPicture;
            keyboards[i].keycaps = newKeycaps;
            keyboards[i].ffactor = newFfactor;
            keyboards[i].switches = newSwitches;
            emit SpecsUpdated(idCheck, newName, newPicture, newKeycaps, newFfactor, newSwitches);
            return true;//succsess
        }
        return false;//fail
    }
}

function deleteKeyboard(uint idCheck) public returns (bool succsess){
    require(totalKeyboards > 0);
    for (uint i = 0; i < totalKeyboards; i++){
        if(keyboards[i].id == idCheck){
            keyboards[i] = keyboards[totalKeyboards-1]; //pushing last keyboard into current array and deleting it
            delete keyboards[totalKeyboards-1];
            totalKeyboards--;
            emit KeyboardDelete(idCheck);
            return true;
        }
        return false;//fail
    }
}
function getKeyboard(uint idCheck) public view returns(string memory name, string memory picture, string memory keycaps, string  memory ffactor, string memory switches){
    for (uint i = 0; i < totalKeyboards; i++){
        if(keyboards[i].id == idCheck){
            return (keyboards[i].name, keyboards[i].picture, keyboards[i].keycaps, keyboards[i].ffactor, keyboards[i].switches);
        }
    }
    revert('keyboard not found');
}

function getTotalKeyboards() public view returns (uint length){
    return keyboards.length;
}

function getKeyboardCount () public pure returns (uint) {
		return totalKeyboards;
	}

function getOwners() public view returns (address[totalKeyboards] memory) {
		address[totalKeyboards] memory arrayOfOwners;

		for (uint i=0;i < totalKeyboards; i++) {
			arrayOfOwners[i] = owners[i];
		}

		return arrayOfOwners;

	}

}