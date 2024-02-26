//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Config
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'config_ref.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class LocaleRef extends ConfigRef {
  //
  //
  //

  /// The language code, such as "en".
  final String languageCode;

  /// The country code, such as "US".
  final String countryCode;

  //
  //
  //

  /// Creates a new [LocaleRef] from a [languageCode] and a [countryCode].
  LocaleRef(
    this.languageCode,
    this.countryCode,
  ) : super("${languageCode}_$countryCode".toLowerCase());

  //
  //
  //

  /// Creates a new [LocaleRef] from a [localeCode].
  factory LocaleRef.fromCode(String localeCode) {
    final parts = localeCode.split("_");
    if (parts.length >= 2) {
      final languageCode = parts[0];
      final countryCode = parts[1];
      return LocaleRef(languageCode, countryCode);
    }
    return LocaleRef("en", "us");
  }

  //
  //
  //

  String get localeCode => super.refCode;
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Returns a [LocaleRef] from a [localeCode], or null if the [localeCode] is
/// badly formatted.
LocaleRef? localeCodeToRef(String localeCode) {
  final parts = localeCode.split("_");
  if (parts.length == 2) {
    return LocaleRef(parts[0], parts[1]);
  }
  return null;
}