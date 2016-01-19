import "package:js/js.dart";

main() {
  awesome();
  horrible(4);
}

@JS('awesome')
external void awesome();

@JS('horrible')
external void horrible(int n);
