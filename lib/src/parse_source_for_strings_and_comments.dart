//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Config
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'dart:convert';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

const _REG_EXP_MULTI_LINE_COMMENT = r"(\/\*([^*]|[\r\n]|(\*+([^*\/]|[\r\n])))*\*+\/)";
const _REG_EXP_SINGLE_LINE_COMMENT = r"\/\/.*";
const _REG_EXP_QUOTED_STRING = r"""(["'])([^\\]*?(?:\\.[^\\]*?)*)\1""";

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class _ParseCSourceForStringsAndCommentsResult {
  final List<String> quotedStrings, multiLineComments, singleLineComments;
  const _ParseCSourceForStringsAndCommentsResult(
    this.quotedStrings,
    this.multiLineComments,
    this.singleLineComments,
  );
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

_ParseCSourceForStringsAndCommentsResult parseCSourceForStringsAndComments(
  String source,
) {
  var buffer = "";
  final cNull = const Utf8Decoder().convert([0]);
  final cNotNewline = RegExp("[^\n]");
  final matchesMultiLineComments = RegExp(_REG_EXP_MULTI_LINE_COMMENT).allMatches(source);
  for (final match in matchesMultiLineComments) {
    final a = match.group(0)!;
    final b = a.replaceAll(cNotNewline, cNull);
    buffer = source.replaceFirst(a, b);
  }
  final matchesQuotedStrings = RegExp(_REG_EXP_QUOTED_STRING).allMatches(buffer);
  for (final match in matchesQuotedStrings) {
    final a = match.group(0)!;
    final b = a.replaceAll(cNotNewline, cNull);
    buffer = buffer.replaceFirst(a, b);
  }
  final matchesSingleLineComments = RegExp(_REG_EXP_SINGLE_LINE_COMMENT).allMatches(buffer);
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
    (final l0) =>
        singleLineComments.cast().firstWhere(
              (final l1) => l1.contains(l0),
              orElse: () => null,
            ) !=
        null,
  );
  return _ParseCSourceForStringsAndCommentsResult(
    List.unmodifiable(quotedStrings),
    List.unmodifiable(multiLineComments),
    List.unmodifiable(singleLineComments),
  );
}
