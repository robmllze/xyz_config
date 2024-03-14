//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// X|Y|Z & Dev
//
// Copyright Ⓒ Robert Mollentze, xyzand.dev
//
// Licensing details can be found in the LICENSE file in the root directory.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import '/_common.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class Config {
  //
  //
  //

  final ConfigRef? ref;
  final Map fields;
  final String opening;
  final String closing;
  final String separator;
  final String delimiter;

  //
  //
  //

  factory Config({
    ConfigRef? ref,
    String opening = "<<<",
    String closing = ">>>",
    String separator = ".",
    String delimiter = "||",
  }) {
    return Config.c(
      ref: ref,
      fields: {},
      opening: opening,
      closing: closing,
      separator: separator,
      delimiter: delimiter,
    );
  }

  //
  //
  //

  const Config.c({
    this.ref,
    required this.fields,
    this.opening = "<<<",
    this.closing = ">>>",
    this.separator = ".",
    this.delimiter = "||",
  });

  //
  //
  //

  void setFields(Map value) {
    var temp = recursiveReplace(value);
    this.fields.clear();
    this.fields.addAll(expandJson(temp));
  }

  //
  //
  //

  T? map<T>(
    String input, {
    Map<dynamic, dynamic> args = const {},
    T? fallback,
    String? Function(String, dynamic, String?)? onReplace,
  }) {
    final expandedArgs = expandJson(args);
    final data = {
      ...this.fields,
      ...expandedArgs,
    };
    final r = replaceAllPatterns(
      input,
      data,
      opening: this.opening,
      closing: this.closing,
      delimiter: this.delimiter,
      onReplace: onReplace,
    );
    final res = let<T>(r) ?? fallback;
    return res;
  }
}
