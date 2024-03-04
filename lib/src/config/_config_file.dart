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

part of 'config.dart';

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

  const ConfigFile(
    this.fileRef,
    this.config,
  );

  //
  //
  //

  Future<bool> process() async {
    switch (this.fileRef.type) {
      case ConfigFileType.JSON:
        await this.config._processFromJson();
        break;
      case ConfigFileType.JSONC:
        await this.config._processFromJsonc();
        break;
      case ConfigFileType.YAML:
        await this.config._processFromYaml();
        break;
      default:
        return false;
    }
    return true;
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class ConfigFileRef {
  //
  //
  //

  final String path;
  final ConfigFileType type;
  final String? alias;

  //
  //
  //

  const ConfigFileRef(
    this.path, {
    this.type = ConfigFileType.YAML,
    this.alias,
  });
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

enum ConfigFileType {
  JSON,
  JSONC,
  YAML,
}
