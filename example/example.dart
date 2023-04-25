// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Config Example
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

// ignore_for_file: unused_local_variable, omit_local_variable_types

import 'package:xyz_config/xyz_config.dart';

import 'dart:io';
import 'package:http/http.dart' as http;

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

void main() async {
  // ---------------------------------------------------------------------------

  // Step 1: Create a XyzConfigManager object.
  final managerLocal = XyzConfigManager.create(
    // Step 2: Specify all your configurations.
    {
      // 1.
      const XyzConfigRef("test"): const XyzConfigFileRef(
        "test.yaml", // file path to this configuration
        alias: "Test", // give it some name
        type: XyzConfigFileType.YAML, // type of file
      ),
      // 2.
      XyzLocaleRef("AU", "en"): const XyzConfigFileRef(
        "translations/AU-en.yaml",
        alias: "English (AU)",
      ),
      // 3.
      XyzLocaleRef("UK", "en"): const XyzConfigFileRef(
        "translations/UK-en.jsonc",
        alias: "English (UK)",
        type: XyzConfigFileType.JSONC,
      ),
      // 4.
      XyzLocaleRef("US", "en"): const XyzConfigFileRef(
        "translations/US-en.json",
        alias: "English (US)",
        type: XyzConfigFileType.JSON,
      ),
      // 5.
      "pubspec.yaml": const XyzConfigFileRef("pubspec.yaml"),
    },
    // Step 3. Specify how the configurations should be loaded.
    (final path) => File(path).readAsString(),
  );

  // ---------------------------------------------------------------------------

  final managerRemote = XyzConfigManager.create(
    {
      XyzLocaleRef("AU", "en"): const XyzConfigFileRef(
        "https://firebasestorage.googleapis.com/v0/b/xyz-engine.appspot.com/o/AU-en.yaml?alt=media&token=eee6fd63-e6b7-4e14-80f2-c63b059d3bd5",
        alias: "English (AU)",
      ),
    },
    (final path) async => await getFromUri(path) ?? "",
  );

  // ---------------------------------------------------------------------------

  managerRemote.selectAsTranslationManager();

  // ---------------------------------------------------------------------------

  print("XYZ CONFIG EXAMPLE");

  // ---------------------------------------------------------------------------

  // Iterate through configuration refs.
  for (final locale in [
    XyzLocaleRef("AU", "en"),
    XyzLocaleRef("UK", "en"),
    XyzLocaleRef("US", "en"),
    "pubspec.yaml",
  ]) {
    XyzConfigFile? file;
    print("\n----------------------------------------------------------------\n");

    // Load the configuration files.
    if (locale == XyzLocaleRef("AU", "en")) {
      file = await managerRemote.loadFileByConfigRef(locale);
    } else {
      file = await managerLocal.loadFileByConfigRef(locale);
    }

    // Get and print some info...
    final path = file?.fileRef.path;
    print("Path: $path\n");
    final type = file?.fileRef.type;
    print("Type: $type\n");
    final alias = file?.fileRef.alias;
    print("Alias: $alias\n");
    final fields = file?.config.fields;
    final preview = fields?.entries.map((final l) => "${l.key}: ${l.value}").join("\n");
    print("Preview:\n\n$preview");
    final apiKey0 = fields?["app.args.3"];
    final apiKey1 = "app.args.3".tr();
    print("\napi_key_0: $apiKey0");
    print("api_key_1: $apiKey1");

    // Use the .tr() function to handle translations for your app.
    final message = "screens.about.content".tr({"developer": "robmllze"});
    print("\n$message");
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<String?> getFromUri(String uri) async {
  try {
    final response = await http.get(Uri.parse(uri));
    return response.body;
  } catch (_) {}
  return null;
}
