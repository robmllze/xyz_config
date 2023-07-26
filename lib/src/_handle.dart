// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Utils
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

part of 'xyz_config.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

dynamic $handle(
  String input,
  Map<dynamic, dynamic> handles,
  String opening,
  String closing,
) {
  final escOpening = RegExp.escape(opening);
  final escClosing = RegExp.escape(closing);
  var copy = input;
  for (final entry in handles.entries) {
    final k = entry.key;
    final v = entry.value;
    final source = "$escOpening$k$escClosing";
    if (input == source) return v;
    final expression = RegExp(source, caseSensitive: false);
    copy = copy.replaceAll(expression, v.toString());
  }
  return copy;
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

extension ReplaceHandles on String {
  String replaceHandles(
    Map<String, dynamic> handles, [
    String opening = "(=",
    String closing = ")",
  ]) {
    return $handle(this, handles, opening, closing).toString();
  }
}
