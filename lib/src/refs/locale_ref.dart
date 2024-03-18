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

/// A reference to a locale, such as Australian English.
class LocaleRef extends ConfigRef<String, Type> {
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
  ) : super(
          ref: "${languageCode.toLowerCase()}_${countryCode.toUpperCase()}",
          type: LocaleRef,
        );

  //
  //
  //

  /// Creates a new [LocaleRef] from a [localeCode].
  factory LocaleRef.fromCode(String localeCode) {
    final parts = localeCode.split("_");
    if (parts.length == 2) {
      final languageCode = parts[0];
      final countryCode = parts[1];
      return LocaleRef(languageCode, countryCode);
    }
    return SampleLocale.ENGLISH_US.localeRef;
  }

  //
  //
  //

  static LocaleRef? tryFromCode(String localeCode) {
    final parts = localeCode.split("_");
    if (parts.length == 2) {
      return LocaleRef(parts[0], parts[1]);
    }
    return null;
  }

  //
  //
  //

  String get localeCode => super.ref!;
}
