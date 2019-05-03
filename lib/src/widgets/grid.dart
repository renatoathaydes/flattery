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

    _findPlacements(children).forEach((child, place) {
      child.root.classes.add('grid-cell');
      child.style.gridArea =
          '${place[0].x} / ${place[0].y} / ${place[1].x} / ${place[1].y}';
      root.append(child.root);
    });
  }

  Map<Widget, List<Point<int>>> _findPlacements(List<List<Widget>> children) {
    final placements = Map<Widget, List<Point<int>>>();
    for (int row = 1; row <= children.length; row++) {
      final column = children[row - 1];
      for (int col = 1; col <= column.length; col++) {
        final child = column[col - 1];
        if (child == null) continue;
        final place = placements[child] ?? [Point(row, col), Point(0, 0)];
        place[1] = Point(row + 1, col + 1);
        placements[child] = place;
      }
    }
    return placements;
  }
}
