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

class TranslationManager {
  //
  //
  //

  static ConfigFile? _translationFile;
  static ConfigFile get translationFile => _translationFile!;

  //
  //
  //

  final List<ConfigFile> files;

  //
  //
  //

  factory TranslationManager() {
    return TranslationManager.c(
      List<ConfigFile>.empty(growable: true),
    );
  }

  //
  //
  //

  const TranslationManager.c(this.files);

  //
  //
  //

  Future<void> setFile(ConfigFile file) async {
    final added =
        this.files.firstWhereOrNull((e) => e.fileRef == file.fileRef) != null;
    if (!added) {
      this.files.add(file);
      await file.process();
    }
    _translationFile = file;
  }
}
