import 'dart:collection';
import 'dart:html';

import 'package:webwidgets/src/util/util.dart';

/// Wrap a simple [Element] into a [Widget].
Widget widget(Element element) => _BasicWidget(element);

/// A Widget is a simple abstraction around a HTML [Element].
///
/// It makes it possible to create user interfaces declaratively, using Dart.
mixin Widget {
  Element _rootRef;

  CssStyleDeclaration get style => root.style;

  /// Build the root [Element] of this [Widget].
  Element build();

  /// Remove this [Widget] from the DOM.
  ///
  /// This call is ignored if the [Widget] is not attached to the DOM.
  void removeFromDom() {
    _rootRef?.remove();
  }

  /// The ID of this [Widget].
  String get id => _rootRef?.id ?? "";

  /// The root of this element.
  ///
  /// Accessing the root may cause the [build] method to be invoked if it
  /// had not been invoked yet.
  ///
  /// The [Element] returned by this getter is not necessarily the same as the
  /// one created by the [build] method - subtypes are free to override it,
  /// but when this [Widget] is attached to the DOM, this is the [Element] that
  /// should be used.
  Element get root {
    if (_rootRef == null) {
      _rootRef = build();
      assert(_rootRef != null, "build() cannot return null");
    }
    return _rootRef;
  }
}

class _BasicWidget with Widget {
  final Element _element;

  _BasicWidget(this._element);

  @override
  Element build() => _element;
}

Element _defaultRoot() => DivElement()..classes.add('container-widget');

const String idAttribute = 'webwidgets-id';

/// A Container is a [Widget] that contains a List of items.
///
/// It can be treated as a simple [List<W>], but changes to its items are
/// reflected in the DOM.
///
/// TODO: remove items that get removed from the DOM indirectly.
///
/// Items may be converted to DOM Elements in the following manner, depending
/// on their types:
///
/// * Widget - its `root` element is added.
/// * Element - added as is.
/// * null    - added as an empty span Element.
/// * others  - added as a span Elemnt whose text is the Object.toString() value
class Container<W> extends ListMixin<W> with Widget {
  final Element _root;
  final Map<String, W> _itemById = {};

  Container(
      {List<W> children = const [],
      Element Function() rootFactory = _defaultRoot})
      : _root = rootFactory() {
    addAll(children);
  }

  @override
  Element build() => _root;

  @override
  void add(W item) {
    Element element = _asElement(item);
    _root.append(element);
    _store(element, item);
  }

  @override
  void addAll(Iterable<W> items) {
    items.forEach(add);
  }

  @override
  void operator []=(int index, W item) {
    // this will remove the element from the DOM if it was already present...
    // in case the element being added is already a child of this root,
    // we need to insert the element, otherwise, just set
    // it at the requested index.
    final oldElement = _getElementAt(index);
    final element = _asElement(item);
    bool isChild = element.parent == _root;
    element.remove();
    if (isChild) {
      _root.children.insert(index, element);
    } else {
      _root.children[index] = element;
    }
    if (oldElement != null) {
      _itemById.remove(oldElement.getAttribute(idAttribute));
    }
    _store(element, item);
  }

  @override
  W operator [](int index) {
    final element = _getElementAt(index);
    if (element != null) {
      return _itemById[element.getAttribute(idAttribute)];
    }
    throw StateError("Element at index $index does not have expected "
        "attribute: $idAttribute. This is caused by modifying the "
        "Container's children indirectly - if index access is required, "
        "do not modify this Container's children indirectly, use the "
        "Container's methods only.");
  }

  @override
  int get length => _root.children.length;

  @override
  set length(int newLength) {
    if (newLength > length) {
      throw Exception("Cannot increase length of Container without "
          "adding new items to it.");
    }
    if (newLength < 0) {
      newLength = 0;
    }
    var itemsToRemove = length - newLength;
    while (itemsToRemove > 0) {
      final removedElement = _root.children.removeLast();
      if (removedElement.hasAttribute(idAttribute)) {
        _itemById.remove(removedElement.getAttribute(idAttribute));
      }
      itemsToRemove--;
    }
    assert(
        length == newLength, "New length: $newLength, Current length: $length");
  }

  Element _asElement(item) {
    switch (item) {
      case Widget:
        return item.root;
    }
    if (item is Widget) {
      return item.root;
    } else if (item is Element) {
      return item;
    } else {
      return SpanElement()..text = item?.toString() ?? "";
    }
  }

  Element _getElementAt(int index) {
    final element = _root.children[index];
    if (element.hasAttribute(idAttribute)) {
      return element;
    }
    return null;
  }

  void _store(Element element, W item) {
    final id = randomString();
    element.setAttribute(idAttribute, id);
    _itemById[id] = item;
  }
}
