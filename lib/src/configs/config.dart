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

  /// The fields of the config.
  late final Map fields;

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
    this.fields = {};
  }

  //
  //
  //

  /// Sets the fields of the config from a JSON map.
  void setFields(Map json) {
    this.fields.clear();
    final newFields = expandJson(
      recursiveReplace(json, settings: this.settings),
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
    ReplacePatternsSettings? settings,
  }) {
    final settingsOverride = settings ?? this.settings;
    final expandedArgs = expandJson(args);
    var data = {
      ...this.fields,
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
