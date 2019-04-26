import 'dart:html';

import 'package:webwidgets/webwidgets.dart';

/// Simple Counter Model.
class Counter {
  int value = 0;
}

/// A Counter Widget.
class CounterView extends Counter with Widget {
  final text = DivElement();

  CounterView() {
    _update();
  }

  @override
  Element build() => Container(
        children: [
          text,
          ButtonElement()
            ..text = 'Increment'
            ..onClick.listen((e) => value++),
          ButtonElement()
            ..text = 'Decrement'
            ..onClick.listen((e) => value--),
        ],
      ).root;

  @override
  set value(int value) {
    super.value = value;
    _update();
  }

  _update() => text.text = 'The current count is $value';
}

main() => document.getElementById('output').append(CounterView().root);
