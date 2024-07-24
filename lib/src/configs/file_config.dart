//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// 🇽🇾🇿 & Dev
//
// Copyright Ⓒ Robert Mollentze
//
// Licensing details can be found in the LICENSE file in the root directory.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import '/_common.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class FileConfig extends Config<ConfigFileRef> {
  //
  //
  //

  /// Creates a new [FileConfig] instance and reads its associated file.
  static Future<FileConfig> read({
    required ConfigFileRef ref,
    Map<dynamic, dynamic> fields = const {},
    ReplacePatternsSettings settings = const ReplacePatternsSettings(),
  }) async {
    final config = FileConfig(
      ref: ref,
      settings: settings,
    );
    await config.readAssociatedFile();
    return config;
  }

  //
  //
  //

  FileConfig({
    super.ref,
    super.settings,
  });

  //
  //
  //

  /// Reads and processes the associated file.
  Future<bool> readAssociatedFile() async {
    switch (this.ref?.type) {
      case ConfigFileType.JSON:
        await this._readJsonFile();
        break;
      case ConfigFileType.JSONC:
        await this._readJsoncFile();
        break;
      case ConfigFileType.YAML:
        await this._readYamlFile();
        break;
      case ConfigFileType.CSV:
        await this._readCsvFile();
        break;
      default:
        return false;
    }
    return true;
  }

  /// Processes a JSON file.
  Future<void> _readJsonFile() async {
    final src = await this.ref?.read?.call();
    if (src != null) {
      final data = jsonToData(src);
      this.setFields(data);
    }
  }

  /// Processes a JSONC file.
  Future<void> _readJsoncFile() async {
    var src = await this.ref?.read?.call();
    if (src != null) {
      final data = jsoncToData(src);
      this.setFields(data);
    }
  }

  /// Processes a YAML file.
  Future<void> _readYamlFile() async {
    final src = await this.ref?.read?.call();
    if (src != null) {
      final data = yamlToData(src);
      this.setFields(data);
    }
  }

  /// Processes a CSV file.
  Future<void> _readCsvFile() async {
    final src = await this.ref?.read?.call();
    if (src != null) {
      final data = csvToData(src, this.settings);
      this.setFields(data);
    }
  }
}
