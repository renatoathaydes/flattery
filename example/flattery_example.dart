import 'dart:html';

import 'package:flattery/flattery_widgets.dart';

/// Simple Counter Model.
class Counter {
  int value = 0;
}

/// A Counter Widget.
class CounterView extends Counter with Widget, ShadowWidget {
  final text = Text('')..style.textAlign = 'left';

  // use a 2x2 grid to place the Widgets
  Element build() => Grid(columnGap: '10px', children: [
        [text, text], // row 1 (repeat the element so it takes up both columns)
        [
          Button(text: 'Increment', onClick: (e) => value++),
          Button(text: 'Decrement', onClick: (e) => value--),
        ] // row 2
      ]).root
        ..classes.add('main-grid');

  CounterView() {
    stylesheet = '* { font-family: sans-serif; }'
        'button { height: 4em; }'
        '.main-grid { width: 25em; }';
    _update();
  }

  @override
  set value(int value) {
    super.value = value;
    _update();
  }

  _update() => text.text = 'The current count is $value';
}

main() => document.getElementById('output').append(CounterView().root);
