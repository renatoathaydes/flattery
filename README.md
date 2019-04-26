# Webwidgets

Webwidgets is a library for building HTML elements using reactive Widgets.

Widgets are just Dart objects whose purpose is to represent some user interface element.
They are implemented using the awesome `dart:html` package, and do not try to hide it - so you can
use your HTML/CSS knowledge to enhance existing widgets, and to create your own, type safely.

## Usage

A simple usage example:

```dart
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

[tracker]: http://example.com/issues/replaceme

## Links

Download the Chrome Driver for running integration tests:

https://sites.google.com/a/chromium.org/chromedriver/downloads

The webdriver package used for driving the browser in integration tests:

https://pub.dartlang.org/packages/webdriver

Useful package for browser testing:

https://github.com/google/pageloader

Dart Test Documentation:

https://github.com/dart-lang/test/tree/master/pkgs/test
