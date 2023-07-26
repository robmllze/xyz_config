// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Config Example
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

// ignore_for_file: unused_local_variable, omit_local_variable_types

import 'package:xyz_config/xyz_config.dart';

import 'dart:io';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

void main() async {
  final managerLocal = XyzConfigManager.create(
    {
      const XyzConfigRef("test"): const XyzConfigFileRef(
        "test.yaml",
        alias: "Test",
        type: XyzConfigFileType.YAML,
      ),
    },
    (final path) => File(path).readAsString(),
  );

  await managerLocal.loadFileByPath("test.yaml");

  // print("(=user.name)".replaceHandles({"user.name": "WORKING!!!"}));
  // print($handle("(=user.name))", {"user.name": "WORKING!!!"}, "(=", ")"));
  // print("Joseph||user.middle-names.0".tr());
}
