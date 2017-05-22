'use strict';

window.addEventListener('load', function() {
  var Elm = require('./Main.elm');

  var node = document.createElement('div');
  var parentNode = document.getElementById('rightTabLog');
  parentNode.insertBefore(node, parentNode.firstChild);

  var app = Elm.Main.embed(node)
});
