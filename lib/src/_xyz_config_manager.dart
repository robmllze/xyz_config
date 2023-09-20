// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Utils
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

part of 'xyz_config.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class XyzConfigManager {
  //
  //
  //

  static XyzConfigManager? _translationManager;

  void selectAsTranslationManager() {
    _translationManager = this;
  }

  //
  //
  //

  XyzConfigFile? _selected;
  XyzConfigFile? get selectedFile => this._selected;
  final Set<XyzConfigFile> files;
  final String opening, closing, delimiter;

  //
  //
  //

  XyzConfigManager._(
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

  factory XyzConfigManager.create(
    Map<dynamic, XyzConfigFileRef> files,
    Future<String> Function(String path) reader, {
    String opening = "<<<",
    String closing = ">>>",
    String delimiter = "||",
  }) {
    final configs = <XyzConfigFile>{};
    for (final entry in files.entries) {
      XyzConfig? config;
      final configRef = entry.key;
      final fileRef = entry.value;
      final path = fileRef.path;
      config = XyzConfig(
        _convertConfigRef(configRef),
        () => reader(path),
        opening: opening,
        closing: closing,
        delimiter: delimiter,
      );
      configs.add(XyzConfigFile(fileRef, config));
    }
    return XyzConfigManager._(
      configs,
      opening,
      closing,
      delimiter,
    );
  }

  //
  //
  //

  XyzConfigFile? getByPath(String path) {
    return this.files.cast<XyzConfigFile?>().firstWhere(
          (final l) => l!.fileRef.path == path,
          orElse: () => null,
        );
  }

  XyzConfigFile? selectByPath(String path) {
    final g = this.getByPath(path);
    assert(g != null);
    if (g != null) {
      this._selected = g;
      return this._selected;
    }
    return null;
  }

  Future<XyzConfigFile?> loadFileByPath(String path) async {
    final g = this.getByPath(path);
    if (await g?.process() == true) {
      return g;
    }
    return null;
  }

  //
  //
  //

  XyzConfigFile? getByConfigRef(dynamic configRef) {
    return this.files.cast<XyzConfigFile?>().firstWhere(
      (final l) {
        return l!.config.configRef == _convertConfigRef(configRef);
      },
      orElse: () => null,
    );
  }

  XyzConfigFile? selectByConfigRef(dynamic configRef) {
    final g = this.getByConfigRef(configRef);
    assert(g != null);
    if (g != null) {
      this._selected = g;
      return this._selected;
    }
    return null;
  }

  Future<XyzConfigFile?> loadFileByConfigRef(dynamic configRef) async {
    final g = this.getByConfigRef(configRef);
    if (await g?.process() == true) {
      return g;
    }
    return null;
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

XyzConfigRef _convertConfigRef(dynamic configRef) {
  return configRef is XyzConfigRef ? configRef : XyzConfigRef(configRef);
}
