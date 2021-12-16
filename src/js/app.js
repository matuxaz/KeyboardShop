App = {
  web3Provider: null,
  contracts: {},

  init: async function() {
    console.log("running init")
    return await App.initWeb3();
  },

  initWeb3: async function() {
    // Modern dapp browsers...
if (window.ethereum) {
  App.web3Provider = window.ethereum;
  try {
    // Request account access
    await window.ethereum.request({ method: "eth_requestAccounts" });;
  } catch (error) {
    // User denied account access...
    console.error("User denied account access")
  }
}
// Legacy dapp browsers...
else if (window.web3) {
  App.web3Provider = window.web3.currentProvider;
}
// If no injected web3 instance is detected, fall back to Ganache
else {
  App.web3Provider = new Web3.providers.HttpProvider('http://localhost:7545');
}
web3 = new Web3(App.web3Provider);
    console.log("running init contract");
    return App.initContract();
  },

  initContract: function() {
    $.getJSON('Adoption.json', function(data) {
      // Get the necessary contract artifact file and instantiate it with @truffle/contract
      var AdoptionArtifact = data;
      App.contracts.Adoption = TruffleContract(AdoptionArtifact);
    
      // Set the provider for our contract
      App.contracts.Adoption.setProvider(App.web3Provider);

      // Set up the accounts
      web3.eth.getCoinbase(function(err, account) {
        if (err === null) {
          App.account = account;
          console.log("account connected:"+ account);
          $("#account").text(account);
        }
      })
      // Use our contract to retrieve and mark the adopted pets
      return App.showListings();
    });

    return App.bindEvents();
  },

  //binding the buy button to the handler function
  bindEvents: function() {
    $(document).on('click', '.btn-adopt', App.handleBuy);
  },

  showListings: function() {
    console.log("showing listings");
    var adoptionInstance;

    App.contracts.Adoption.deployed().then(function(instance) {
      adoptionInstance = instance;

      return adoptionInstance.getKeyboardsAmount.call();
    }).then(function(keyboards) {
      count = keyboards.c[0]

      var petsRow = $('#petsRow');
    var petTemplate = $('#petTemplate');

      for (i = 0; i < count; i++) {
        adoptionInstance.get.call(i).then(function(keyboard) {
          console.log(keyboard);
          
        const id = keyboard[0].c[0];
        const name = keyboard[1];
        const picture = keyboard[2];
        const switches = keyboard[3];
        const price = keyboard[4].c[0];
        const uploader = keyboard[5];
        const owner = keyboard[6];

        petTemplate.find('.panel-title').text(name);
        petTemplate.find('img').attr('src', picture);
        petTemplate.find('.switches').text(switches);
        petTemplate.find('.id').text(id);
        petTemplate.find('.price').text(price);
        petTemplate.find('.btn-adopt').attr('data-price', price);
        petTemplate.find('.uploader').text(uploader);
        petTemplate.find('.owner').text(owner);
        
        if(owner !== '0x0000000000000000000000000000000000000000'){
          petTemplate.find('.btn-adopt').text('Unavailable').attr('disabled', true);
        } else petTemplate.find('.btn-adopt').text('Buy').attr('data-id', id).attr('disabled', false);

        petsRow.append(petTemplate.html());
          
        }).catch(function(err) {
          console.log(err.message);
        });
      }
      console.log("Keyboards loaded successfully.");
    }).catch(function(err) {
      console.log(err.message);
    });
  },

  //making the buy buttons unclickable for already bought items

  handleBuy: function(event) {
    event.preventDefault();

    var kbId = parseInt($(event.target).data('id'));
    var kbPrice = parseInt($(event.target).data('price'));
    console.log("buying keyboard with id and price: " + kbId + ", " + kbPrice);

    var adoptionInstance;

web3.eth.getAccounts(function(error, accounts) {
  if (error) {
    console.log(error);
  }

  var account = accounts[0];

  App.contracts.Adoption.deployed().then(function(instance) {
    adoptionInstance = instance;

    // Execute adopt as a transaction by sending account
    return adoptionInstance.buy(kbId, {from: account, value:web3.toWei(kbPrice, "ether")});
  }).then(function(result) {
    console.log(result);
    console.log("Purchased", kbId, kbPrice);
    location.reload();
  }).catch(function(err) {
    console.log(err.message);
  });
});
  }
};

$(function() {
  $(window).load(function() {
    App.init();
  });
});