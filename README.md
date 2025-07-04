# Flutter Boilerplate

![coverage][coverage_badge]
[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

A production-ready Flutter boilerplate project with a clean architecture, dependency injection, and best practices implementation.

## 🚀 Quick Start

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK (latest stable version)
- Android Studio / VS Code with Flutter extensions
- Git

### Installation

1. Clone this repository:
```bash
git clone https://github.com/your-username/flutter_boilerplate.git your_project_name
cd your_project_name
```

2. Get dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
# Development
flutter run --flavor development --target lib/main_development.dart

# Staging
flutter run --flavor staging --target lib/main_staging.dart

# Production
flutter run --flavor production --target lib/main_production.dart
```

## 📁 Project Structure

```
lib/
├── app/                    # Application layer
│   ├── app.dart           # App configuration
│   ├── bootstrap.dart     # App initialization
│   ├── routes/            # Route definitions
│   └── view/              # UI components
├── l10n/                  # Localization
│   └── arb/              # Translation files
├── main_development.dart  # Development entry point
├── main_production.dart   # Production entry point
└── main_staging.dart     # Staging entry point
```

### Key Directories and Their Uses

- `app/`: Contains the main application code
  - `routes/`: Define your app's navigation routes
  - `view/`: Contains all UI components and screens
- `l10n/`: Internationalization files
  - `arb/`: Translation files for different languages

## 🛠️ Features

- ✅ Clean Architecture
- ✅ Dependency Injection
- ✅ Internationalization
- ✅ Multiple Flavors (Development, Staging, Production)
- ✅ Code Generation
- ✅ Testing Setup
- ✅ CI/CD Ready

## 🧪 Testing

Run all tests with coverage:
```bash
flutter test --coverage --test-randomize-ordering-seed random
```

View coverage report:
```bash
# Generate Coverage Report
genhtml coverage/lcov.info -o coverage/

# Open Coverage Report
open coverage/index.html
```

## 🌐 Internationalization

This project uses [flutter_localizations][flutter_localizations_link] for internationalization. See the [official Flutter internationalization guide][internationalization_link] for more details.

### Adding New Translations

1. Add new strings to `lib/l10n/arb/app_en.arb`
2. Add translations for other languages in their respective ARB files
3. Generate translations:
```bash
flutter gen-l10n --arb-dir="lib/l10n/arb"
```

## 🔧 Configuration

### Environment Setup

1. Create a `.env` file in the root directory
2. Add your environment variables:
```env
API_URL=https://api.example.com
API_KEY=your_api_key
```

### Flavor Configuration

The project supports three flavors:
- Development: For local development
- Staging: For testing and QA
- Production: For production releases

## 📱 Supported Platforms

- iOS
- Android
- Web
- Windows

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

[coverage_badge]: coverage_badge.svg
[flutter_localizations_link]: https://api.flutter.dev/flutter/flutter_localizations/flutter_localizations-library.html
[internationalization_link]: https://flutter.dev/docs/development/accessibility-and-localization/internationalization
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[very_good_cli_link]: https://github.com/VeryGoodOpenSource/very_good_cli