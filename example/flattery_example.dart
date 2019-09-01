import 'dart:html' hide Text;

import 'package:flattery/flattery_widgets.dart';

/// Simple Counter Model.
class Counter {
  int value = 0;
}

/// A Counter Widget.
///
/// By implementing [ShadowWidget], we make our widget use a shadow root
/// to isolate its contents.
class CounterView extends Counter with Widget, ShadowWidget {
  final text = Text('')..style.textAlign = 'left';

  /// Build the component's Element.
  /// Uses a 2x2 grid to place the child Widgets
  Element build() => Grid(columnGap: '10px', classes: [
        'main-grid'
      ], children: [
        [text, text],
        // row 1 (repeat the element so it takes up both columns)
        [
          // row 2 contains 2 buttons to inc/decrement the counter
          Button(text: 'Increment', onClick: (e) => value++),
          Button(text: 'Decrement', onClick: (e) => value--),
        ]
        // row 2
      ]).root;

  CounterView() {
    stylesheet = '* { font-family: sans-serif; }'
        'button { height: 4em; }'
        '.main-grid { width: 25em; }';
    _update();
  }

  /// All model's setters that affect the state of the view need to be
  /// overridden in the Widget extending it, so that they update the view.
  @override
  set value(int value) {
    super.value = value;
    _update();
  }

  _update() => text.text = 'The current count is $value';
}

main() => document.getElementById('output').append(CounterView().root);
