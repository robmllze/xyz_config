// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Utils
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

import 'dart:convert' show jsonDecode;
import 'package:xyz_utils/xyz_utils.dart' show let;
import 'package:yaml/yaml.dart' show YamlMap, YamlList, loadYaml;

import 'parse_source_for_strings_and_comments.dart';

part '_xyz_config_ref.dart';
part '_xyz_config_file.dart';
part '_xyz_config_manager.dart';
part '_xyz_config_translate.dart';
part '_handle.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class XyzConfig {
  //
  //
  //

  final Map<dynamic, dynamic> _fields = {};
  Map<dynamic, dynamic> _fieldsWithLowerCaseKeys = {};
  Map<dynamic, dynamic> get fields => this._fields;
  Map<dynamic, dynamic> get fieldsWithLowerCaseKeys => this._fieldsWithLowerCaseKeys;
  final XyzConfigRef configRef;
  final String _sOpen, _sClose;
  Future<String> Function() loader;

  //
  //
  //

  XyzConfig._(this.configRef, this.loader, this._sOpen, this._sClose);

  //
  //
  //

  //
  //
  //

  factory XyzConfig(
    XyzConfigRef configRef,
    Future<String> Function() loader, {
    String sOpen = r"\(\=",
    String sClose = r"\)",
  }) {
    return XyzConfig._(configRef, loader, sOpen, sClose);
  }

  //
  //
  //

  Future<void> _processFromYaml() async {
    final src = await this.loader();
    final yaml = loadYaml(src);
    if (yaml is YamlMap) {
      this._parseYaml(yaml);
      this._replace(this._fields);
      this._fieldsWithLowerCaseKeys = _withLowerCaseKeys(this._fields);
    }
  }

  void _parseYaml(YamlMap input) {
    _parse<YamlList, YamlMap>(input, _fields);
  }

  //
  //
  //

  Future<void> _processFromJsonc() async {
    final src = await this.loader();
    this._parseJsonc(src);
    this._replace(this._fields);
    this._fieldsWithLowerCaseKeys = _withLowerCaseKeys(this._fields);
  }

  void _parseJsonc(String input) {
    final result = parseCSourceForStringsAndComments(input);

    for (final c in result.multiLineComments) {
      input = input.replaceAll(c, "");
    }

    for (final c in result.singleLineComments) {
      input = input.replaceAll(c, "");
    }
    final decoded = jsonDecode(input);
    _parse<List, Map>(decoded, _fields);
  }

  //
  //
  //

  Future<void> _processFromJson() async {
    final src = await this.loader();
    this._parseJson(src);
    this._replace(this._fields);
    this._fieldsWithLowerCaseKeys = _withLowerCaseKeys(this._fields);
  }

  void _parseJson(String input) {
    final decoded = jsonDecode(input);
    _parse<List, Map>(decoded, _fields);
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
        for (var k = 0; k < (input as dynamic).length; k++) {
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

    $parse(input);
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
        for (var n = 0; n < value.length; n++) {
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

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Map<dynamic, dynamic> _withLowerCaseKeys(Map<dynamic, dynamic> fields) {
  return fields.map((final k, final v) => MapEntry(k is String ? k.toLowerCase() : k, v));
}
