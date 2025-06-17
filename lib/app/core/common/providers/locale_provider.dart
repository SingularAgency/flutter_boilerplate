import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider for managing the current locale
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});

/// Notifier class for managing locale state
class LocaleNotifier extends StateNotifier<Locale> {
  static const String _localeKey = 'locale';
  late final SharedPreferences _prefs;

  LocaleNotifier() : super(const Locale('en')) {
    _loadLocale();
  }

  /// Loads the saved locale from SharedPreferences
  Future<void> _loadLocale() async {
    _prefs = await SharedPreferences.getInstance();
    final savedLocale = _prefs.getString(_localeKey);
    if (savedLocale != null) {
      state = Locale(savedLocale);
    }
  }

  /// Saves the current locale to SharedPreferences
  Future<void> _saveLocale(Locale locale) async {
    await _prefs.setString(_localeKey, locale.languageCode);
  }

  /// Sets the locale and saves it to SharedPreferences
  Future<void> setLocale(Locale locale) async {
    state = locale;
    await _saveLocale(locale);
  }

  /// Toggles between available locales
  Future<void> toggleLocale() async {
    final newLocale = state.languageCode == 'en' 
        ? const Locale('es') 
        : const Locale('en');
    await setLocale(newLocale);
  }

  /// Gets the current locale name
  String get currentLocaleName {
    switch (state.languageCode) {
      case 'en':
        return 'English';
      case 'es':
        return 'Español';
      default:
        return 'English';
    }
  }

  /// Gets the current locale flag emoji
  String get currentLocaleFlag {
    switch (state.languageCode) {
      case 'en':
        return '🇺🇸';
      case 'es':
        return '🇪🇸';
      default:
        return '🇺🇸';
    }
  }
}

/// List of supported locales
final supportedLocales = const [
  Locale('en'), // English
  Locale('es'), // Spanish
];

/// List of supported locale names
final supportedLocaleNames = const {
  'en': 'English',
  'es': 'Español',
};

/// List of supported locale flags
final supportedLocaleFlags = const {
  'en': '🇺🇸',
  'es': '🇪🇸',
}; 