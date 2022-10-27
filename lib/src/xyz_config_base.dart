import 'dart:convert';

import 'package:yaml/yaml.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class XyzConfig {
  final _config = <dynamic, dynamic>{};
  Map<dynamic, dynamic> get config => _config;

  XyzConfig._();

  static Future<XyzConfig> configFromYaml(
    Future<String> Function() loader, {
    Uri? sourceUrl,
  }) async {
    final instance = XyzConfig._();
    await instance._configFromYaml(loader, sourceUrl: sourceUrl);
    return instance;
  }

  Future<void> _configFromYaml(
    Future<String> Function() loader, {
    Uri? sourceUrl,
  }) async {
    final src = await loader();
    final yaml = loadYaml(src, sourceUrl: sourceUrl);
    if (yaml is YamlMap) {
      _parseYaml(yaml);
      _replace(_config);
    }
  }

  static Future<XyzConfig> configFromJsonc(Future<String> Function() loader) async {
    final instance = XyzConfig._();
    await instance._configFromJsonc(loader);
    return instance;
  }

  Future<void> _configFromJsonc(Future<String> Function() loader) async {
    final src = await loader();
    _parseJson(src);
    _replace(_config);
  }

  void _parseYaml(YamlMap input) {
    _parse<YamlList, YamlMap>(input, _config);
  }

  void _parseJson(String input) {
    final decoded = jsonDecode(input.replaceAll(RegExp(r"\/\/.*"), ""));
    _parse<List, Map>(decoded, _config);
  }

  void _parse<TList, TMap>(TMap input, Map<dynamic, dynamic> global) {
    final local = <dynamic, dynamic>{};
    dynamic $parse(dynamic input, [String? kx]) {
      dynamic r;
      if (input is TList) {
        r = <dynamic>[];
        for (int k = 0; k < (input as dynamic).length; k++) {
          final v = input[k];
          final ky = "${kx != null ? "$kx." : ""}$k";
          final py = $parse(v, ky);
          global[ky] = py;
          local[".$k"] = py;
          r.add(py);
        }
      } else if (input is TMap) {
        r = <dynamic, dynamic>{};
        for (final l in (input as dynamic).entries) {
          final k = l.key;
          final v = l.value;
          final ky = "${kx != null ? "$kx." : ""}$k";
          final py = $parse(v, ky);
          global[ky] = py;
          local[".$k"] = py;
          r[k] = py;
        }
      } else if (input is String) {
        r = _handle(input, local);
      } else {
        r = input;
      }
      return r;
    }

    $parse(input) as Map<dynamic, dynamic>;
  }

  void _replace(Map<dynamic, dynamic> global) {
    dynamic $replace<T>(dynamic key, dynamic value) {
      dynamic r;
      if (value is Map) {
        r = <dynamic, dynamic>{};
        for (final entry in value.entries) {
          final k = entry.key;
          final v = entry.value;
          r[k] = $replace(k, v);
        }
      } else if (value is List) {
        r = <dynamic>[];
        for (int n = 0; n < value.length; n++) {
          r.add($replace("$key.$n", value[n]));
        }
      }
      if (value is String) {
        r = _handle(value, global);
      } else {
        r = value;
      }
      if (key != null) {
        global[key] = r;
      }
      return r;
    }

    global.removeWhere((_, final v) => v is Map || v is List);
    $replace(null, global /*Map.of(global)*/);
  }
}

dynamic _handle(String input, Map<dynamic, dynamic> handles) {
  var copy = input;
  for (final entry in handles.entries) {
    final k = entry.key;
    final v = entry.value;
    final source = "{$k}";
    if (input == source) return v;
    final expression = RegExp(source, caseSensitive: false);
    copy = copy.replaceAll(expression, v.toString());
  }
  return copy;
}

String _translate(
  String src,
  String locale,
  Map<String, XyzConfig> configs,
) {
  final handles = configs[locale]?.config;
  if (handles?.isNotEmpty == true) {
    return _handle(src, handles!).toString();
  }
  return "???";
}



// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

// Future<String> getGameData(String src) async {
//   final response = await HttpRequest.getString(
//     "$src.yaml",
//     onProgress: (_) {
//       //
//     },
//   );
//   return response;
// }


