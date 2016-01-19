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

function addPara(text) {
  var div = document.querySelector('#content')
  var p = document.createElement('p')
  p.innerHTML = text
  div.appendChild(p)
}
