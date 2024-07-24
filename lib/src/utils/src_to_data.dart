//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// 🇽🇾🇿 & Dev
//
// Copyright Ⓒ Robert Mollentze
//
// Licensing details can be found in the LICENSE file in the root directory.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import '/_common.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Converts raw JSON data to a key-value map.
Map<String, dynamic> jsonToData(String src) {
  try {
    return letMap<String, dynamic>(jsonDecode(src))!;
  } catch (_) {
    return {'error': 'Failed to load JSON file.'};
  }
}

/// Converts raw JSONC data to a key-value map.
Map<String, dynamic> jsoncToData(String src) {
  final result = parseSourceForStringsAndComments(src);
  for (final c in result.multiLineComments) {
    src = src.replaceAll(c, '');
  }
  for (final c in result.singleLineComments) {
    src = src.replaceAll(c, '');
  }

  try {
    return letMap<String, dynamic>(jsonDecode(src))!;
  } catch (_) {
    return {'error': 'Failed to load JSONC file.'};
  }
}

/// Converts raw YAML data to a key-value map.
Map<String, dynamic> yamlToData(String src) {
  try {
    return letMap<String, dynamic>(loadYaml(src))!;
  } catch (_) {
    return {'error': 'Failed to load YAML file.'};
  }
}

/// Converts raw CSV data to a key-value map.
Map<String, dynamic> csvToData(
  String src, [
  ReplacePatternsSettings settings = const ReplacePatternsSettings(),
]) {
  try {
    final csv = csvToMap(src);
    final entries = csv.entries.map((e) {
      final value = e.value;
      if (value.length == 2) {
        return MapEntry(value[0], value[1]);
      } else if (value.length > 2) {
        return MapEntry(
          value.sublist(0, value.length - 1).join(settings.separator),
          value.last,
        );
      } else {
        return null;
      }
    }).nonNulls;
    return Map<String, dynamic>.fromEntries(entries);
  } catch (_) {
    return {'error': 'Failed to load CSV file.'};
  }
}
