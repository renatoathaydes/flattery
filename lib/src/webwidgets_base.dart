import 'dart:html';

/// A Widget is a simple abstraction around a HTML [Element].
///
/// It makes it possible to create user interfaces declaratively, using Dart.
mixin Widget {
  Element _root;
  bool _attached;

  /// Get the root [Element] of this [Widget].
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
  void appendTo(Element parent, {bool useShadowDom = true}) {
    remove();

    _root = root;

    Element attachedElement;
    if (useShadowDom) {
      final host = Element.tag('div')..classes.add('host-$runtimeType');
      host.attachShadow({'mode': 'open'}).append(_root);
      attachedElement = host;
    } else {
      attachedElement = _root;
    }
    _observe(parent, attachedElement);
    parent.append(attachedElement);
  }

  /// Remove this [Widget] from its parent.
  ///
  /// If this Widget has not been appended to a parent, nothing occurs.
  void remove() {
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
}
