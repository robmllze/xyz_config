# 🇽🇾🇿 Config

[![pub package](https://img.shields.io/pub/v/xyz_config.svg)](https://pub.dev/packages/xyz_config)

This package allows you to add configurations and language support to your apps.

## Quickstart

1. Create translation files at `YOUR_PROJECT/assets/translations/`.

```yaml
# en_us.yaml
messages:
  welcome_message: Welcome to this app!
languages:
  en_us: English
  af_za: Afrikaans
```

```yaml
# af_za.yaml
messages:
  welcome_message: Welkom by hierdie app!
languages:
  en_us: Engels
  af_za: Afrikaans
```

2. Create the translation file reader.

```dart
  final translationFileReader = TranslationFileReader(
    // The path to the translations directory, e.g. rootBundle looks at 'assets/translations'.
    translationsDirPath: ['translations'],
    // The translation file type, e.g. YAML, JSON, JSONC, CSV, etc.
    fileType: ConfigFileType.YAML,
    // The translation file reader, e.g. rootBundle, http, file, etc.
    fileReader: (filePath) => rootBundle.loadString(filePath),
  );
```

3. Change the language and use the translations.

```dart
  Button(
    onTap: () async {
      // Translate app to English (en_us.yaml).
      await translationFileReader.read('en_us');
      // Refresh the UI. You will have to refresh the app at the top level so that all widgets can update.
      setState(() {});
    },
    child: Text('English||languages.en_us'.tr()),
  )

  Button(
    onTap: () async {
      // Translate app to Afrikaans (af_za.yaml).
      await translationFileReader.read('af_za');
      setState(() {});
    },
    child: Text('Afrikaans||languages.af_za'.tr()),
  )

  Text('Hmmm... welcome!||messages.welcome_message'.tr()); // Defaults to "Hmmm... welcome!" if the translation at "messages.welcome_message" isn't found.
```

**Tip:** File names are case sensitive on most Linux based systems like Firebase Hosting. Make sure to use the correct case for your file paths. As a rule of thumb, always use lowercase file paths.

## Documentation

🔜 Documentation and video tutorials are coming soon. Feel free to contact me for more information.

## Installation

Use this package as a dependency by adding it to your `pubspec.yaml` file (see [here](https://pub.dev/packages/xyz_config/install)), or copy the needed source code directly into your project.

## Contributing and Discussions

This is an open-source project, and contributions are welcome from everyone, regardless of experience level. Contributing to projects is a great way to learn, share knowledge, and showcase your skills to the community. Join the discussions to ask questions, report bugs, suggest features, share ideas, or find out how you can contribute.

### Join GitHub Discussion:

💬 https://github.com/robmllze/xyz_config/discussions

### Join Reddit Discussion:

💬 https://www.reddit.com/user/robmllze/m/xyz_config_package/

### Chief Maintainer:

📧 Email _Robert Mollentze_ at robmllze@gmail.com

## License

This project is released under the MIT License. See [LICENSE](https://raw.githubusercontent.com/robmllze/xyz_config/main/LICENSE) for more information.
