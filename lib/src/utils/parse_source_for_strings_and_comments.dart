//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// 🇽🇾🇿 & Dev
//
// Copyright Ⓒ Robert Mollentze, xyzand.dev
//
// Licensing details can be found in the LICENSE file in the root directory.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'dart:convert';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Extracts all quoted strings and comments from [source].
ParseSourceForStringsAndCommentsResult parseSourceForStringsAndComments(
  String source,
) {
  var buffer = '';
  final cNull = const Utf8Decoder().convert([0]);
  final cNotNewline = RegExp('[^\n]');
  final matchesMultiLineComments =
      RegExp(_REG_EXP_MULTI_LINE_COMMENT).allMatches(source);
  for (final match in matchesMultiLineComments) {
    final a = match.group(0)!;
    final b = a.replaceAll(cNotNewline, cNull);
    buffer = source.replaceFirst(a, b);
  }
  final matchesQuotedStrings =
      RegExp(_REG_EXP_QUOTED_STRING).allMatches(buffer);
  for (final match in matchesQuotedStrings) {
    final a = match.group(0)!;
    final b = a.replaceAll(cNotNewline, cNull);
    buffer = buffer.replaceFirst(a, b);
  }
  final matchesSingleLineComments =
      RegExp(_REG_EXP_SINGLE_LINE_COMMENT).allMatches(buffer);
  final multiLineComments = <String>[];
  for (final match in matchesMultiLineComments) {
    multiLineComments.add(source.substring(match.start, match.end));
  }
  final quotedStrings = <String>[];
  for (final match in matchesQuotedStrings) {
    quotedStrings.add(source.substring(match.start, match.end));
  }
  final singleLineComments = <String>[];
  for (final match in matchesSingleLineComments) {
    singleLineComments.add(source.substring(match.start, match.end));
  }
  quotedStrings.removeWhere(
    (a) =>
        singleLineComments.cast().firstWhere(
              (b) => b.contains(a),
              orElse: () => null,
            ) !=
        null,
  );
  return ParseSourceForStringsAndCommentsResult(
    List.unmodifiable(quotedStrings),
    List.unmodifiable(multiLineComments),
    List.unmodifiable(singleLineComments),
  );
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

const _REG_EXP_MULTI_LINE_COMMENT =
    r'(\/\*([^*]|[\r\n]|(\*+([^*\/]|[\r\n])))*\*+\/)';
const _REG_EXP_SINGLE_LINE_COMMENT = r'\/\/.*';
const _REG_EXP_QUOTED_STRING = r'''(["'])([^\\]*?(?:\\.[^\\]*?)*)\1''';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// The result of [parseSourceForStringsAndComments].
class ParseSourceForStringsAndCommentsResult {
  //
  //
  //

  final List<String> quotedStrings;
  final List<String> multiLineComments;
  final List<String> singleLineComments;

  //
  //
  //

  const ParseSourceForStringsAndCommentsResult(
    this.quotedStrings,
    this.multiLineComments,
    this.singleLineComments,
  );
}
