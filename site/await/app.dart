import 'dart:html';
import 'dart:async';
import 'dart:convert';

main() {
  doSomeStuff().then((result) {
    print('Done! Result: ${result}');
  });
}

void doSomeStuff() async {
  addPara('Slowly count to 5...');

  for (var n in getNumbers(1, 6)) {
    addPara(n);
    await sleep(1);
  }
}

void addPara(String mesg) {
  var p = new Element.p();
  p.text = mesg;
  querySelector('#content').append(p);
}

getJson(url) {
  HttpRequest.getString(url)
}

getNumbers(start, end) sync* {
  for (var i=start; i < end; i++) {
    yield i;
  }
}

sleep(int seconds) {
  return new Future.delayed(new Duration(seconds: 1));
}
