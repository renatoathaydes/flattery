import 'dart:html';

import 'webwidgets_base.dart';

/// A simple text box.
///
/// By default, it centers its contents and applies a padding of 10px
/// on all sides.
class TextBox with Widget {
  final DivElement root;

  CssStyleDeclaration get style => root.style;

  /// Create a [TextBox].
  factory TextBox() {
    final root = DivElement()
      ..style.textAlign = 'center'
      ..style.overflow = 'hidden'
      ..style.padding = '10px';
    return TextBox._create(root);
  }

  TextBox._create(this.root);

  // Get the text of this [TextBox].
  get text => root.text;

  /// Set the text of this [TextBox].
  set text(String text) => root.text = text;
}
