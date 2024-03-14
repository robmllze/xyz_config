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
import 'package:xyz_config/xyz_config.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

void main() async {
  // final configManager = ConfigManager.create(
  //   {
  //     const ConfigRef("test"): const ConfigFileRef(
  //       "test.yaml",
  //       alias: "Test",
  //       type: ConfigFileType.YAML,
  //     ),
  //   },
  //   (path) => File(path).readAsString(),
  // );

  // await configManager.loadFileByPath("test.yaml");

  final fileRef = ConfigFileRef(read: () => File("test.yaml").readAsString());
  final config = Config();
  final configFile = ConfigFile(fileRef, config);

  await TranslationManager().setFile(configFile);

  // final config = Config(
  //   fields: {
  //     "user": {
  //       "name": "Bob",
  //     },
  //   },
  // );

  print("Name <<<user.name||Unknown>>>".tr());

  // cfile.print(
  //   "sadsasd <<<user.name||HELLO>>>".tr(
  //     {
  //       "user": {
  //         "name": "Bob1",
  //       },
  //     },
  //   ),
  // );
}
