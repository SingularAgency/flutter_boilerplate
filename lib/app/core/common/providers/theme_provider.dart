import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/app/config/themes/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider for managing the current theme mode
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});

/// Provider for the current theme data based on the theme mode
final themeDataProvider = Provider<ThemeData>((ref) {
  final themeMode = ref.watch(themeModeProvider);
  return themeMode == ThemeMode.dark ? AppTheme.dark : AppTheme.light;
});

/// Notifier class for managing theme mode state
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  static const String _themeModeKey = 'theme_mode';
  late final SharedPreferences _prefs;

  ThemeModeNotifier() : super(ThemeMode.system) {
    _loadThemeMode();
  }

  /// Loads the saved theme mode from SharedPreferences
  Future<void> _loadThemeMode() async {
    _prefs = await SharedPreferences.getInstance();
    final savedThemeMode = _prefs.getString(_themeModeKey);
    if (savedThemeMode != null) {
      state = ThemeMode.values.firstWhere(
        (mode) => mode.toString() == savedThemeMode,
        orElse: () => ThemeMode.system,
      );
    }
  }

  /// Saves the current theme mode to SharedPreferences
  Future<void> _saveThemeMode(ThemeMode mode) async {
    await _prefs.setString(_themeModeKey, mode.toString());
  }

  /// Sets the theme mode and saves it to SharedPreferences
  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await _saveThemeMode(mode);
  }

  /// Toggles between light and dark theme
  Future<void> toggleTheme() async {
    final newMode = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await setThemeMode(newMode);
  }
}