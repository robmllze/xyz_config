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

  final ConfigRef configRef;
  final Future<String> Function() getter;
  final String opening;
  final String closing;
  final String separator;
  final String delimiter;

  //
  //
  //

  Config._(
    this.configRef,
    this.getter,
    this.opening,
    this.closing,
    this.separator,
    this.delimiter,
  );

  //
  //
  //

  final Map<dynamic, dynamic> fields = {};

  //
  //
  //

  factory Config(
    ConfigRef configRef,
    Future<String> Function() getter, {
    String opening = "<<<",
    String closing = ">>>",
    String separator = ".",
    String delimiter = "||",
  }) {
    return Config._(
      configRef,
      getter,
      opening,
      closing,
      separator,
      delimiter,
    );
  }
}
