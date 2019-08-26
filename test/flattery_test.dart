@TestOn('browser')
import 'dart:html';

import 'package:flattery/flattery_widgets.dart';
import 'package:test/test.dart';

main() async {
  group('Simple Widget', () {
    Text textBox;
    setUp(() {
      textBox = Text('')
        ..root.id = 'hello'
        ..text = 'Hey there';
      querySelector('#output').append(textBox.root);
    });

    test('can be added to a HTML document, then removed', () {
      var helloEl = document.getElementById(textBox.root.id);
      expect(helloEl, isA<DivElement>());
      expect(helloEl.text, equals('Hey there'));

      textBox.removeFromDom();

      helloEl = document.getElementById(textBox.root.id);
      expect(helloEl, isNull);
    });
  });

  group('Container', () {
    Container container;
    setUp(() {
      container = Container(children: [
        Text('')
          ..root.id = 'hello'
          ..text = 'First child',
        Text('')
          ..root.id = 'bye'
          ..text = 'Second child'
      ])
        ..root.id = 'container-element';
      querySelector('#output').children = [container.root];
    });

    test('can be added to a HTML document, then removed', () {
      var contEl = document.getElementById(container.id);
      expect(contEl, isA<DivElement>());
      expect(contEl.children, hasLength(2));

      final firstChild = container[0] as Text;
      final secondChild = container[1] as Text;

      expect(firstChild.id, equals('hello'));
      expect(secondChild.id, equals('bye'));

      expect(firstChild.root.attributes[idAttribute], isNotNull);
      expect(secondChild.root.attributes[idAttribute], isNotNull);

      container.removeFromDom();

      expect(document.getElementById(container.id), isNull);
      expect(document.getElementById(firstChild.id), isNull);
      expect(document.getElementById(secondChild.id), isNull);
    });

    test('allows widgets to be added and removed', () {
      container.add(Text('')
        ..root.id = 'new-box'
        ..text = 'new box');

      var contEl = document.getElementById(container.id);
      expect(contEl, isA<DivElement>());
      expect(contEl.children, hasLength(3));

      final newChild = container[2] as Text;

      expect(newChild.root.id, equals('new-box'));
      expect(newChild.text, equals('new box'));
      expect(newChild.root.attributes[idAttribute], isNotNull);

      container.remove(newChild);

      expect(document.getElementById(newChild.id), isNull);
      expect(document.getElementById(container.id), isNotNull);

      container.removeFromDom();

      expect(document.getElementById(newChild.id), isNull);
      expect(document.getElementById(container.id), isNull);
    });

    test('allows widgets to be inserted at first index and removed', () {
      container[0] = Text('')
        ..root.id = 'first-box'
        ..text = 'first box';

      var contEl = document.getElementById(container.id);
      expect(contEl, isA<DivElement>());
      expect(contEl.children, hasLength(2));

      final newChild = container[0] as Text;

      expect(newChild.id, equals('first-box'));
      expect(newChild.text, equals('first box'));
      expect(newChild.root.attributes[idAttribute], isNotNull);

      var secondChild = container[1] as Text;
      expect(secondChild.root.id, equals('bye'));

      container.removeAt(0);

      expect(document.getElementById(newChild.id), isNull);
      expect(document.getElementById(container.id), isNotNull);

      secondChild = container[0] as Text;
      expect(secondChild.root.id, equals('bye'));

      container.removeFromDom();

      expect(document.getElementById(newChild.id), isNull);
      expect(document.getElementById(container.id), isNull);
    });

    test('allows untyped objects to be inserted at any index and removed', () {
      container.addAll([
        'hello world',
        10,
        null,
        Text('')..root.id = 'text-box-0',
        DivElement()..id = 'div-0'
      ]);

      var contEl = document.getElementById(container.id);
      expect(contEl, isA<DivElement>());
      expect(contEl.children, hasLength(7));

      expect(contEl.children.map((c) => c.id).toList(),
          equals(['hello', 'bye', '', '', '', 'text-box-0', 'div-0']));

      expect(container[0], isA<Text>());
      expect(container[1], isA<Text>());
      expect(container[2], equals('hello world'));
      expect(container[3], equals(10));
      expect(container[4], isNull);
      expect(container[5], isA<Text>());
      expect(container[6], isA<DivElement>());

      final box4 = Text('')..root.id = 'text-box-4';
      container[4] = box4;

      expect(
          contEl.children.map((c) => c.id).toList(),
          equals(
              ['hello', 'bye', '', '', 'text-box-4', 'text-box-0', 'div-0']));

      expect(container[0], isA<Text>());
      expect(container[1], isA<Text>());
      expect(container[2], equals('hello world'));
      expect(container[3], equals(10));
      expect(container[4], isA<Text>());
      expect(container[5], isA<Text>());
      expect(container[6], isA<DivElement>());

      container.removeRange(1, 4);

      expect(contEl.children.map((c) => c.id).toList(),
          equals(['hello', 'text-box-4', 'text-box-0', 'div-0']));

      expect(container[0], isA<Text>());
      expect(container[1], isA<Text>());
      expect(container[2], isA<Text>());
      expect(container[3], isA<DivElement>());

      box4.removeFromDom();

      expect(contEl.children.map((c) => c.id).toList(),
          equals(['hello', 'text-box-0', 'div-0']));

      final box0 = container[1] as Text;
      final div0 = container[2] as DivElement;

      container.remove(box0);

      expect(contEl.children.map((c) => c.id).toList(),
          equals(['hello', 'div-0']));

      // delete everything else
      container.removeWhere((e) => true);

      expect(contEl.children, isEmpty);
      expect(document.getElementById(box4.id), isNull);
      expect(document.getElementById(box0.id), isNull);
      expect(document.getElementById(div0.id), isNull);

      container.removeFromDom();

      expect(document.getElementById(container.id), isNull);
    });

    test('can be used as a List, sorted, with results reflected in the DOM',
        () {
      final names = const [
        'Walhberct',
        'Alcmene',
        'Maximinus',
        'Ferdinand',
        'Fridwald',
      ];
      final sortedNames = const [
        'Alcmene',
        'Ferdinand',
        'Fridwald',
        'Maximinus',
        'Walhberct',
      ];

      container.clear();
      container.addAll(names);

      var contEl = document.getElementById(container.id);
      expect(contEl, isA<DivElement>());
      expect(contEl.children, hasLength(5));
      expect(contEl.children.map((e) => e.text), equals(names));

      container.sort();

      expect(contEl.children.map((e) => e.text), equals(sortedNames));
    });

    test('can see when an element is removed from the DOM directly', () async {
      var contEl = document.getElementById(container.id);
      expect(contEl.children, hasLength(2));

      final child = container[0] as Text;
      child.removeFromDom();

      expect(contEl.children, hasLength(1));
      expect(container, hasLength(1));
      expect(document.getElementById(child.id), isNull);

      final firstChild = container[0] as Text;

      expect(firstChild.id, equals('bye'));

      // the flatterIds are updated asynchronously, so we schedule the check
      // in the event loop via a Future().
      final flatteryIds = await Future(() => container.flatteryIds);

      expect(flatteryIds, equals([firstChild.root.getAttribute(idAttribute)]));
    });

    test('can see when an element is added indirectly', () async {
      var contEl = document.getElementById(container.id);
      expect(contEl.children, hasLength(2));

      final div = DivElement()..id = 'new-child';
      contEl.append(div);

      // the flatterIds are updated asynchronously, so we schedule the check
      // in the event loop via a Future().
      final flatteryIds = await Future(() => container.flatteryIds);

      expect(contEl.children, hasLength(3));
      expect(container, hasLength(3));
      expect(flatteryIds, hasLength(3));
      expect(container[0], isA<Text>());
      expect(container[1], isA<Text>());
      expect(div.getAttribute(idAttribute), isNotNull);
      expect(flatteryIds, contains(div.getAttribute(idAttribute)));

      // the new Element was added via the DOM, so its item must be null
      expect(container[2], isNull);
    });

    test('can remove Widget by equality', () {
      container.clear();
      container.add(_ExampleSimpleTypeWidget('hello'));
      container.add(_ExampleSimpleTypeWidget('bye'));

      expect(container, hasLength(2));
      expect(container[0], isA<_ExampleSimpleTypeWidget>());
      final widget = container[0] as Widget;

      container.remove(_ExampleSimpleType('hello'));

      expect(document.getElementById(widget.id), isNull);

      expect(container, hasLength(1));
      expect(container, isNot(contains(widget)));
      expect(container[0], isA<_ExampleSimpleTypeWidget>());
      final widget2 = container[0] as Widget;

      container.remove(_ExampleSimpleType('bye'));

      expect(document.getElementById(widget2.id), isNull);
      expect(container, isEmpty);
    });
  });
}

class _ExampleSimpleType {
  String value;

  _ExampleSimpleType(this.value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ExampleSimpleType && value == other.value;

  @override
  int get hashCode => value.hashCode;
}

class _ExampleSimpleTypeWidget extends _ExampleSimpleType
    with Widget, ShadowWidget {
  _ExampleSimpleTypeWidget(String value) : super(value);

  @override
  Element build() => Element.div()..text = value;
}
