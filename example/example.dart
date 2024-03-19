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
  final yamlReader = TranslationFileReader(
    translationsDirPath: [
      "translations",
    ],
    fileReader: fileReader,
  );

  // [Step 3] Read the translations for the supported languages and set the
  // active language.
  await yamlReader.read("en_US");

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
}
