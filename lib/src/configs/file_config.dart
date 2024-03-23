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

  /// Processes a YAML file.
  Future<void> _readYamlFile() async {
    final src = await this.ref?.read?.call();
    if (src != null) {
      dynamic data;
      try {
        data = loadYaml(src) as YamlMap;
      } catch (_) {
        data = {'error': 'Failed to load YAML file.'};
      }
      this.setFields(data);
    }
  }

  /// Processes a JSONC file.
  Future<void> _readJsoncFile() async {
    var src = await this.ref?.read?.call();
    if (src != null) {
      final result = parseSourceForStringsAndComments(src);
      for (final c in result.multiLineComments) {
        src = src!.replaceAll(c, '');
      }
      for (final c in result.singleLineComments) {
        src = src!.replaceAll(c, '');
      }
      dynamic data;
      try {
        data = data = jsonDecode(src!);
      } catch (_) {
        data = {'error': 'Failed to load JSONC file.'};
      }
      this.setFields(data);
    }
  }

  /// Processes a JSON file.
  Future<void> _readJsonFile() async {
    final src = await this.ref?.read?.call();
    if (src != null) {
      dynamic data;
      try {
        data = data = jsonDecode(src);
      } catch (_) {
        data = {'error': 'Failed to load JSON file.'};
      }
      this.setFields(data);
    }
  }

  /// Processes a CSV file.
  Future<void> _readCsvFile() async {
    final src = await this.ref?.read?.call();
    if (src != null) {
      dynamic data;
      try {
        final csv = csvToMap(src);
        data = csv.map((key, value) {
          if (value.length == 2) {
            return MapEntry(value[0], value[1]);
          } else if (value.length > 2) {
            return MapEntry(
              value.sublist(0, value.length - 1).join(this.settings.separator),
              value.last,
            );
          } else {
            return const MapEntry(null, null);
          }
        }).nonNulls;
      } catch (_) {
        data = {'error': 'Failed to load CSV file.'};
      }
      this.setFields(data);
    }
  }
}
