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

  Element _host;

  /// Create the host element for the shadow DOM.
  ///
  /// By default, a div element is created.
  Element createHostElement() => DivElement()..classes.add('shadow-widget');

  /// Build the element for this [Widget].
  ///
  /// The returned [Element] will be appended to the shadow DOM of the host
  /// element created by calling [createHostElement].
  Element build();

  /// The root [Element] of this [Widget].
  ///
  /// Sub-classes are not supposed to override this getter, but if they do,
  /// they must invoke super.
  @override
  Element get root {
    if (_host != null) {
      return _host;
    } else {
      final element = build();
      _host = createHostElement();
      final shadow = _host.attachShadow(shadowAttachOptions);
      if (stylesheet != null) {
        shadow.append(StyleElement()..text = stylesheet);
      }
      shadow.append(element);
      return _host;
    }
  }
}
