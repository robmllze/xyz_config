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

class ConfigFile {
  //
  //
  //

  final ConfigFileRef fileRef;
  final Config config;

  //
  //
  //

  factory ConfigFile(ConfigFileRef fileRef) {
    return ConfigFile.c(
      fileRef,
      Config(),
    );
  }

  //
  //
  //

  const ConfigFile.c(
    this.fileRef,
    this.config,
  );

  //
  //
  //

  Future<bool> process() async {
    switch (this.fileRef.type) {
      case ConfigFileType.JSON:
        await this._processJsonFile();
        break;
      case ConfigFileType.JSONC:
        await this._processJsoncFile();
        break;
      case ConfigFileType.YAML:
        await this._processYamlFile();
        break;
      default:
        return false;
    }
    return true;
  }

  //
  //
  //

  Future<void> _processYamlFile() async {
    final src = await this.fileRef.read?.call();
    if (src != null) {
      final data = loadYaml(src);
      if (data is YamlMap) {
        this.config.setFields(data);
      }
    }
  }

  Future<void> _processJsoncFile() async {
    var src = await this.fileRef.read?.call();
    if (src != null) {
      final result = parseSourceForStringsAndComments(src);
      for (final c in result.multiLineComments) {
        src = src!.replaceAll(c, "");
      }
      for (final c in result.singleLineComments) {
        src = src!.replaceAll(c, "");
      }
      final data = jsonDecode(src!);
      this.config.setFields(data);
    }
  }

  Future<void> _processJsonFile() async {
    final src = await this.fileRef.read?.call();
    if (src != null) {
      final data = jsonDecode(src);
      this.config.setFields(data);
    }
  }
}
