/// Flattery is a library for building HTML elements using Widgets.
///
/// It allows creating user interfaces based on simple Widgets that do not try
/// to hide the underlying, awesome dart:html package. It makes using dart:html
/// in a reactive manner easy, without using the complex layer of a Virtual
/// DOM in the middle.
library flattery;

export 'src/container.dart';
export 'src/shadow_widget.dart';
export 'src/util/util.dart' show querySelectorAllWithShadow;
export 'src/widget.dart';
