import "package:js/js.dart";

main() {
  awesome();
  terrible(4);

  var animal = new Animal('Robert');
  addPara(animal.name);
  addPara(animal.getGreeting());

  var dog = new Dog('Bartholomew');
  addPara(dog.name);
  addPara(dog.getGreeting());
}

@JS()
external void awesome();

// Rename the function in Dart.
@JS('horrible')
external void terrible(int n);

@JS()
external void addPara(String html);


@anonymous
@JS()
class Animal {
  external Animal(String name);
  external String get name;
  external String getGreeting();
}

@anonymous
@JS()
class Dog {
  external Dog(String name);
  external String get name;
  external String getGreeting();
}
