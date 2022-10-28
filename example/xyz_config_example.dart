import 'package:xyz_config/xyz_config.dart';
import 'dart:io';

Future<void> main() async {
  //
  //
  //

  final xyzConfigManager = await XyzConfigManager.create(() async {
    final nodes = <XyzConfigNode>[];
    for (final path in ["test.yaml"]) {
      nodes.add(
        XyzConfigNode(
          path,
          await XyzConfig.fromYaml(() => File(path).readAsString()),
        ),
      );
    }
    return nodes;
  });

  print("(=this_file_type)".tr(xyzConfigManager));

  //final a = await XyzConfig.fromYaml(() => File("test.yaml").readAsString());
  // print(a.config);
  // final b = await XyzConfig.fromJsonc(() => io.File("test.jsonc").readAsString());
  // print(b.config);
}
