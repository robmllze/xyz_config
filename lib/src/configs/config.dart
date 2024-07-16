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

  /// The parsed fields of the config.
  late final Map parsedFields;

  // The unparsed data of the config.
  late final Map data;

  //
  //
  //

  final ReplacePatternsSettings settings;

  //
  //
  //

  Config({
    this.ref,
    this.settings = const ReplacePatternsSettings(),
  }) {
    this.parsedFields = {};
    this.data = {};
  }

  //
  //
  //

  /// Sets the fields of the config from a JSON map.
  void setFields(Map data) {
    this.data
      ..clear()
      ..addAll(data);
    this.parsedFields
      ..clear()
      ..addAll(expandJson(recursiveReplace(data, settings: this.settings)));
  }

  //
  //
  //

  /// Maps a string to a value using this config.
  T? map<T>(
    String value, {
    Map<dynamic, dynamic> args = const {},
    T? fallback,
    ReplacePatternsSettings? settings,
  }) {
    final settingsOverride = settings ?? this.settings;
    final expandedArgs = expandJson(args);
    var data = {
      ...this.parsedFields,
      ...expandedArgs,
    };
    var input = _addOpeningAndClosing(
      value,
      opening: settingsOverride.opening,
      closing: settingsOverride.closing,
    );
    final r = replacePatterns(
      input,
      data,
      settings: settingsOverride,
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

String _addOpeningAndClosing(
  String input, {
  required String opening,
  required String closing,
}) {
  var output = input;
  if (!input.contains(opening)) {
    output = '$opening$output';
  }
  if (!input.contains(closing)) {
    output = '$output$closing';
  }
  return output;
}
