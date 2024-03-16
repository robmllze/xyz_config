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

// [Step 1] Specify the languages your app will support by creating an enum
//with LocaleEnumMixin.
enum Languages with LocaleEnumMixin {
  ENGLISH_US("en_US"),
  AFRIKAANS_ZA("af_ZA");

  final String localeCode;

  const Languages(this.localeCode);

  ConfigRef get localeRef => ConfigRef(ref: this.localeCode);

  // [Step 6] Add a description getter to the enum that returns the description
  // of the locale from the translations file.
  String get description => "Locales.descriptions.${this.localeCode}";
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
void main() async {
  // [Step 2] Create a function that reads a file and returns its contents as a
  // string.
  final fileReader = (filePath) => File(filePath).readAsString();

  // [Step 3] Create a translations reader that reads YAML files.
  final yamlReader = TranslationsFileReader(
    translationsDirPath: ["translations"], // Optional, defaults to ["translations"].
    fileReader: fileReader,
    fileType: ConfigFileType.YAML, // Optional, defaults to YAML.
  );

  // [Step 4] Read the translations for the supported languages and set the
  // active language.
  await yamlReader.read(
    Languages.ENGLISH_US,
    fileName: "en_US.yaml", // Optional, defaults to the locale code + ".yaml".
  );

  // [Step 5] Use the tr() extension method to translate strings. The text after
  // the || is the default value if the translation is not found. Use the
  // <<<>>> syntax to include the translated string in a larger string.
  print("message.helloworld".tr()); // prints "Hello World!"
  print("message.helloworld||Hi there world!".tr()); // prints "Hello World!"
  print("message.doesntexist||Hi there world!".tr()); // prints "Hi there world!"
  print("<<<message.helloworld>>> is the message!".tr()); // prints "Hello World! is the message!"
  print("Message: <<<message.helloworld||Hello!>>>".tr()); // prints "Message: Hello World!"
}
