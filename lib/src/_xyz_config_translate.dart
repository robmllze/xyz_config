// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Utils
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

part of 'xyz_config.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

extension XyzConfigTranslate on String {
  //
  //
  //

  T? translate<T>([Map<dynamic, dynamic> args = const {}, T? fallback]) {
    try {
      final manager = XyzConfigManager._translationManager!;
      final fields = manager._selected!.config._fields;
      final match = () {
        try {
          return fields.entries
              .firstWhere((final e) {
                final a = e.key?.toString().toLowerCase();
                final b = this.replaceAll("/", ".").toLowerCase();
                return a == b;
              })
              .value
              .toString();
        } catch (_) {
          return fallback.toString();
        }
      }();
      final handled = _handle(
        match,
        {...fields, ...args},
        manager._opening,
        manager._closing,
      );
      return let<T>(handled) ?? fallback;
    } catch (_) {}
    return null;
  }

  //
  //
  //

  String tr([Map<dynamic, dynamic> args = const {}]) {
    return _tr(this, "(=", ")", "||", args);
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

List<String> _findStringsBetween(
  String input,
  String opening,
  String closing,
) {
  final result = <String>[];
  final stack = <int>[];
  final fixed =
      !input.startsWith(opening) || !input.endsWith(closing) ? "$opening$input$closing" : input;
  for (var i = 0; i < fixed.length; i++) {
    final c = fixed[i];
    if (c == "\\" || c == "/") {
      // If an escape character is found, skip the next character.
      i++;
    } else if (fixed.startsWith(opening, i)) {
      stack.add(i);
      i += opening.length - 1;
    } else if (fixed.startsWith(closing, i) && stack.isNotEmpty) {
      final startIndex = stack.removeLast();
      final extractedString = _extractNestedString(fixed, startIndex, opening, closing);
      result.add(extractedString);
      i += closing.length - 1;
    }
  }

  return result;
}

/// Extracts the string from [input] between the [opening] and [closing] strings
/// starting at [startIndex].
String _extractNestedString(
  String input,
  int startIndex,
  String opening,
  String closing,
) {
  var i = startIndex + opening.length;
  var count = 1;
  while (i < input.length) {
    if (input.startsWith(opening, i)) {
      count++;
      i += opening.length;
    } else if (input.startsWith(closing, i)) {
      if (--count == 0) break;
      i += closing.length;
    } else {
      i++;
    }
  }

  return input.substring(startIndex, i + closing.length);
}

/// This is a custom implementation of [String.split] that supports escaping
/// with [excapeChars].
List<String> _customSplit(
  String input,
  String delimiter, {
  List<String> excapeChars = const ["\\", "/"],
}) {
  final result = <String>[];
  final buffer = StringBuffer();
  var escapeMode = false;
  for (var i = 0; i < input.length; i++) {
    final c = input[i];
    if (escapeMode) {
      buffer.write(c);
      escapeMode = false;
    } else if (excapeChars.contains(c)) {
      escapeMode = true;
    } else if (input.startsWith(delimiter, i)) {
      result.add(buffer.toString());
      buffer.clear();
      i += delimiter.length - 1;
    } else {
      buffer.write(c);
    }
  }

  result.add(buffer.toString());
  return result;
}

//
//
//

String _translatePart(
  String input,
  String opening,
  String closing,
  String delimiter,
  Map<dynamic, dynamic> args,
) {
  final a = input.startsWith(opening) && input.endsWith(closing)
      ? input.substring(opening.length, input.length - closing.length)
      : input;
  final parts = _customSplit(a, delimiter);
  var path = "";
  if (parts.length == 1) {
    path = parts[0].trim();
    return path.translate<String>(args, path) ?? path;
  } else if (parts.length == 2) {
    path = parts[1].trim();
    final fallback = parts[0];
    return path.translate<String>(args, fallback) ?? fallback;
  }
  return input;
}

//
//
//

String _tr(
  String input,
  String opening,
  String closing,
  String delimiter,
  Map<dynamic, dynamic> args,
) {
  String translatePart(String input) {
    return _translatePart(
      input,
      opening,
      closing,
      delimiter,
      args,
    );
  }

  final parts = _findStringsBetween(input, opening, closing);
  if (parts.isEmpty) {
    return translatePart(input);
  }
  var result = parts.last;
  parts.removeLast();
  while (parts.isNotEmpty) {
    final l = parts.last;
    result = result.replaceAll(l, translatePart(l));
    parts.removeLast();
  }
  result = translatePart(result);
  return result;
}

//
//
//

// ignore: camel_case_extensions
extension String_splitByLastOccurrence on String {
  List<String> splitByLastOccurrence(String separator) {
    final splitIndex = this.lastIndexOf(separator);
    if (splitIndex == -1) {
      return [this];
    }
    return [this.substring(0, splitIndex), this.substring(splitIndex + separator.length)];
  }
}
