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

/// A sample locale enum. You may wish to replace this with your own locale
/// enum.
enum SampleLocale with AppLocaleEnumMixin {
  //
  //
  //

  /// US English locale.
  ENGLISH_US("en_US", "English (US)"),

  /// UK English locale.
  ENGLISH_UK("en_GB", "English (UK)"),

  /// Afrikaans in South Africa locale.
  AFRIKAANS_ZA("af_ZA", "Afrikaans (ZA)"),

  /// Standard German locale.
  GERMAN_DE("de_DE", "German (DE)"),

  /// Austrian German locale.
  GERMAN_AT("de_AT", "German (AT)"),

  /// European Spanish locale.
  SPANISH_ES("es_ES", "Spanish (ES)"),

  /// Mexican Spanish locale.
  SPANISH_MX("es_MX", "Spanish (MX)"),

  /// Standard French locale.
  FRENCH_FR("fr_FR", "French (FR)"),

  /// Canadian French locale.
  FRENCH_CA("fr_CA", "French (CA)"),

  /// Standard Italian locale.
  ITALIAN_IT("it_IT", "Italian (IT)"),

  /// Japanese locale.
  JAPANESE_JP("ja_JP", "Japanese (JP)"),

  /// Korean locale.
  KOREAN_KR("ko_KR", "Koran (KR)"),

  /// Russian locale.
  RUSSIAN_RU("ru_RU", "Russian (RU)"),

  /// Simplified Chinese (Mainland China) locale.
  CHINESE_CN("zh_CN", "Chinese (CN)"),

  /// Traditional Chinese (Taiwan) locale.
  CHINESE_TW("zh_TW", "Chinese (TW)"),

  /// Hindi locale.
  HINDI_IN("hi_IN", "Hindi (IN)"),

  /// European Portuguese locale.
  PORTUGUESE_PT("pt_PT", "Portuguese (PT)"),

  /// Brazilian Portuguese locale.
  PORTUGUESE_BR("pt_BR", "Portuguese (BR)"),

  /// Saudi Arabian Arabic locale.
  ARABIC_SA("ar_SA", "Arabic (SA)"),

  /// Egyptian Arabic locale.
  ARABIC_EG("ar_EG", "Arabic (EG"),

  /// Hebrew locale.
  HEBREW_IL("he_IL", "Hebrew (IL)"),

  /// Persian (Farsi) locale.
  PERSIAN_IR("fa_IR", "Farsi (IR)"),

  /// Turkish locale.
  TURKISH_TR("tr_TR", "Turkish (TR)"),

  /// Dutch locale.
  DUTCH_NL("nl_NL", "Dutch (NL)"),

  /// Swedish locale.
  SWEDISH_SE("sv_SE", "Swedish (SE)"),

  /// Polish locale.
  POLISH_PL("pl_PL", "Polish (PL)"),

  /// Norwegian Bokmål locale.
  NORWEGIAN_NO("nb_NO", "Norwegian Bokmål (NO)"),

  /// Norwegian Nynorsk locale.
  NORWEGIAN_NN("nn_NO", "Norwegian Nynorsk (NO)"),

  /// Finnish locale.
  FINNISH_FI("fi_FI", "Finnish (FI)"),

  /// Danish locale.
  DANISH_DK("da_DK", "Danish (DK)"),

  /// Greek locale.
  GREEK_GR("el_GR", "Greek (GR)"),

  /// Hungarian locale.
  HUNGARIAN_HU("hu_HU", "Hungarian (HU)"),

  /// Czech locale.
  CZECH_CZ("cs_CZ", "Czech (CZ)"),

  /// Slovak locale.
  SLOVAK_SK("sk_SK", "Slovak (SK)"),

  /// Romanian locale.
  ROMANIAN_RO("ro_RO", "Romanian (RO)"),

  /// Bulgarian locale.
  BULGARIAN_BG("bg_BG", "Bulgarian (BG)"),

  /// Ukrainian locale.
  UKRAINIAN_UA("uk_UA", "Ukrainian (UA)");

  //
  //
  //

  final String _localeCode;
  final String _defaultDescription;

  //
  //
  //

  const SampleLocale(
    this._localeCode,
    this._defaultDescription,
  );

  //
  //
  //

  @override
  String get localeCode => this._localeCode;

  @override
  LocaleRef get localeRef => LocaleRef.fromCode(this.localeCode);

  @override
  String get localeDescription => "${this._defaultDescription}||Locales.${this.name}".tr();
}
