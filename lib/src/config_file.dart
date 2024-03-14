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

extension ProcessConfigExtension on Config {
  // ---------------------------------------------------------------------------
  // YAML
  // ---------------------------------------------------------------------------

  Future<void> _processFromYaml() async {
    final src = await this.getter();
    final yaml = loadYaml(src);
    if (yaml is YamlMap) {
      var temp = recursiveReplace(yaml);
      temp = expandJson(temp);
      this.fields
        ..clear()
        ..addAll(temp);
    }
  }

  // ---------------------------------------------------------------------------
  // JSONC
  // ---------------------------------------------------------------------------

  Future<void> _processFromJsonc() async {
    var src = await this.getter();
    final result = parseSourceForStringsAndComments(src);
    for (final c in result.multiLineComments) {
      src = src.replaceAll(c, "");
    }
    for (final c in result.singleLineComments) {
      src = src.replaceAll(c, "");
    }
    final decoded = jsonDecode(src);
    var temp = recursiveReplace(decoded);
    temp = expandJson(temp);
    this.fields
      ..clear()
      ..addAll(temp);
  }

  // ---------------------------------------------------------------------------
  // JSON
  // ---------------------------------------------------------------------------

  Future<void> _processFromJson() async {
    final src = await this.getter();
    final decoded = jsonDecode(src);
    var temp = recursiveReplace(decoded);
    temp = expandJson(temp);
    this.fields
      ..clear()
      ..addAll(temp);
  }
}
