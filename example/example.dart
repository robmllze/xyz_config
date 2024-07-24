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

import 'dart:io';

import 'package:xyz_config/_common.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

// Step 1: Create a translations file somewhere and call it something like
// `en_US.yaml`.

// ```yaml
// greetings:
//   HelloWorld: Hello World!
// ```

void main() async {
  // Step 2 - Create a function that reads a file and returns its contents as a
  // string. In Flutter, you'd use the rootBundle.loadString or you can
  // even read remote files using the http package.
  Future<String> fileReader(filePath) => File(filePath).readAsString();

  // Step 3 - Create a translations reader that reads YAML files from the
  // translations/ directory.
  final translationFileReader = TranslationFileReader(
    translationsDirPath: ['translations'],
    fileType: ConfigFileType.YAML,
    fileReader: fileReader,
  );

  // Step 4 - Read the en_US translation and set it as the active translation.
  // In Flutter, you'd want to rebuild your widget tree after setting this.
  await translationFileReader.read('en_us');

  // Step 5 - Use the tr() extension method to translate strings.
  // The text after the || is what will be printed if the translation is missing.
  // Use the <<<>>> syntax to include the translated string in a larger string.

  // No default value, prints 'Hello World!'
  print('greetings.HelloWorld'.tr());

  // Case insensitive, prints 'Hello World!'
  print('Hi there world!||greetings.HELLOWORLD'.tr());

  // Key doesn't exist, prints 'Uhm, hola!'
  print('Uhm, hola!||greetings.doesntexist'.tr());

  // Key exists, prints 'Hello World! is the message!'
  print('<<<greetings.HelloWorld>>> is the message!'.tr());

  // Key exists, prints 'Greeting: Hello World!'
  print('Greeting: <<<Hello there old friend!||greetings.HelloWorld>>>'.tr());
}
