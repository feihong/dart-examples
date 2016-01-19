'use strict';

function awesome() {
  addPara('Something <i>awesome</i> happened!')
}

function horrible(n) {
  var result = '';
  for (var i=0; i < n; i++) {
    result += 'Something <b>horrible</b> happened (' + (i+1) + '). '
  }
  addPara(result)
}

function addPara(html) {
  var div = document.querySelector('#content')
  var p = document.createElement('p')
  p.innerHTML = html
  div.appendChild(p)
}

var Animal = function(name) {
  this.name = name
}

Animal.prototype.getGreeting = function() { return 'hi' }

var Dog = function(name) {
  Animal.call(this, name)
}

Dog.prototype.getGreeting = function() { return 'bark' }
