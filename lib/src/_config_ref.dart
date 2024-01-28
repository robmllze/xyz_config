//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Config
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

part of 'xyz_config.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class ConfigRef<T> {
  final T refCode;
  const ConfigRef(this.refCode);

  @override
  String toString() => this.refCode.toString();

  @override
  bool operator ==(final other) =>
      other is ConfigRef && other.hashCode == this.hashCode;

  @override
  int get hashCode => this.refCode.hashCode;
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class LocaleRef extends ConfigRef {
  //
  //
  //

  final String languageCode;
  final String countryCode;
  String get localeCode => super.refCode;

  //
  //
  //

  LocaleRef(
    this.languageCode,
    this.countryCode,
  ) : super("${languageCode}_$countryCode".toLowerCase());

  //
  //
  //

  factory LocaleRef.fromCode(String localeCode) {
    final parts = localeCode.split("_");
    if (parts.length >= 2) {
      final languageCode = parts[0];
      final countryCode = parts[1];
      return LocaleRef(languageCode, countryCode);
    }
    return LocaleRef("en", "us");
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

LocaleRef? localeCodeToRef(String localeCode) {
  final parts = localeCode.split("_");
  if (parts.length == 2) {
    return LocaleRef(parts[0], parts[1]);
  }
  return null;
}