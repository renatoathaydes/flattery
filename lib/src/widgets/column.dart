import 'dart:html';

import 'package:flattery/flattery.dart';

/// Possible values for aligning the children of a [Column].
enum ColumnAlignment { start, end, center, stretch }

String _alignmentValue(ColumnAlignment alignment) {
  switch (alignment) {
    case ColumnAlignment.start:
      return 'start';
    case ColumnAlignment.end:
      return 'end';
    case ColumnAlignment.center:
      return 'center';
    case ColumnAlignment.stretch:
      return 'stretch';
  }
  return '';
}

/// Column Widget.
///
/// This Widget lays its children out on a single column. It allows for controlling the height of each line as well as
/// the alignment of each child using [ColumnAlignment].
class Column with Widget {
  final _root = DivElement();

  Column({
    List<Widget> children,
    List<String> lineHeights = const [],
    ColumnAlignment defaultAlignment,
    List<ColumnAlignment> childrenAlignments = const [],
    String width,
  }) {
    _root.style
      ..display = 'grid'
      ..gridTemplateRows = _templateRows(children.length, lineHeights);

    if (width != null) {
      _root.style.gridTemplateColumns = width;
    }

    for (var i = 0; i < children.length; i++) {
      final item = SpanElement()..append(children[i].root);
      if (i < childrenAlignments.length && childrenAlignments[i] != null) {
        item.style.justifySelf = _alignmentValue(childrenAlignments[i]);
      } else if (defaultAlignment != null) {
        item.style.justifySelf = _alignmentValue(defaultAlignment);
      }
      _root.append(item);
    }
  }

  String _templateRows(int length, List<String> lineHeights) {
    final buffer = StringBuffer();
    for (var i = 0; i < length; i++) {
      if (i < lineHeights.length) {
        buffer.write(lineHeights[i] ?? 'auto');
        buffer.write(' ');
      } else {
        buffer.write('auto ');
      }
    }
    return buffer.toString().trimRight();
  }

  @override
  Element build() => _root;
}
