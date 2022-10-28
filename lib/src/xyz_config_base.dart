import 'dart:convert';
import 'package:yaml/yaml.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

abstract class XyzLocaleRef {
  final String countryCode;
  final String languageCode;
  final String localeCode;
  final String fileType;
  const XyzLocaleRef(
    this.countryCode,
    this.languageCode,
    this.fileType,
  ) : localeCode = "$countryCode-$languageCode";
  @override
  String toString() {
    return "$localeCode.$fileType".toLowerCase();
  }
}

class XyzLocaleRefJson extends XyzLocaleRef {
  const XyzLocaleRefJson(String countryCode, String languageCode)
      : super(countryCode, languageCode, "json");
}

class XyzLocaleRefJsonc extends XyzLocaleRef {
  const XyzLocaleRefJsonc(String countryCode, String languageCode)
      : super(countryCode, languageCode, "jsonc");
}

class XyzLocaleRefYaml extends XyzLocaleRef {
  const XyzLocaleRefYaml(String countryCode, String languageCode)
      : super(countryCode, languageCode, "yaml");
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class XyzConfigNode {
  final String path;
  final XyzConfig config;
  const XyzConfigNode(this.path, this.config);
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class XyzConfigManager {
  //
  //
  //

  late final XyzConfigNode _current;
  final List<XyzConfigNode> _configs;
  final String _sOpen;
  final String _sClose;

  //
  //
  //

  XyzConfigManager._(this._configs, this._sOpen, this._sClose) {
    assert(_configs.isNotEmpty);
    _current = _configs.last;
  }

  //
  //
  //

  static Future<XyzConfigManager> create(
    Future<List<XyzConfigNode>> Function() loader, {
    String sOpen = r"\(\=",
    String sClose = r"\)",
  }) async {
    final configs = await loader();
    return XyzConfigManager._(configs, sOpen, sClose);
  }

  //
  //
  //

  void setCurrentByFilePath(String filePath) {
    _current = _configs.firstWhere((final l) => l.path == filePath);
  }

  void setCurrentByLocaleRef(XyzLocaleRef locale) {
    _current = _configs.firstWhere((final l) => l.path == locale.toString());
  }

  //
  //
  //

  String _translate(String src, [Map<dynamic, dynamic> args = const {}]) {
    try {
      final args0 = _configs.firstWhere((final l) => l.path == _current.path).config._config;
      return _handle(src, {...args0, ...args}, _sOpen, _sClose).toString();
    } catch (_) {}
    return "???";
  }
}

extension Translate on String {
  String tr(XyzConfigManager configManager, [Map<dynamic, dynamic> args = const {}]) {
    return configManager._translate(this, args);
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

dynamic _handle(
  String input,
  Map<dynamic, dynamic> handles,
  String sOpen,
  String sClose,
) {
  var copy = input;
  for (final entry in handles.entries) {
    final k = entry.key;
    final v = entry.value;
    final source = "$sOpen$k$sClose";
    if (input == source) return v;
    final expression = RegExp(source, caseSensitive: false);
    copy = copy.replaceAll(expression, v.toString());
  }
  return copy;
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class XyzConfig {
  //
  //
  //

  final _config = <dynamic, dynamic>{};
  Map<dynamic, dynamic> get config => _config;
  final String _sOpen;
  final String _sClose;

  //
  //
  //

  XyzConfig._(this._sOpen, this._sClose);

  //
  //
  //

  static Future<XyzConfig> fromYaml(
    Future<String> Function() loader, {
    Uri? sourceUrl,
    String sOpen = r"\(\=",
    String sClose = r"\)",
  }) async {
    final instance = XyzConfig._(sOpen, sClose);
    await instance._fromYaml(loader);
    return instance;
  }

  Future<void> _fromYaml(Future<String> Function() loader) async {
    final src = await loader();
    final yaml = loadYaml(src);
    if (yaml is YamlMap) {
      _parseYaml(yaml);
      _replace(_config);
    }
  }

  void _parseYaml(YamlMap input) {
    _parse<YamlList, YamlMap>(input, _config);
  }

  //
  //
  //

  static Future<XyzConfig> fromJsonc(
    Future<String> Function() loader, {
    String sOpen = r"\(\=",
    String sClose = r"\)",
  }) async {
    final instance = XyzConfig._(sOpen, sClose);
    await instance._fromJsonc(loader);
    return instance;
  }

  Future<void> _fromJsonc(Future<String> Function() loader) async {
    final src = await loader();
    _parseJsonc(src);
    _replace(_config);
  }

  void _parseJsonc(String input) {
    final decoded = jsonDecode(input.replaceAll(RegExp(r"\/\/.*"), ""));
    _parse<List, Map>(decoded, _config);
  }

  //
  //
  //

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
        r = _handle(input, local, _sOpen, _sClose);
      } else {
        r = input;
      }
      return r;
    }

    $parse(input) as Map<dynamic, dynamic>;
  }

  //
  //
  //

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
        r = _handle(value, global, _sOpen, _sClose);
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
