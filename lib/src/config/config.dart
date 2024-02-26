//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Config
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import '/_common.dart';

part '_config_file.dart';
part '_config_manager.dart';
part '_config_translate.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class Config {
  //
  //
  //

  final Map<dynamic, dynamic> fields = {};
  final ConfigRef configRef;
  final String opening, closing, delimiter;
  Future<String> Function() loader;

  //
  //
  //

  Config._(
    this.configRef,
    this.loader,
    this.opening,
    this.closing,
    this.delimiter,
  );

  //
  //
  //

  factory Config(
    ConfigRef configRef,
    Future<String> Function() loader, {
    String opening = "<<<",
    String closing = ">>>",
    String delimiter = "||",
  }) {
    return Config._(
      configRef,
      loader,
      opening,
      closing,
      delimiter,
    );
  }

  //
  //
  //

  Future<void> _processFromYaml() async {
    final src = await this.loader();
    final yaml = loadYaml(src);
    if (yaml is YamlMap) {
      this._parseYaml(yaml);
      this._replace(this.fields);
    }
  }

  void _parseYaml(YamlMap input) {
    this._parse<YamlList, YamlMap>(input, this.fields);
  }

  //
  //
  //

  Future<void> _processFromJsonc() async {
    final src = await this.loader();
    this._parseJsonc(src);
    this._replace(this.fields);
  }

  void _parseJsonc(String input) {
    final result = parseSourceForStringsAndComments(input);

    for (final c in result.multiLineComments) {
      input = input.replaceAll(c, "");
    }

    for (final c in result.singleLineComments) {
      input = input.replaceAll(c, "");
    }
    final decoded = jsonDecode(input);
    _parse<List, Map>(decoded, this.fields);
  }

  //
  //
  //

  Future<void> _processFromJson() async {
    final src = await this.loader();
    this._parseJson(src);
    this._replace(this.fields);
  }

  void _parseJson(String input) {
    final decoded = jsonDecode(input);
    this._parse<List, Map>(decoded, this.fields);
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
        r = replaceAllPatterns(input, local, this.opening, this.closing);
        // r = custromTr(
        //   input,
        //   opening: this._opening,
        //   closing: this._closing,
        //   delimiter: this._delimiter,
        //   args: local,
        // );
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
        r = replaceAllPatterns(value, global, this.opening, this.closing);
        // r = custromTr(
        //   value,
        //   opening: this._opening,
        //   closing: this._closing,
        //   delimiter: this._delimiter,
        //   args: global,
        // );
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

// Map<dynamic, dynamic> _withLowerCaseKeys(Map<dynamic, dynamic> fields) {
//   return fields.map((final k, final v) => MapEntry(k is String ? k.toLowerCase() : k, v));
// }
