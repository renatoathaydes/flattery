import 'dart:html';

import 'webwidgets_base.dart';

/// A simple text box.
///
/// By default, it centers its contents and applies a padding of 10px
/// on all sides.
class TextBox with Widget {
  DivElement _root;

  CssStyleDeclaration get style => root.style;

  /// Create a [TextBox].
  factory TextBox() {
    final root = DivElement()
      ..style.textAlign = 'center'
      ..style.overflow = 'hidden'
      ..style.padding = '10px';
    return TextBox._create(root);
  }

  TextBox._create(this._root);

  @override
  Element build() => _root;

  /// Get the text of this [TextBox].
  get text => _root.text;

  /// Set the text of this [TextBox].
  set text(String text) => root.text = text;
}
