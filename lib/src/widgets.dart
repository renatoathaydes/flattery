import 'dart:html';

import 'webwidgets_base.dart';

/// A simple text box.
///
/// By default, it centers its contents and applies a padding of 10px
/// on all sides.
class TextBox with Widget {
  static final _template = Element.div()
    ..style.textAlign = 'center'
    ..style.overflow = 'hidden'
    ..style.padding = '10px';

  final DivElement root;
  final CssStyleDeclaration style;

  /// Create a [TextBox].
  static TextBox create() {
    final root = _template.clone(true) as DivElement;
    final style = root.style;
    return TextBox._create(root, style);
  }

  TextBox._create(this.root, this.style);

  /// Set the text of this [TextBox].
  set text(String text) => root.text = text;
}
