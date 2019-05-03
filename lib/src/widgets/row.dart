import 'dart:html';

import 'package:flattery/flattery.dart';

/// Options for justifying the contents of a [Row].
enum JustifyContent {
  start,
  end,
  center,
  spaceBetween,
  spaceAround,
  spaceEvenly
}

/// Options for aligning the contents of a [Row] vertically.
enum AlignItems { start, end, center, stretch, baseline }

String _justifyValue(JustifyContent justify) {
  switch (justify) {
    case JustifyContent.start:
      return 'flex-start';
    case JustifyContent.end:
      return 'flex-end';
    case JustifyContent.center:
      return 'center';
    case JustifyContent.spaceBetween:
      return 'space-between';
    case JustifyContent.spaceAround:
      return 'space-around';
    case JustifyContent.spaceEvenly:
      return 'space-evenly';
  }
  return '';
}

String _alignValue(AlignItems align) {
  switch (align) {
    case AlignItems.start:
      return 'flex-start';
    case AlignItems.end:
      return 'flex-end';
    case AlignItems.center:
      return 'center';
    case AlignItems.stretch:
      return 'stretch';
    case AlignItems.baseline:
      return 'baseline';
  }
  return '';
}

/// A layout [Widget] which attempts to lay its children all on the same row.
class Row with Widget {
  final root = DivElement();

  Row(
      {List<Widget> children,
      JustifyContent justify = JustifyContent.start,
      AlignItems align = AlignItems.start}) {
    root.style
      ..display = 'flex'
      ..justifyContent = _justifyValue(justify)
      ..alignItems = _alignValue(align);

    children.forEach((c) => root.append(SpanElement()..append(c.root)));
  }
}
