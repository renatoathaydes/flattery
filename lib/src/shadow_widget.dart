import 'dart:html';

import './base.dart';

const shadowAttachOptions = {'mode': 'open'};

/// A Widget that is attached to the DOM via the shadow root of a host element.
///
/// The host element is a div by default, but can be overridden with the
/// [createHostElement] method.
mixin ShadowWidget on Widget {
  /// Stylesheet for this shadow Widget (stylesheet's text, not URL).
  ///
  /// Notice that styles declared in this stylesheet apply only to this Widget,
  /// not globally.
  String stylesheet;
  bool _isInitialized = false;

  /// Create the host element for the shadow DOM.
  ///
  /// By default, a div element is created.
  Element createHostElement() => DivElement()..classes.add('shadow-widget');

  @override
  Element get root {
    final r = super.root;
    if (_isInitialized) {
      return r;
    } else {
      _isInitialized = true;
      final host = createHostElement();
      final shadow = host.attachShadow(shadowAttachOptions);
      if (stylesheet != null) {
        shadow.append(StyleElement()..text = stylesheet);
      }
      shadow.append(r);
      return host;
    }
  }
}
