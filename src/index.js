'use strict';

var $ = require('../node_modules/jquery/dist/jquery.slim.js');

function waitForGameData() {
  if (typeof window.gamePage !== "undefined") {
    console.log(window.gamePage);
    loadApp();
  } else {
    setTimeout(waitForGameData, 250);
  }
}

function loadApp() {
  var node = document.createElement('div');
  var parentNode = document.getElementById('rightTabLog');
  parentNode.insertBefore(node, parentNode.firstChild);

  var Elm = require('./Main.elm');
  var app = Elm.Main.embed(node, window.gamePage);

  /** Subs **/
  /* Update GameData every Second */
  setInterval(function() {
    app.ports.updateGameData.send(window.gamePage);
  }, 1000);

  /** Ports **/
  /* toggleGatherCatnip */
  var gatherCatnipInterval = null;
  app.ports.toggleGatherCatnip.subscribe(function() {
    if (gatherCatnipInterval) {
      console.log("Disabling Catnip Gathering.");
      clearInterval(gatherCatnipInterval);
      gatherCatnipInterval = null;
    } else {
      console.log("Enabling Catnip Gathering.");
      gatherCatnipInterval = setInterval(function() {
        $('.btnContent:contains("Gather catnip")').click();
      }, 100);
    }
  });

  /* toggleObserveSky */
  var observeSkyInterval = null;
  app.ports.toggleObserveSky.subscribe(function() {
    if (observeSkyInterval) {
      console.log("Disabling Sky Observation.");
      clearInterval(observeSkyInterval);
      observeSkyInterval = null;
    } else {
      console.log("Enabling Sky Observation.");
      observeSkyInterval = setInterval(function() {
        $('#observeBtn').click();
      }, 1000);
    }
  });

  /* sendHunters */
  app.ports.sendHunters.subscribe(function() {
    console.log("Sending Your Hunters.");
    $('#fastHuntContainer a').click();
  });


  /** Buildings **/
  /* buildField */
  app.ports.buildField.subscribe(function() {
    console.log("Building Field.");
    $('.btnContent:contains("Catnip field")').click();
  });

  /* buildHut */
  app.ports.buildHut.subscribe(function() {
    console.log("Building Hut.");
    $('.btnContent:contains("Hut")').click();
  });

  /* buildBarn */
  app.ports.buildBarn.subscribe(function() {
    console.log("Building Barn.");
    $('.btnContent:contains("Barn")').click();
  });


  /** Crafting **/
  /* craftWood */
  app.ports.craftWood.subscribe(function() {
    console.log("Crafting Wood.");
    $('.btnContent:contains("Refine catnip")').click();
  });
}


waitForGameData();
