import 'package:xyz_config/xyz_config.dart';
import 'dart:io' as io;

Future<void> main() async {
  final a = await XyzConfig.configFromYaml(() => io.File("config.yaml").readAsString());
  print(a.config);
  final b = await XyzConfig.configFromJsonc(() => io.File("config.jsonc").readAsString());
  print(a.config);
}
