import 'dart:html' show Element, DivElement, document;

import 'package:flattery/flattery_widgets.dart';

class Gallery with Widget, ShadowWidget {
  Gallery() {
    stylesheet = '''
    .highlight-flattery-widget { border: solid 1px lightgray; }
    ''';
  }

  void highlightWidgets(bool enable) {
    querySelectorAllWithShadow('.flattery-widget').forEach((element) {
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
            div(Text(text: 'Text Widget')),
            div(Checkbox(id: 'checkbox-example', label: 'CheckBox Widget')),
            div(Button(text: 'Button Widget')),
            div(Row(justify: JustifyContent.spaceEvenly, children: [
              Text(text: 'This is'),
              Text(text: 'a Row Widget'),
              Text(text: 'with 4 Text items'),
              Text(text: 'spaced evenly'),
            ]))
          ])
            ..style.border = 'solid black 1px'
            ..style.marginTop = '1em'
            ..style.padding = '1em',
        ],
      ).root;
}

Element div(Widget w) => DivElement()..append(w.root);

main() => document.getElementById('output').append(Gallery().root);