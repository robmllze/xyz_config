//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Config
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

Map<String, dynamic> flattenJMap(Map input) {
  Map<String, dynamic> $flattenJMap(dynamic input, [String prefix = ""]) {
    final flattenedMap = <String, dynamic>{};
    void flatten(dynamic current, String path) {
      if (current is Map) {
        current.forEach((key, value) {
          final newPath = path.isEmpty ? key.toString() : "$path.$key";
          flatten(value, newPath);
        });
      } else if (current is List) {
        for (var i = 0; i < current.length; i++) {
          flatten(current[i], "$path.$i");
        }
      } else {
        flattenedMap[path] = current;
      }
    }

    flatten(input, prefix);
    return flattenedMap;
  }

  return $flattenJMap(input);
}