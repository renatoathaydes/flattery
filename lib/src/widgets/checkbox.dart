import 'dart:html';

import '../base.dart';

/// Checkbox widget.
class Checkbox with Widget {
  final _input = CheckboxInputElement();
  final _label = LabelElement();

  Checkbox({String name = '',
    String label = '',
    bool checked = false,
    Function(bool) onChange}) {
    _input
      ..name = name
      ..checked = checked;
    if (onChange != null) {
      _input.onChange.listen((e) => onChange(_input.checked));
    }
    _label..setAttribute('for', name)..text = label;
  }

  @override
  Element build() =>
      SpanElement()
        ..append(_input)..append(_label);
}