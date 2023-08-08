// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Utils
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

part of 'xyz_config.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class XyzConfigRef<T> {
  final T refCode;
  const XyzConfigRef(this.refCode);

  @override
  String toString() => this.refCode.toString();

  @override
  bool operator ==(final other) => other is XyzConfigRef && other.hashCode == this.hashCode;

  @override
  int get hashCode => this.refCode.hashCode;
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class XyzLocaleRef extends XyzConfigRef {
  //
  //
  //

  final String languageCode;
  final String countryCode;
  String get localeCode => super.refCode;

  //
  //
  //

  XyzLocaleRef(
    this.languageCode,
    this.countryCode,
  ) : super("${languageCode}_$countryCode".toLowerCase());

  //
  //
  //

  factory XyzLocaleRef.fromCode(String localeCode) {
    final parts = localeCode.split("_");
    if (parts.length >= 2) {
      final languageCode = parts[0];
      final countryCode = parts[1];
      return XyzLocaleRef(languageCode, countryCode);
    }
    return XyzLocaleRef("en", "us");
  }
}
