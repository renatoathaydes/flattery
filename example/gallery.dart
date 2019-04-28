import 'dart:html' show Element, document;

import 'package:flattery/flattery_widgets.dart';
import 'package:flattery/src/widgets/checkbox.dart';

class Gallery with Widget, ShadowWidget {
  Gallery() {
    stylesheet = '''
    .highlight-flattery-widget { border: solid 1px lightgray; }
    ''';
  }

  void highlightWidgets(bool enable) {
    querySelectorAllWithShadow('[$idAttribute]').forEach((element) {
      if (enable)
        element.classes.add('highlight-flattery-widget');
      else
        element.classes.remove('highlight-flattery-widget');
    });
  }

  @override
  Element build() => Container(
        children: [
          Checkbox(
            id: 'highlight-flattery-checkbox',
            label: 'Highlight Flattery Widgets',
            onChange: highlightWidgets,
          ),
          Container(children: [
            Text(text: 'Text Widget'),
            Checkbox(id: 'checkbox-example', label: 'CheckBox Widget'),
          ])
            ..style.border = 'solid black 1px'
            ..style.marginTop = '1em'
            ..style.padding = '1em',
        ],
      ).root;
}

main() => document.getElementById('output').append(Gallery().root);
