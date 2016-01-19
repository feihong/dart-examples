import 'dart:html';
import 'dart:async';
import 'dart:convert';

final json = new JsonDecoder();

main() {
  doSomeStuff().then((result) {
    print('Done!');
    // The result is null because the body of doSomeStuff() implicitly returned
    // null.
    print('Result: ${result}');
  });
}

Future doSomeStuff() async {
  var m1 = await getJson('m1.json');
  addPara(m1['message']);

  addPara('Slowly count to 3 using synchronous generator...');

  for (var n in getNumbers(1, 3)) {
    addPara(n.toString());
    await sleep(1);
  }

  var m2 = await getJson('m2.json');
  addPara(m2['message']);

  addPara('Slowly count from 6 to 8 using asynchronous generator...');

  await for (var n in getNumbersSlowly(6, 8)) {
    addPara(n.toString());
  }

  // Attempt to get a nonexistent message.
  try {
    var m3 = await getJson('m3.json');
  } catch(err) {
    if (err.target.status == 404) {
      addPara('Message was not found');
      print('Error: ' + err.toString());
    } else {
      rethrow;
    }
  }

  addPara('All done!');
}

void addPara(String mesg) {
  var p = new Element.p();
  p.text = mesg;
  querySelector('#content').append(p);
}

Future<String> getJson(url) async {
  String s = await HttpRequest.getString(url);
  // Although it looks like we are returning a String, what will actually be
  // returned is a Future.
  return json.convert(s);
}

Iterable getNumbers(start, end) sync* {
  for (var i=start; i <= end; i++) {
    yield i;
  }
}

Stream getNumbersSlowly(start, end) async* {
  for (var n in getNumbers(start, end)) {
    yield n;
    await sleep(1);
  }
}

Future sleep(int seconds) {
  return new Future.delayed(new Duration(seconds: 1));
}
