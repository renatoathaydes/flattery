import 'dart:html';

import 'package:flattery/flattery.dart';

/// A Rectangle Widget.
class Rectangle with Widget {
  final Element _element = DivElement()..style.position = 'relative';

  Rectangle(
      {String width = '100px',
      String height = '50px',
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

  /// Create a square.
  Rectangle.square(
      {String size = '100px',
      String top = '0',
      String left = '0',
      String fill = 'white',
      String border = 'solid black 1px'}) {
    _element.style
      ..width = size
      ..height = size
      ..backgroundColor = fill
      ..border = border
      ..top = top
      ..left = left;
  }

  @override
  Element build() => _element;
}
