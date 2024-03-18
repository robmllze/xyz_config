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

import 'dart:io';

void main(List<String> args) {
  if (args.length != 2) {
    print("[ERROR] Usage: dart update_changelog.dart <version> <release-notes>");
    exit(1);
  }

  final version = args[0];
  final releaseNotes = args[1];
  final changelogPath = "CHANGELOG.md";
  final file = File(changelogPath);

  if (!file.existsSync()) {
    print("[ERROR] $changelogPath does not exist.");
    exit(1);
  }

  final contents = file.readAsStringSync();
  final versionExists = contents.contains("## [$version]");
  if (versionExists) {
    print("[WARNING] Version $version already exists in $changelogPath");
    return;
  }

  final newEntry = "## [$version]\n\n$releaseNotes";
  const changelog = "# Changelog";
  final hasChangelogHeader = contents.toLowerCase().contains(changelog.toLowerCase());
  final updatedContents = hasChangelogHeader
      ? contents.replaceFirst(
          RegExp(changelog, caseSensitive: false),
          "$changelog\n\n$newEntry",
        )
      : "$changelog\n\n$newEntry$contents";

  file.writeAsStringSync(updatedContents);
  print("[SUCCESS] Updated $changelogPath with version $version");
}
