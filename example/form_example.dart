import 'dart:html';

import 'package:flattery/flattery_widgets.dart';

/// An example model class for which we'll create views.
class TextCount {
  String text;
  int count;

  TextCount(this.text, this.count);
}

/// A form that represents a TextBoxModel as a form.
///
/// The text is shown in small boxes, of which there's as many as the 'count'
/// value of the [TextCount].
///
/// By using ShadowWidget, we ensure that our Widget's styles cannot be broken
/// by the surrounding DOM, as it is isolated under a shadow DOM.
class TextCountForm extends TextCount with Widget, ShadowWidget {
  final _errorBox = Text('')..root.classes.add('error');
  final _boxes = Container<SpanElement>(rootFactory: flexBox);
  final _timeBox = Text('');
  final _textInput = InputElement(type: 'text')..name = 'text';
  final _countInput = InputElement(type: 'number')..name = 'count';

  TextCountForm() : super('', 0) {
    _countInput.onKeyUp.listen(_onCountChange);
    _textInput.onKeyUp.listen(_onTextChange);
    stylesheet = //
        '.error { color: red; } '
        '.box { padding: 0.2em; border: solid 1px gray; margin: 0.1em; }';
  }

  @override
  Element build() => Container(
        classes: ['text-box-form'],
        children: [
          inputWidget(_textInput, 'Text:'),
          inputWidget(_countInput, 'Number of Widgets to display:'),
          _errorBox,
          button('Reset', _onReset),
          lineBreak(),
          _timeBox,
          lineBreak()..style.minHeight = '20px',
          _boxes
        ],
        rootFactory: flexBox,
      ).root;

  set text(String text) {
    super.text = text;
    _textInput.value = text;
    _boxes.forEach((box) => box.text = text);
  }

  set count(int newCount) {
    final currentCount = count;
    if (newCount != currentCount) {
      if (newCount > 10000) {
        _countInput.classes.add('error');
        _errorBox.text = 'Exceeded maximum allowed number of boxes!';
        return;
      } else {
        _countInput.classes.remove('error');
        _errorBox.text = '';
      }
      _updateCount(newCount);
    }
  }

  void _onTextChange(e) {
    if (text != _textInput.value) {
      text = _textInput.value;
    }
  }

  void _onCountChange(e) {
    int newCount = int.tryParse(_countInput.value);
    if (newCount != null && newCount != count) {
      final startTime = window.performance.now();
      count = newCount;
      final totalTime = window.performance.now() - startTime;
      _timeBox.text = "Total time: $totalTime ms";
    }
  }

  void _onReset(e) {
    count = 5;
    text = 'Flattery!';
  }

  void _updateCount(int newCount) {
    while (_boxes.length < newCount) {
      _boxes.add(SpanElement()
        ..classes.add('box')
        ..text = text);
    }
    while (_boxes.length > newCount) {
      _boxes.removeLast();
    }
    super.count = newCount;
    _countInput.value = newCount.toString();
  }
}

main() {
  // wrap the model in a form, so updates to the form will be reflected on the
  // model.
  // We could pass on the form to other UI components with type TextBoxModel,
  // so they wouldn't even know they are updating a view, not just the model.
  TextCount form = TextCountForm();

  // here, we can use the form as a simple TextCount instance!
  // All updates will be immediately visible in the view.
  form
    ..text = 'Flattery!'
    ..count = 5;

  // create the UI
  querySelector('#output').append(Container(children: [
    largeTextBox('Flattery Demo (this is a TextBox)'),
    htmlText('<p>This is a little performance test for Flattery...</p>'
        '<p>You can insert a lot of widgets to this page and check how '
        'long it takes!</p><p>The widgets will all mirror the text you enter</p>'),
    form,
  ]).root);
}

// some helper functions to create simple custom Widgets

Element lineBreak() => DivElement()..style.width = '100%';

Widget largeTextBox(String text) => Text('')
  ..style.border = 'solid gray 2px'
  ..style.fontSize = '4em'
  ..text = text;

Widget htmlText(String text) => widget(Element.span()
  ..style.fontSize = '1.5em'
  ..innerHtml = text);

Widget inputWidget(InputElement input, String label) => Container(children: [
      widget(LabelElement()
        ..htmlFor = input.name
        ..text = label),
      widget(input),
    ]);

Widget button(String text, Function(MouseEvent) onClick) =>
    widget(ButtonElement()
      ..text = text
      ..onClick.listen(onClick)
      ..style.padding = '0.5em');

DivElement flexBox() => DivElement()
  ..style.display = 'flex'
  ..style.flexWrap = 'wrap'
  ..style.justifyContent = 'space-around';
