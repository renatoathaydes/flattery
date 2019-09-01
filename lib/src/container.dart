import 'dart:collection';
import 'dart:html';

import 'util/util.dart';
import 'widget.dart';

Element _defaultRoot() => DivElement()..classes.add('container-widget');

/// Function that may run when changes are made to a [Container].
typedef ContainerObserver<W> = void Function(List<W> added, List<W> removed);

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
  final List<ContainerObserver<W>> _observers = [];

  Container(
      {List<W> children = const [],
      Element Function() rootFactory = _defaultRoot,
      List<String> classes = const []})
      : _root = rootFactory() {
    this.classes.addAll(classes);
    final observer = MutationObserver(_onMutation);
    observer.observe(_root, childList: true);
    addAll(children);
  }

  // this method is the only one responsible for removing items from the
  // _itemById Map because it's the only place we can always know when an item
  // is removed, even if not via this class.
  void _onMutation(List changes, MutationObserver obs) {
    final added = <W>[];
    final removed = <W>[];
    final addedNodes =
        changes.cast<MutationRecord>().expand((c) => c.addedNodes).toList();
    final removedNodes =
        changes.cast<MutationRecord>().expand((c) => c.removedNodes).toList();

    // items both add/removed were simply swapped around, so do not report them
    final inBoth = addedNodes.toSet().intersection(removedNodes.toSet());
    addedNodes.removeWhere(inBoth.contains);
    removedNodes.removeWhere(inBoth.contains);

    for (final addedNode in addedNodes) {
      final id = _idOf(addedNode);
      if (id == null) {
        // element added by external means, store it with the null item
        _store(addedNode as Element, null);
      } else {
        final addedItem = _itemById[id];
        if (addedItem != null) added.add(addedItem);
      }
    }
    for (final removedNode in removedNodes) {
      final id = _idOf(removedNode);
      if (id != null) {
        final removedItem = _itemById.remove(id);
        if (removedItem != null) removed.add(removedItem);
      }
    }
    _observers.forEach((o) => o(added, removed));
  }

  static String _idOf(Node node) {
    return (node is Element)
        ? node.getAttribute(idAttribute)
        : throw Exception("Unexpected Node which is not a Element: $node");
  }

  @override
  Element get root => _root;

  /// The flattery-id of all items of this [Container].
  Iterable<String> get flatteryIds => _itemById.keys;

  void addObserver(ContainerObserver<W> observer) => _observers.add(observer);

  void removeObserver(ContainerObserver<W> observer) =>
      _observers.remove(observer);

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
    final element = _asElement(item);
    bool isChild = element.parent == _root;
    element.remove();
    if (isChild) {
      _root.children.insert(index, element);
    } else {
      _root.children[index] = element;
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
      _root.children.removeLast();
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
    final currentId = _idOf(element);
    String id;
    if (currentId == null) {
      id = randomString();
      element.setAttribute(idAttribute, id);
    } else {
      id = currentId;
    }
    _itemById[id] = item;
  }
}
