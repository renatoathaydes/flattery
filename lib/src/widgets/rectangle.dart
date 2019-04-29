import 'dart:html';

import 'package:flattery/flattery.dart';

/// A Rectangle Widget.
class Rectangle with Widget {
  final Element _element = DivElement()..style.position = 'relative';

  Rectangle(
      {String width = '10px',
      String height = '10px',
      String top = '0',
      String left = '0',
      String fill = 'white',
      String border = 'solid black 1px'}) {
    _element.style
      ..width = width
      ..height = height
      ..backgroundColor = fill
      ..border = border
      ..top = top
      ..left = left;
  }

  @override
  Element build() => _element;
}
