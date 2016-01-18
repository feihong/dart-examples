import 'dart:html';
import 'dart:developer';

int counter = 0;

main() {
  var addButton = querySelector('button.add');
  addButton.onClick.listen((evt) {
    counter++;
    addPara('Clicked ${counter} times');
  });

  var clearButton = querySelector('button.clear');
  clearButton.onClick.listen((evt) {
    querySelector('#content').innerHtml = '';
  });

  var debugButton = querySelector('button.debug');
  debugButton.onClick.listen((evt) {
    var text = 'Hello there';
    debugger(message: 'Time to debug');    
  });
}

void addPara(String mesg) {
  var p = new Element.p();
  p.text = mesg;
  querySelector('#content').append(p);
}
