//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Config
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:xyz_config/all.dart';

import 'dart:io';
import 'package:http/http.dart' as http;

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

void main() async {
  // ---------------------------------------------------------------------------

  // Step 1: Create a XyzConfigManager object.
  final managerLocal = ConfigManager.create(
    // Step 2: Specify all your configurations.
    {
      // 1.
      const ConfigRef("test"): const ConfigFileRef(
        "test.yaml", // file path to this configuration
        alias: "Test", // give it some name
        type: ConfigFileType.YAML, // type of file
      ),
      // 2.
      LocaleRef("AU", "en"): const ConfigFileRef(
        "translations/AU-en.yaml",
        alias: "English (AU)",
      ),
      // 3.
      LocaleRef("UK", "en"): const ConfigFileRef(
        "translations/UK-en.jsonc",
        alias: "English (UK)",
        type: ConfigFileType.JSONC,
      ),
      // 4.
      LocaleRef("US", "en"): const ConfigFileRef(
        "translations/US-en.json",
        alias: "English (US)",
        type: ConfigFileType.JSON,
      ),
      // 5.
      "pubspec.yaml": const ConfigFileRef("pubspec.yaml"),
    },
    // Step 3. Specify how the configurations should be loaded.
    (final path) => File(path).readAsString(),
  );

  // ---------------------------------------------------------------------------

  final managerRemote = ConfigManager.create(
    {
      LocaleRef("AU", "en"): const ConfigFileRef(
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
    LocaleRef("AU", "en"),
    LocaleRef("UK", "en"),
    LocaleRef("US", "en"),
    "pubspec.yaml",
  ]) {
    ConfigFile? file;
    print(
        "\n----------------------------------------------------------------\n");

    // Load the configuration files.
    if (locale == LocaleRef("AU", "en")) {
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
    final preview =
        fields?.entries.map((final l) => "${l.key}: ${l.value}").join("\n");
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
