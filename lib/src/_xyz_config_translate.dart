// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Utils
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

part of 'xyz_config.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

extension XyzConfigTranslate on String {
  //
  //
  //

  T? translate<T>([Map<dynamic, dynamic> args = const {}, T? fallback]) {
    try {
      final manager = XyzConfigManager._translationManager!;
      final fields = manager._selected!.config._fields;
      final match = () {
        try {
          return fields.entries
              .firstWhere((final e) {
                final a = e.key?.toString().toLowerCase();
                final b = this.replaceAll("/", ".").toLowerCase();
                return a == b;
              })
              .value
              .toString();
        } catch (_) {
          return fallback.toString();
        }
      }();
      final handled = _handle(
        match,
        {...fields, ...args},
        manager._sOpen,
        manager._sClose,
      );
      return let<T>(handled) ?? fallback;
    } catch (_) {}
    return null;
  }

  //
  //
  //

  String tr([Map<dynamic, dynamic> args = const {}]) {
    final segments = this.split("||");
    final length = segments.length;
    String fallback, path;
    if (length == 1) {
      fallback = this;
      path = this.trim();
    } else {
      fallback = segments[0];
      path = segments[1].trim();
    }
    final translated = path.translate<String>(args, fallback) ?? fallback;
    return translated;
  }
}
