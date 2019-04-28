import 'dart:html';

import 'package:flattery/flattery_widgets.dart';

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
          Button(text: 'Increment', onClick: (e) => value++),
          Button(text: 'Decrement', onClick: (e) => value--),
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
