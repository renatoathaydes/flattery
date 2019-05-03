# Flattery

Flattery is a library for building HTML elements using Widgets.

Widgets are just Dart objects whose purpose is to represent some user interface element.
They are implemented using the awesome `dart:html` package, and do not try to hide it - so you can
use your HTML/CSS knowledge to enhance existing widgets, and to create your own, type safely.

## Usage

A simple usage example:

```dart
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
```

## Building

```
pub get
```

### Run the example

```
webdev serve example
```

### Running the tests

Unit tests:

```
pub run test
```

> Use option `-r json` or `r -expanded` to see details.

Browser tests:

```
pub run test -p chrome
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/renatoathaydes/flattery/issues

## Links

Dart Test Documentation:

https://github.com/dart-lang/test/tree/master/pkgs/test
