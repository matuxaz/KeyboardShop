// SPDX-License-Identifier: MIF
pragma solidity 0.8.10;

contract Adoption {
address[16] public adopters;

// Adopting a pet
function adopt(uint itemId) public returns (uint) {

  adopters[itemId] = msg.sender;

  return itemId;
}

// Retrieving the adopters
function getAdopters() public view returns (address[16] memory) {
  return adopters;
}

}