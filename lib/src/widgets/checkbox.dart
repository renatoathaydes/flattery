import 'dart:html';

import '../base.dart';

/// Checkbox widget.
///
/// It wraps a [CheckboxInputElement] and a [LabelElement]
/// inside a [SpanElement].
class Checkbox with Widget {
  final _input = CheckboxInputElement();
  final _label = LabelElement();
  final Element root = SpanElement();

  Checkbox(
      {String id = '',
      String label = '',
      bool checked = false,
      Function(bool) onChange}) {
    if (id != null) {
      _input.id = id;
      _input.name = id;
      _label.htmlFor = id;
    }
    _input.checked = checked;
    if (onChange != null) {
      _input.onChange.listen((e) => onChange(_input.checked));
    }
    _label.text = label;

    root..append(_input)..append(_label);
  }
}
