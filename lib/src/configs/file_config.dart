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

class FileConfig extends Config<ConfigFileRef> {
  //
  //
  //

  /// Creates a new [FileConfig] instance and reads its associated file.
  static Future<FileConfig> read({
    required ConfigFileRef ref,
    Map<dynamic, dynamic> fields = const {},
    String opening = XYZ_CONFIG_DEFAULT_OPENING,
    String closing = XYZ_CONFIG_DEFAULT_CLOSING,
    String separator = XYZ_CONFIG_DEFAULT_SEPARATOR,
    String delimiter = XYZ_CONFIG_DEFAULT_DELIMITER,
  }) async {
    final config = FileConfig(
      ref: ref,
      opening: opening,
      closing: closing,
      separator: separator,
      delimiter: delimiter,
    );
    await config.readAssociatedFile();
    return config;
  }

  //
  //
  //

  FileConfig({
    super.ref,
    super.opening = XYZ_CONFIG_DEFAULT_OPENING,
    super.closing = XYZ_CONFIG_DEFAULT_CLOSING,
    super.separator = XYZ_CONFIG_DEFAULT_SEPARATOR,
    super.delimiter = XYZ_CONFIG_DEFAULT_DELIMITER,
    super.caseSensitive,
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

  /// Processes a YAML file.
  Future<void> _readYamlFile() async {
    final src = await this.ref?.read?.call();
    if (src != null) {
      final data = loadYaml(src);
      if (data is YamlMap) {
        this.setFields(data);
      }
    }
  }

  /// Processes a JSONC file.
  Future<void> _readJsoncFile() async {
    var src = await this.ref?.read?.call();
    if (src != null) {
      final result = parseSourceForStringsAndComments(src);
      for (final c in result.multiLineComments) {
        src = src!.replaceAll(c, "");
      }
      for (final c in result.singleLineComments) {
        src = src!.replaceAll(c, "");
      }
      final data = jsonDecode(src!);
      this.setFields(data);
    }
  }

  /// Processes a JSON file.
  Future<void> _readJsonFile() async {
    final src = await this.ref?.read?.call();
    if (src != null) {
      final data = jsonDecode(src);
      this.setFields(data);
    }
  }

  /// Processes a CSV file.
  Future<void> _readCsvFile() async {
    final src = await this.ref?.read?.call();
    if (src != null) {
      final csv = csvToMap(src);
      final data = csv.map((key, value) {
        if (value.length == 2) {
          return MapEntry(value[0], value[1]);
        } else if (value.length > 2) {
          return MapEntry(
            value.sublist(0, value.length - 1).join(this.separator),
            value.last,
          );
        } else {
          return const MapEntry(null, null);
        }
      }).nonNulls;
      this.setFields(data);
    }
  }
}
