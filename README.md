# 🇽🇾🇿 Config

[![pub package](https://img.shields.io/pub/v/xyz_config.svg)](https://pub.dev/packages/xyz_config)

This package allows you to add configurations and language support to your apps.

## Quickstart

1. Create a translations file at `your_flutter_project/assets/translations/en_us.yaml`.
```yaml
greetings:
  HelloWorld: Hello World!
```

2. Access the translations in your app:
```dart
  final translationFileReader = TranslationFileReader(
    translationsDirPath: ['translations'],
    fileType: ConfigFileType.YAML,
    fileReader: (filePath) => rootBundle.loadString(filePath),
  );

  await translationFileReader.read('en_us'.toLowerCase());

  print('greetings.HelloWorld'.tr());
```

**Tip:** File names are case sensitive on most Linux based systems like Firebase Hosting. Make sure to use the correct case for your file paths. As a rule of thumb, always use lowercase file paths.

## Documentation

🔜 Documentation and video tutorials are coming soon. Feel free to contact me for more information.

## Installation

#### Add this to your `pubspec.yaml` file:

```yaml
dependencies:
  xyz_config: any # or the latest version
```
## Contributing

Contributions are welcome. Here are a few ways you can help:

- Report bugs and make feature requests.
- Add new features.
- Improve the existing code.
- Help with documentation and tutorials.

## License

This project is released under the MIT License. See [LICENSE](https://raw.githubusercontent.com/robmllze/xyz_config/main/LICENSE) for more information.

## Contact

**Author:** Robert Mollentze

**Email:** robmllze@gmail.com