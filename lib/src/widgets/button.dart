import 'dart:html';

import 'package:flattery/flattery.dart';

/// Button Widget.
class Button with Widget {
  final _element = ButtonElement();

  Button({String id, String text = '', Function(MouseEvent) onClick}) {
    if (id != null) {
      _element.id = id;
    }
    _element.text = text;
    if (onClick != null) {
      _element.onClick.listen(onClick);
    }
  }

  @override
  Element build() => _element;
}
