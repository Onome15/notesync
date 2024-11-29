import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// StateNotifier to manage theme mode
class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.light) {
    _loadTheme(); // Load theme on initialization
  }

  static const String _themeKey = 'theme_mode';

  // Load the theme from SharedPreferences
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_themeKey) ?? 0;
    state = ThemeMode.values[themeIndex];
  }

  Future<void> toggleTheme() async {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, state.index); // Save theme index
  }
}

// Provider for ThemeNotifier
final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>(
  (ref) => ThemeNotifier(),
);

final lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.blue,
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: Colors.blue,
    brightness: Brightness.light, // Match ThemeData.brightness
  ).copyWith(
      surface: Colors.white, // Background color for loading widget
      primary: const Color(0xFF0057FF),
      secondary: Colors.white30,
      primaryContainer: Colors.blue[300]
      // Spinner color for loading widget
      ),
  appBarTheme: AppBarTheme(
    color: Colors.blue[300],
    foregroundColor: Colors.black,
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Colors.black,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue[300],
        foregroundColor: Colors.black,
        textStyle: const TextStyle(fontSize: 20)),
  ),
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.grey,
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: Colors.grey,
    brightness: Brightness.dark, // Match ThemeData.brightness
  ).copyWith(
      surface: Colors.grey[800],
      primary: Colors.white, // Spinner color for loading widget
      secondary: Colors.grey[800],
      primaryContainer: Colors.grey[900]
      // Background color for loading widget
      ),
  appBarTheme: AppBarTheme(
    color: Colors.grey[900],
    foregroundColor: Colors.white,
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Colors.white,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        textStyle: const TextStyle(fontSize: 20)),
  ),
);
