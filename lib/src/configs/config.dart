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

import 'package:equatable/equatable.dart';

import '/_common.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// A configuration class, used to map strings to values.
class Config<TConfigRef extends ConfigRef> extends Equatable {
  //
  //
  //

  /// The reference to the config file.
  final TConfigRef? ref;

  /// The fields of the config.
  late final Map fields;

  //
  //
  //

  final String opening;
  final String closing;
  final String separator;
  final String delimiter;

  /// Whether the config keys are case sensitive.
  final bool caseSensitive;

  //
  //
  //

  Config({
    this.ref,
    this.opening = XYZ_CONFIG_DEFAULT_OPENING,
    this.closing = XYZ_CONFIG_DEFAULT_CLOSING,
    this.separator = XYZ_CONFIG_DEFAULT_SEPARATOR,
    this.delimiter = XYZ_CONFIG_DEFAULT_DELIMITER,
    this.caseSensitive = true,
  }) {
    this.fields = {};
  }

  //
  //
  //

  /// Sets the fields of the config from a JSON map.
  void setFields(Map json) {
    this.fields.clear();
    final newFields = expandJson(
      recursiveReplace(
        json,
        opening: this.opening,
        closing: this.closing,
        delimiter: this.delimiter,
        separator: this.separator,
        caseSensitive: this.caseSensitive,
      ),
    );
    this.fields.addAll(newFields);
  }

  //
  //
  //

  /// Maps a string to a value using this config.
  T? map<T>(
    String value, {
    Map<dynamic, dynamic> args = const {},
    T? fallback,
    String? Function(
      String key,
      dynamic suggestedReplacementValue,
      String defaultValue,
    )? callback,
  }) {
    final expandedArgs = expandJson(args);
    var data = {
      ...this.fields,
      ...expandedArgs,
    };
    var input = _addOpeningAndClosing(
      value,
      opening: this.opening,
      closing: this.closing,
    );
    final r = replacePatterns(
      input,
      data,
      opening: this.opening,
      closing: this.closing,
      delimiter: this.delimiter,
      caseSensitive: this.caseSensitive,
      callback: callback,
    );
    final res = let<T>(r) ?? fallback;
    return res;
  }

  //
  //
  //

  @override
  List<Object?> get props => [...?this.ref?.props];
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// The default opening  String.
const XYZ_CONFIG_DEFAULT_OPENING = '<<<';

/// The default closing String.
const XYZ_CONFIG_DEFAULT_CLOSING = '>>>';

/// The default separator  String.
const XYZ_CONFIG_DEFAULT_SEPARATOR = '.';

/// The default delimiter String.
const XYZ_CONFIG_DEFAULT_DELIMITER = '||';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

String _addOpeningAndClosing(
  String input, {
  String opening = XYZ_CONFIG_DEFAULT_OPENING,
  String closing = XYZ_CONFIG_DEFAULT_CLOSING,
}) {
  var output = input;
  if (!input.contains(opening)) {
    output = "$opening$output";
  }
  if (!input.contains(closing)) {
    output = "$output$closing";
  }
  return output;
}
