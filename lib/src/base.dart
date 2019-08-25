import 'dart:collection';
import 'dart:html';

import 'package:flattery/src/util/util.dart';

/// Attribute added to items of a [Container] in order to keep track of them.
const String idAttribute = 'fty-id';

/// Wrap a simple [Element] into a [Widget].
Widget widget(Element element) => _BasicWidget(element);

/// A Widget is a simple abstraction around a HTML [Element].
///
/// It makes it possible to create user interfaces declaratively, using Dart.
mixin Widget {
  CssStyleDeclaration get style => root.style;

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

Element _defaultRoot() => DivElement()..classes.add('container-widget');

/// A Container is a [Widget] that contains a List of items.
///
/// It can be treated as a simple [List<W>], with changes to its items
/// reflected in the DOM. To keep track of its items, an attribute called
/// 'flattery-id' is added to each element added to it. A random value is used.
///
/// Items added to a [Container] may be converted to DOM Elements in the
/// following manner, depending on their types:
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
    final observer = MutationObserver((changes, obs) {
      for (MutationRecord change in changes) {
        for (final removedNode in change.removedNodes) {
          final id = (removedNode as Element).getAttribute(idAttribute);
          _itemById.remove(id);
        }
        for (final addedNode in change.addedNodes) {
          final id = (addedNode as Element).getAttribute(idAttribute);
          if (id == null) {
            // element added by external means, store it with the null item
            _store(addedNode, null);
          }
        }
      }
    });
    observer.observe(_root, childList: true);
    addAll(children);
  }

  @override
  Element get root => _root;

  /// The flattery-id of all items of this [Container].
  Iterable<String> get flatteryIds => _itemById.keys;

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
    if (item is Widget) {
      return item.root;
    } else if (item is Element) {
      return item;
    } else {
      return SpanElement()
        ..text = item?.toString() ?? "";
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

/// Query all [Element]s within the root (or the [document] if not given),
/// recursing into [ShadowWidget]'s shadow DOM as needed.
List<Element> querySelectorAllWithShadow(String selectors,
    [List<Element> accumulator, root]) {
  root ??= document;
  accumulator ??= [];
  accumulator.addAll(root.querySelectorAll(selectors) as Iterable<Element>);
  root
      .querySelectorAll('.shadow-widget')
      .map((e) => e.shadowRoot)
      .forEach((e) => querySelectorAllWithShadow(selectors, accumulator, e));
  return accumulator;
}
