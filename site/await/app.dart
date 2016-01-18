import 'dart:html';
import 'dart:convert';

main() {
  for (var n in getNumbers(88, 102)) {
    print(n);
  }
}

void doSomeStuff() async {

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
