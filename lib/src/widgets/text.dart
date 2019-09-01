import 'dart:html';

import '../widget.dart';

/// A simple text box.
///
/// By default, it centers its contents and applies a padding of 10px
/// on all sides.
class Text with Widget {
  final root = DivElement();

  /// Create a [Text].
  Text(String text, {String id}) {
    root
      ..style.textAlign = 'center'
      ..style.overflow = 'hidden'
      ..style.padding = '10px'
      ..text = text;
    if (id != null) {
      root.id = id;
    }
  }

  /// Get the text of this [Text].
  String get text => root.text;

  /// Set the text of this [Text].
  set text(String text) => root.text = text;

  @override
  String toString() => 'Text{${root.text}}';
}
