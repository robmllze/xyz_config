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

import '/_common.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class ConfigManager {
  //
  //
  //

  static ConfigManager? _translationManager;
  static ConfigManager? get translationManager => _translationManager;

  //
  //
  //

  final Set<ConfigFile> files;
  final String opening;
  final String closing;
  final String separator;
  final String delimiter;

  //
  //
  //

  ConfigManager._(
    this.files,
    this.opening,
    this.closing,
    this.separator,
    this.delimiter,
  ) {
    assert(files.isNotEmpty);
    this._selectedFile = files.first;
    _translationManager ??= this;
  }

  //
  //
  //

  ConfigFile? _selectedFile;
  ConfigFile? get selectedFile => this._selectedFile;

  //
  //
  //

  void selectAsTranslationManager() {
    _translationManager = this;
  }

  //
  //
  //

  Future<void> processFiles() async {
    for (final file in files) {
      await file.process();
    }
  }

  //
  //
  //

  factory ConfigManager.create(
    Map<dynamic, ConfigFileRef> files,
    Future<String> Function(String path) reader, {
    String opening = "<<<",
    String closing = ">>>",
    String separator = ".",
    String delimiter = "||",
  }) {
    final configs = <ConfigFile>{};
    for (final entry in files.entries) {
      Config? config;
      final configRef = entry.key;
      final fileRef = entry.value;
      final path = fileRef.path;
      config = Config(
        _convertConfigRef(configRef),
        () => reader(path),
        opening: opening,
        closing: closing,
        separator: separator,
        delimiter: delimiter,
      );
      configs.add(ConfigFile(fileRef, config));
    }
    return ConfigManager._(
      configs,
      opening,
      closing,
      separator,
      delimiter,
    );
  }

  //
  //
  //

  ConfigFile? getByPath(String path) {
    return this.files.cast<ConfigFile?>().firstWhere(
          (final l) => l!.fileRef.path == path,
          orElse: () => null,
        );
  }

  ConfigFile? selectByPath(String path) {
    final g = this.getByPath(path);
    assert(g != null);
    if (g != null) {
      this._selectedFile = g;
      return this._selectedFile;
    }
    return null;
  }

  Future<ConfigFile?> loadFileByPath(String path) async {
    final g = this.getByPath(path);
    if (await g?.process() == true) {
      return g;
    }
    return null;
  }

  //
  //
  //

  ConfigFile? getByConfigRef(dynamic configRef) {
    return this.files.cast<ConfigFile?>().firstWhere(
      (final l) {
        return l!.config.configRef == _convertConfigRef(configRef);
      },
      orElse: () => null,
    );
  }

  ConfigFile? selectByConfigRef(dynamic configRef) {
    final g = this.getByConfigRef(configRef);
    assert(g != null);
    if (g != null) {
      this._selectedFile = g;
      return this._selectedFile;
    }
    return null;
  }

  Future<ConfigFile?> loadFileByConfigRef(dynamic configRef) async {
    final g = this.getByConfigRef(configRef);
    if (await g?.process() == true) {
      return g;
    }
    return null;
  }

  //
  //
  //

  Iterable<LocaleRef> localeRefs() {
    return this.files.map((final l) {
      final ref = l.config.configRef;
      return ref is LocaleRef ? ref : null;
    }).nonNulls;
  }

  //
  //
  //

  T? map<T>(
    String input, {
    Map<dynamic, dynamic> args = const {},
    T? fallback,
    String? Function(String, dynamic, String?)? onReplace,
  }) {
    final fields = this.selectedFile?.config.fields;
    final expandedArgs = expandJson(args);
    final data = {
      ...?fields,
      ...expandedArgs,
    };
    final r = replaceAllPatterns(
      input,
      data,
      opening: this.opening,
      closing: this.closing,
      delimiter: this.delimiter,
      onReplace: onReplace,
    );
    final res = let<T>(r) ?? fallback;
    return res;
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

ConfigRef _convertConfigRef(dynamic configRef) {
  return configRef is ConfigRef ? configRef : ConfigRef(configRef);
}
