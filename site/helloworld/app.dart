import 'dart:html';
import 'dart:math';

final MESSAGES = [
  'Hello World',
  'Hola Mundo',
  'ਸਤਿ ਸ੍ਰੀ ਅਕਾਲ ਦੁਨਿਆ',
  'こんにちは世界',
  '你好世界',
  'Përshendetje Botë',
  'مرحبا بالعالم',
  'Բարեւ, աշխարհ',
  'হ্যালো দুনিয়া',
  'Saluton mondo',
  'გამარჯობა მსოფლიო',
];

final random = new Random();

int fontSize = 12;

main() {
  print('Hello World!');

  var p = querySelector('#message');
  p.style.fontSize = '${fontSize}px';
  p.text = message;

  var button = new ButtonElement();
  button.text = 'Click me!';
  button.onClick.listen((evt) {
    (fontSize < 180) ? fontSize+=3 : null;
    print(fontSize);
    p.style.fontSize = '${fontSize}px';
    p.text = message;
    return;
  });
  querySelector('#control').append(button);
}

get message {
  return MESSAGES[random.nextInt(MESSAGES.length)];
}
