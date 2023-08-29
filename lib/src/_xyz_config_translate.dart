// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Utils
//
// TODO: Needs rigorous testing. I don't think the escaping works everywhere.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

part of 'xyz_config.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

extension SplitByLastOccurrenceOf on String {
  /// Splits the string by the last occurrence of [separator].
  List<String> splitByLastOccurrenceOf(String separator) {
    final splitIndex = this.lastIndexOf(separator);
    if (splitIndex == -1) {
      return [this];
    }
    return [this.substring(0, splitIndex), this.substring(splitIndex + separator.length)];
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

extension XyzConfigTranslate on String {
  //
  //
  //

  T? translate<T>([Map<dynamic, dynamic> args = const {}, T? fallback]) {
    try {
      final manager = XyzConfigManager._translationManager!;
      final fields = {...manager._selected!.config._fields, ...args};
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
      final handled = replaceAllPatterns(
        match,
        fields,
        manager.opening,
        manager.closing,
      );
      return let<T>(handled) ?? fallback;
    } catch (_) {}
    return null;
  }

  //
  //
  //

  String tr([Map<dynamic, dynamic> args = const {}]) {
    return custromTr(this, args: args);
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

String custromTr(
  String input, {
  String opening = "(=",
  String closing = ")",
  String delimiter = "||",
  Map<dynamic, dynamic> args = const {},
  List<String> excapeChars = const ["\\", "/"],
}) {
  // Shorten the function.
  String translatePart(String input) {
    return _translatePart(
      input,
      opening,
      closing,
      delimiter,
      args,
      excapeChars,
    );
  }

  // Find all scopes and subscopes enclosed by opening and closing in input.
  final scopes = _findScopes(input, opening, closing, excapeChars);

  var result = scopes.removeLast();
  while (scopes.isNotEmpty) {
    final lastScope = scopes.removeLast();
    final lastScopeTranslated = translatePart(lastScope);
    result = result.replaceAll(lastScope, lastScopeTranslated);
  }
  return translatePart(result);
}

//
//
//

/// ### Example:
///
/// ```dart
/// print(_translatePart("(=hello dude||message)", "(=", ")", "||", {}));  // prints "hello dude"
/// print(_translatePart("hello dude||message", "(=", ")", "||", {"message": "hello world"}));  // prints "hello world"
/// ```
String _translatePart(
  String input,
  String opening,
  String closing,
  String delimiter,
  Map<dynamic, dynamic> args, [
  List<String> excapeChars = const ["\\", "/"],
]) {
  // Remove the opening and closing strings from the input.
  final body = input.startsWith(opening) && input.endsWith(closing)
      ? input.substring(opening.length, input.length - closing.length)
      : input;
  // Split the body by the delimiter.
  final components = _customSplit(body, delimiter, excapeChars);
  // Get the length of the components.
  final length = components.length;
  // Set the key and fallback values based on the number of components.
  var key = "";
  var fallback = "";
  if (length == 1) {
    key = components[0].trim();
    fallback = key;
  } else if (length == 2) {
    key = components[1].trim();
    fallback = components[0];
  } else {
    // Return the original input if theres a syntax error.
    return input;
  }
  // Try and translate the key and return the result or return the the fallback
  // value if the key is not found in the args.
  return key.translate<String>(args, fallback) ?? fallback;
}

//
//
//

/// A custom implementation of [String.split] that supports escaping with
/// [excapeChars].
List<String> _customSplit(
  String input,
  String delimiter, [
  List<String> excapeChars = const ["\\", "/"],
]) {
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

/// Finds all scopes and subscopes enclosed by [opening] and [closing] in
/// [input].
///
/// The last element returned is the outermost scope.
List<String> _findScopes(
  String input,
  String opening,
  String closing, [
  List<String> excapeChars = const ["\\", "/"],
]) {
  final results = <String>[];
  final stack = <int>[];
  // Ensure the input is enclosed with the opening and closing strings.
  final enclosed =
      !input.startsWith(opening) || !input.endsWith(closing) ? "$opening$input$closing" : input;
  // Iterate through the characters of the enclosed input string.
  for (var i = 0; i < enclosed.length; i++) {
    final c = enclosed[i];
    // Skip the next character if an escape character is found.
    if (excapeChars.contains(c)) {
      i++;
    } else
    // If the opening string is found at position i.
    if (enclosed.startsWith(opening, i)) {
      // Push the current index to the stack.
      stack.add(i);
      // Skip to the end of the opening string.
      i += opening.length - 1;
    } else
    // If the closing string is found at position i.
    if (enclosed.startsWith(closing, i) && stack.isNotEmpty) {
      // Get the index of the last opening string from the stack and remove it.
      final startIndex = stack.removeLast();
      // Extract the scope between the opening and closing strings at startIndex.
      final extracted = _extractScope(enclosed, startIndex, opening, closing);
      // Add the extracted scope to the results.
      results.add(extracted);
      // Skip to the end of the closing string.
      i += closing.length - 1;
    }
  }
  return results;
}

//
//
//

/// Extracts a substring (the "scope") from [input] that is enclosed by the
/// [opening] and [closing] strings, starting from the [startIndex] position.
///
/// ### Example:
///
/// ```dart
/// print(_extractNestedString("...(=(=test))...", 3, "(=", ")"));  // prints "(=(=test))"
/// print(_extractNestedString("...(=(=test))...", 5, "(=", ")"));  // prints "(=test)"
/// ```
String _extractScope(
  String input,
  int startIndex,
  String opening,
  String closing,
) {
  // Initialize i to the position immediately after the opening string.
  var i = startIndex + opening.length;
  // openingCount keeps track of the number of opening strings encountered
  // from startIndex to the current i position.
  var openingCount = 1;
  // Iterate through the string until i exceeds the length of the input string.
  while (i < input.length) {
    // When an additional opening string is found within the scope,
    // increment openingCount and shift i to the position after this opening string.
    if (input.startsWith(opening, i)) {
      openingCount++;
      i += opening.length;
    } else
    // If a closing string is found.
    if (input.startsWith(closing, i)) {
      // If openingCount is 1, the function has located the scope.
      if (--openingCount == 0) break;
      // If openingCount is more than 1, it indicates nested scopes and the
      // function continues searching for the closing string corresponding to
      // the opening string at the startIndex position.
      i += closing.length;
    } else {
      // Search the next character if neither an opening nor a closing string
      // is found.
      i++;
    }
  }
  // Return the scope from startIndex to the position of the corresponding
  // closing string.
  return input.substring(startIndex, i + closing.length);
}
