import 'dart:html';

@TestOn('browser')
import 'package:test/test.dart';
import 'package:webwidgets/src/widgets.dart';

_setupUI() {
  TextBox.create()
    ..root.id = 'hello'
    ..text = 'Hey there'
    ..appendTo(querySelector('#output'), useShadowDom: false);
}

main() async {
  _setupUI();

  group('Simple Widget', () {
    test('can be added to a HTML document', () async {
      final helloEl = document.getElementById('hello');
      expect(helloEl, isA<DivElement>());
      expect(helloEl.text, equals('Hey there'));
    });
  });
}
