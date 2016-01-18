import 'dart:html';
import 'dart:developer';

int counter = 0;
bool debug = false;

main() {
  var checkbox = querySelector('input');
  checkbox.onClick.listen((evt) => debug = evt.target.checked);

  var addButton = querySelector('button.add');
  addButton.onClick.listen((evt) {
    counter++;
    addPara('Clicked ${counter} times');
    debugger(message: 'Conditional', when: debug);
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

  var assertButton = querySelector('button.assert');
  assertButton.onClick.listen((evt) {
    assert(false);
    addParaHtml('''
      The assert was ignored because we are not running in checked mode.
      Run <code>DART_FLAGS='--checked' dartium</code> to turn on checked mode.
    ''');
  });
}

void addPara(String mesg) {
  // Use the cascade (..) operator to avoid creating an Element variable just to
  // set its text property.
  querySelector('#content').append(
    new Element.p()..text = mesg
  );
}

void addParaHtml(String html) {
  querySelector('#content').append(
    new Element.p()..innerHtml = html
  );
}
