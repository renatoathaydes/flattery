import 'dart:collection';
import 'dart:html';

import 'package:webwidgets/src/util/util.dart';

Widget widget(Element element) => _BasicWidget(element);

/// A Widget is a simple abstraction around a HTML [Element].
///
/// It makes it possible to create user interfaces declaratively, using Dart.
mixin Widget {
  Element _root;
  bool _attached;

  /// Get the root [Element] of this [Widget].
  ///
  /// The getter is only called when the [Widget] is added to the DOM.
  /// Implementations are free to choose whether to always return the same
  /// instance, or a new one every time.
  Element get root;

  /// Returns whether this [Widget] is attached to the DOM.
  bool get isAttached => _attached;

  /// Callback invoked when the Widget is attached to the DOM.
  void onAttached() {}

  /// Callback invoked when the Widget is removed from the DOM.
  void onDetached() {}

  /// Append this Widget to the given [Element].
  ///
  /// By default, the root of this [Widget] is appended to a host div inside
  /// the shadow DOM of the parent [Element].
  ///
  /// Returns the attached [Element].
  Element appendTo(Element parent, {bool useShadowDom = true}) {
    Element elementToAttach = _prepareToAttach(parent, useShadowDom);
    parent.append(elementToAttach);
    return elementToAttach;
  }

  /// Set this Widget as the [index]th child of the given parent [Element].
  ///
  /// By default, the root of this [Widget] is appended to a host div inside
  ///  the shadow DOM of the parent [Element].
  ///
  /// Returns the attached [Element].
  Element setAt(Element parent, int index, {bool useShadowDom = true}) {
    // this will remove the element from the DOM if it was already present,
    // preparing it to be added again... in case the old parent was the same as
    // the new parent, we need to re-insert the element, otherwise, just set
    // it at the requested index.
    final currentChildren = parent.children.length;
    Element elementToAttach = _prepareToAttach(parent, useShadowDom);
    final wasSameParentBefore = parent.children.length == currentChildren - 1;
    if (wasSameParentBefore) {
      parent.children.insert(index, elementToAttach);
    } else {
      parent.children[index] = elementToAttach;
    }
    return elementToAttach;
  }

  /// Remove this [Widget] from its parent.
  ///
  /// If this Widget has not been appended to a parent, nothing occurs.
  void removeFromDom() {
    if (_root == null) {
      return;
    }

    if (_root.parentNode is ShadowRoot) {
      final shadowRoot = _root.parentNode as ShadowRoot;
      shadowRoot.host.remove();
    } else {
      _root.remove();
    }
  }

  _observe(Element parent, Element host) {
    MutationObserver observer;
    observer = MutationObserver((changes, obs) {
//      print("Detected changes: "
//          "${changes.map((c) => "${c.type}: ADD ${c.addedNodes}, DEL ${c.removedNodes}").toList()}");
      for (MutationRecord change in changes) {
        if (change.addedNodes.contains(host)) {
          _attached = true;
          onAttached();
        } else if (change.removedNodes.contains(host)) {
          _attached = false;
          observer.disconnect();
          onDetached();
        }
      }
    });

    observer.observe(parent, childList: true);
  }

  Element _prepareToAttach(Element parent, bool useShadowDom) {
    removeFromDom();

    _root = root;

    Element elementToAttach;
    if (useShadowDom) {
      final host = DivElement()..classes.add('widget-host');
      host.attachShadow({'mode': 'open'}).append(_root);
      elementToAttach = host;
    } else {
      elementToAttach = _root;
    }
    _observe(parent, elementToAttach);
    return elementToAttach;
  }
}

class _BasicWidget with Widget {
  final Element root;

  _BasicWidget(this.root);
}

Element _defaultRoot() => DivElement()..classes.add('container-widget');

const String idAttribute = 'webwidgets-id';

/// A ContainerWidget is a [Widget] that contains a List of items.
class ContainerWidget<W> extends ListMixin<W> with Widget {
  final Element _root;
  final Map<String, W> _itemById = {};

  ContainerWidget(
      {List<W> children = const [],
      Element Function() rootFactory = _defaultRoot})
      : _root = rootFactory() {
    addAll(children);
  }

  @override
  Element get root => _root;

  @override
  void add(W item) {
    Element element;
    if (item is Widget) {
      element = item.appendTo(_root, useShadowDom: false);
    } else if (item is Element) {
      element = item;
      _root.append(item);
    } else {
      element = SpanElement()..text = item?.toString() ?? "";
      _root.append(element);
    }
    _store(element, item);
  }

  @override
  void addAll(Iterable<W> items) {
    items.forEach(add);
  }

  @override
  void operator []=(int index, W item) {
    final oldElement = _getElementAt(index);
    Element element;
    if (item is Widget) {
      element = item.setAt(_root, index, useShadowDom: false);
    } else if (item is Element) {
      element = item;
      _root.children[index] = element;
    } else {
      element = SpanElement()..text = (item?.toString() ?? "");
      _root.children[index] = element;
    }
    _store(element, item);
    if (oldElement != null) {
      _itemById.remove(oldElement.getAttribute(idAttribute));
    }
  }

  @override
  W operator [](int index) {
    final element = _getElementAt(index);
    if (element != null) {
      return _itemById[element.getAttribute(idAttribute)];
    }
    throw StateError("Element at index $index does not have expected "
        "attribute: $idAttribute. This is caused by modifying the "
        "ContainerWidget's children indirectly - if index access is required, "
        "do not modify this Container's children indirectly, use the "
        "Container's methods only.");
  }

  @override
  int get length => _root.children.length;

  @override
  set length(int newLength) {
    if (newLength > length) {
      throw Exception("Cannot increase length of ContainerWidget");
    }
    if (newLength < 0) {
      throw Exception("Cannot set length to negative number");
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
