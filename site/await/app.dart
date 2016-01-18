import 'dart:html';
import 'dart:async';
import 'dart:convert';

final json = new JsonDecoder();

main() {
  doSomeStuff().then((result) {
    print('Done! Result: ${result}');
  });
}

void doSomeStuff() async {
  addPara('Slowly count to 5 using synchronous generator...');

  for (var n in getNumbers(1, 6)) {
    addPara(n);
    await sleep(1);
  }

  addPara('Slowly count from 6 to 10 using asynchronous generator...');

  await for (var n in getNumbersSlowly(6, 11)) {
    addPara(n);
  }
}

void addPara(String mesg) {
  var p = new Element.p();
  p.text = mesg;
  querySelector('#content').append(p);
}

// getJson(url) async* {
//   String s = await HttpRequest.getString(url);
//   print(s);
//   yield json.convert(s);
// }

getNumbers(start, end) sync* {
  for (var i=start; i < end; i++) {
    yield i;
  }
}

getNumbersSlowly(start, end) async* {
  for (var i=start; i < end; i++) {
    yield i;
    await sleep(1);
  }
}

sleep(int seconds) {
  return new Future.delayed(new Duration(seconds: 1));
}
