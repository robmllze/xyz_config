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

import 'dart:io';

import 'package:xyz_config/_common.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

void main() async {
  // [Step 1] Create a function that reads a file and returns its contents as a
  // string.
  final fileReader = (filePath) => File(filePath).readAsString();

  // [Step 2] Create a translations reader that reads YAML files.
  final yamlReader = TranslationsFileReader(
    translationsDirPath: [
      "translations",
    ],
    fileReader: fileReader,
  );

  // [Step 3] Read the translations for the supported languages and set the
  // active language.
  await yamlReader.read(
    SampleLocale.ENGLISH_US,
    fileName: "en_US.yaml",
  );

  // [Step 4] Rebuild your widget tree from the root to update the UI with the
  // new translations.

  // [Step 5] Use the tr() extension method to translate strings. The text after
  // the || is the default value if the translation is not found. Use the
  // <<<>>> syntax to include the translated string in a larger string.

  // prints "Hello World!"
  print("message.helloworld".tr());

  // prints "Hello World!"
  print("message.helloworld||Hi there world!".tr());

  // prints "Hi there world!"
  print("message.doesntexist||Hi there world!".tr());

  // prints "Hello World! is the message!"
  print("<<<message.helloworld>>> is the message!".tr());

  // prints "Message: Hello World!"
  print("Message: <<<message.helloworld||Hello!>>>".tr());

  // prints "English (US)
  print("Locales.descriptions.${SampleLocale.ENGLISH_US.localeCode}".tr());
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

// [Step 6] You can create your own locale enum by extending the LocaleEnumMixin
// and defining your own locales. Then you can use this instead of SampleLocale,
// which was just included for demonstration purposes.
enum Locale with LocaleEnumMixin {
  ENGLISH_US("en_US", "English (US)"),
  AFRIKAANS_ZA("af_ZA", "Afrikaans (ZA)");

  final String localeCode;
  final String localeDescription;

  const Locale(
    this.localeCode,
    this.localeDescription,
  );

  ConfigRef get localeRef => ConfigRef(ref: this.localeCode);
}
