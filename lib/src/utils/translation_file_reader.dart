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

import 'package:path/path.dart' as p;

import '/_common.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Provides a way to easily read translation files.
class TranslationFileReader {
  //
  //
  //

  /// A function to read a file, such as `(filePath) => File(filePath).readAsString()` or `(filePath) => rootBundle.loadString(filePath)`.
  final Future<String> Function(String filePath) fileReader;

  /// The type of the files to read.
  final ConfigFileType fileType;

  /// The directory path where the translations are stored.
  final List<String> translationsDirPath;

  //
  //
  //

  const TranslationFileReader({
    required this.fileReader,
    this.fileType = ConfigFileType.YAML,
    this.translationsDirPath = const ["translations"],
  });

  //
  //
  //

  /// Reads a locale file.
  Future<FileConfig> read(
    String localeCode, {
    String? fileName,
  }) async {
    final filePath = p.joinAll([
      ...this.translationsDirPath,
      fileName ?? "$localeCode.${this.fileType.name.toLowerCase()}",
    ]);
    final fileConfig = FileConfig(
      ref: ConfigFileRef(
        ref: localeCode,
        type: this.fileType,
        read: () => this.fileReader(filePath),
      ),
    );
    await TranslationManager().setFileConfig(fileConfig);
    return fileConfig;
  }
}
