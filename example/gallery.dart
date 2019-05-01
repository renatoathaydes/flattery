import 'dart:html' show Element, DivElement, document;

import 'package:flattery/flattery_widgets.dart';

class Gallery with Widget, ShadowWidget {
  Gallery() {
    stylesheet = '''
    .highlight-flattery-widget { border: solid 1px lightgray; }
    ''';
  }

  void highlightWidgets(bool enable) {
    querySelectorAllWithShadow('.flattery-widget').forEach((element) async {
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
          Grid(
              //
              columnWidths: [
                '10em', 'auto' //
              ],
              rowGap: '10px',
              children: [
                [
                  header('Widget Type'),
                  header('Example')..style.borderLeft = 'solid 1px black'
                ],
                [Text('Text'), Text('I am a Text Widget')],
                [
                  Text('Checkbox'),
                  Checkbox(id: 'checkbox-example', label: 'Click to toggle')
                ],
                [Text('Button'), Button(text: 'Click me!')],
                [
                  Text('Row'),
                  Row(justify: JustifyContent.spaceEvenly, children: [
                    Text('This is'),
                    Text('a Row'),
                    Text('with 4 Text items'),
                    Text('spaced evenly'),
                  ])
                ],
                [Text('Rectangle'), Rectangle(fill: 'red', left: '2em')],
                [
                  Text('Grid'),
                  Grid(columnWidths: [
                    '3em', '3em', '5em' //
                  ], rowHeights: [
                    '3em', '3em' //
                  ], children: [
                    [
                      square('blue'),
                      square('green'),
                      Rectangle(width: '2em', height: '5em', fill: 'yellow')
                    ],
                    [square('red'), square('purple')]
                  ])
                ],
              ])
            ..style.border = 'solid black 1px'
            ..style.marginTop = '1em'
        ],
      ).root;
}

Widget header(String text) => Text(text)
  ..style.backgroundColor = 'lightgray'
  ..style.borderBottom = 'black solid 1px';

Widget square(String color) => Rectangle.square(size: '2em', fill: color);

main() => document.getElementById('output').append(Gallery().root);
