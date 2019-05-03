import 'dart:html';

import 'package:flattery/flattery_widgets.dart';

class Gallery with Widget, ShadowWidget {
  Gallery() {
    stylesheet = '''
    .grid-header { border-bottom: solid 1px black; 
                   background: linear-gradient(cadetblue, lightblue); }
    .grid-cell:not(.grid-header) { margin: 20px; }
    ''';
  }

  @override
  Element build() {
    final yellowRectangle =
        Rectangle(width: '2em', height: '5em', fill: 'yellow');

    return Container(
      children: [
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
                    // first row
                    square('blue'), square('green'), yellowRectangle, //
                  ],
                  [
                    // second row
                    square('red'), square('purple'), yellowRectangle, //
                  ]
                ])
              ],
            ])
          ..style.border = 'solid black 1px'
          ..style.marginTop = '1em'
      ],
    ).root;
  }
}

Widget header(String text) => Text(text)..root.classes.add('grid-header');

Widget square(String color) => Rectangle.square(size: '2em', fill: color);

main() => document.getElementById('output').append(Gallery().root);
