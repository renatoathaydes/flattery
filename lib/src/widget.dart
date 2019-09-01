import 'dart:html';

/// Attribute added to items of a [Container] in order to keep track of them.
const String idAttribute = 'fty-id';

/// Wrap a simple [Element] into a [Widget].
Widget widget(Element element) => _BasicWidget(element);

/// A Widget is a simple abstraction around a HTML [Element].
///
/// It makes it possible to create user interfaces declaratively, using Dart.
mixin Widget {
  /// CSS style of this [Widget].
  CssStyleDeclaration get style => root.style;

  /// CSS classes of this [Widget].
  CssClassSet get classes => root.classes;

  /// Remove this [Widget] from the DOM.
  ///
  /// This call is ignored if the [Widget] is not attached to the DOM.
  void removeFromDom() {
    root?.remove();
  }

  /// The ID of this [Widget].
  String get id => root?.id ?? "";

  /// The root [Element] of this [Widget].
  Element get root;
}

class _BasicWidget with Widget {
  final Element _element;

  _BasicWidget(this._element);

  @override
  Element get root => _element;
}
