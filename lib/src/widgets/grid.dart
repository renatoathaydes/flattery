import 'dart:html';
import 'dart:math';

import 'package:flattery/flattery.dart';
import 'package:flattery/src/util/util.dart';

String _templateRowsValue(List<String> rowHeights, int rowCount) {
  final buffer = StringBuffer();
  for (int i = 0; i < rowCount; i++) {
    buffer.write(valueAt(rowHeights, i, 'auto'));
    buffer.write(' ');
  }
  return buffer.toString().trimRight();
}

String _templateColumnsValue(List<String> columnWidths, int columnCount) {
  final buffer = StringBuffer();
  for (int i = 0; i < columnCount; i++) {
    buffer.write(valueAt(columnWidths, i, 'auto'));
    buffer.write(' ');
  }
  return buffer.toString().trimRight();
}

/// Grid widget.
///
/// A grid is a container that can place its children across a 2-dimensional
/// grid formed by rows and columns.
class Grid with Widget {
  final root = DivElement();

  Grid({
    List<String> rowHeights = const [],
    List<String> columnWidths = const [],
    List<List<Widget>> children = const [],
    String rowGap,
    String columnGap,
  }) {
    final rowCount = children.length;
    final columnCount =
        children.fold<int>(0, (acc, child) => max(acc, child.length));

    root.style
      ..display = 'grid'
      ..gridAutoFlow = 'row'
      ..gridTemplateRows = _templateRowsValue(rowHeights, rowCount)
      ..gridTemplateColumns = _templateColumnsValue(columnWidths, columnCount);

    if (rowGap != null) {
      root.style.setProperty('grid-row-gap', rowGap);
    }
    if (columnGap != null) {
      root.style.setProperty('grid-column-gap', columnGap);
    }

    for (int row = 0; row < children.length; row++) {
      final column = children[row];
      for (int col = 0; col < column.length; col++) {
        final child = column[col];
        if (child == null) continue;
        // TODO support specifying items area in the grid
        child.style.gridArea = '${row + 1} / auto / ${row + 2} / auto';
        root.append(child.root);
      }
    }
  }
}
