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
  var m1 = await getJson('m1.json');
  addPara(m1['message']);

  addPara('Slowly count to 3 using synchronous generator...');

  for (var n in getNumbers(1, 3)) {
    addPara(n);
    await sleep(1);
  }

  var m2 = await getJson('m2.json');
  addPara(m2['message']);

  addPara('Slowly count from 6 to 9 using asynchronous generator...');

  await for (var n in getNumbersSlowly(6, 9)) {
    addPara(n);
  }

  addPara('All done!');
}

void addPara(String mesg) {
  var p = new Element.p();
  p.text = mesg;
  querySelector('#content').append(p);
}

getJson(url) async {
  String s = await HttpRequest.getString(url);
  return json.convert(s);
}

getNumbers(start, end) sync* {
  for (var i=start; i <= end; i++) {
    yield i;
  }
}

getNumbersSlowly(start, end) async* {
  for (var i=start; i <= end; i++) {
    yield i;
    await sleep(1);
  }
}

sleep(int seconds) {
  return new Future.delayed(new Duration(seconds: 1));
}
