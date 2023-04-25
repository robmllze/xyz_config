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
      final match = fields.entries.firstWhere((final e) {
        final a = e.key?.toString().toLowerCase();
        final b = this.replaceAll("/", ".").toLowerCase();
        return a == b;
      });
      final handled = _handle(
        match.value.toString(),
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
    final segments = this.split(":::");
    final length = segments.length;
    if (length == 1) {
      return this.translate<String>(args, this) ?? this;
    }
    final fallback = segments[0];
    final path = segments[1].trim();
    return path.translate<String>(args, fallback) ?? fallback;
  }
}
