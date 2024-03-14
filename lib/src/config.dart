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
  var _fields = {};
  final String opening;
  final String closing;
  final String separator;
  final String delimiter;

  //
  //
  //

  Config({
    this.ref,
    Map fields = const {},
    this.opening = "<<<",
    this.closing = ">>>",
    this.separator = ".",
    this.delimiter = "||",
  }) {
    this.fields = fields;
  }

  //
  //
  //

  Map get fields => _fields;

  set fields(Map value) {
    var temp = recursiveReplace(value);
    this._fields = expandJson(temp);
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
      ...this._fields,
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
