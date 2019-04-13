import 'dart:html';

mixin Widget {
  Element _root;
  bool _attached;

  Element get root;

  bool get isAttached => _attached;

  void onAttached() {}

  void onDetached() {}

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
