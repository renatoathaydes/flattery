import 'dart:math' show Random;

const List<int> _characters = [
  97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, //
  112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122
];

final _rand = Random();

/// Generate a random String with a certain length.
///
/// The String will only contain characters 'a' to 'z'.
String randomString({int length = 12}) {
  assert(length > 0);
  final codeUnits = List.generate(
      length, (_) => _characters[_rand.nextInt(_characters.length)]);
  return String.fromCharCodes(codeUnits);
}

/// Return the value at the given index in the given list if it is within
/// bounds and not null, otherwise return the provided defaultValue.
T valueAt<T>(List<T> list, int index, T defaultValue) {
  if (index < list.length) {
    final value = list[index];
    if (value != null) {
      return value;
    }
  }
  return defaultValue;
}
