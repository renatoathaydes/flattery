import 'dart:html';

@TestOn('browser')
import 'package:test/test.dart';

_setupUI() {
  final content = querySelector('#output');
  content.append(DivElement()
    ..id = 'hello'
    ..text = 'Hey there');
}

main() async {
  _setupUI();

  group('Simple Widget', () {
    test('can be added to a HTML document', () async {
      // TODO
      final helloEl = document.getElementById('hello');
      expect(helloEl?.text, equals('Hey there'));
    });
  });
}
