import 'dart:html';

import '../base.dart';

/// A simple text box.
///
/// By default, it centers its contents and applies a padding of 10px
/// on all sides.
class Text with Widget {
  DivElement _root;

  /// Create a [Text].
  factory Text() {
    final root = DivElement()
      ..style.textAlign = 'center'
      ..style.overflow = 'hidden'
      ..style.padding = '10px';
    return Text._create(root);
  }

  Text._create(this._root);

  @override
  Element build() => _root;

  /// Get the text of this [Text].
  get text => _root.text;

  /// Set the text of this [Text].
  set text(String text) => root.text = text;
}
