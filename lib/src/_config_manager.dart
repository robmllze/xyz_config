//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Config
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

part of 'xyz_config.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class ConfigManager {
  //
  //
  //

  static ConfigManager? _translationManager;

  void selectAsTranslationManager() {
    _translationManager = this;
  }

  //
  //
  //

  ConfigFile? _selected;
  ConfigFile? get selectedFile => this._selected;
  final Set<ConfigFile> files;
  final String opening, closing, delimiter;

  //
  //
  //

  ConfigManager._(
    this.files,
    this.opening,
    this.closing,
    this.delimiter,
  ) {
    assert(files.isNotEmpty);
    this._selected = files.first;
    _translationManager ??= this;
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
        delimiter: delimiter,
      );
      configs.add(ConfigFile(fileRef, config));
    }
    return ConfigManager._(
      configs,
      opening,
      closing,
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
      this._selected = g;
      return this._selected;
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
      this._selected = g;
      return this._selected;
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
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

ConfigRef _convertConfigRef(dynamic configRef) {
  return configRef is ConfigRef ? configRef : ConfigRef(configRef);
}
