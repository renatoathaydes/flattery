import 'dart:html';

import 'package:webwidgets/src/widgets.dart';

main() {

  TextBox.create()
    ..root.id = 'hello'
    ..style.border = 'solid gray 2px'
    ..style.fontSize = '4em'
    ..style.maxWidth = '10em'
    ..text = 'This is a TextBox'
    ..appendTo(querySelector('#output'));
}
