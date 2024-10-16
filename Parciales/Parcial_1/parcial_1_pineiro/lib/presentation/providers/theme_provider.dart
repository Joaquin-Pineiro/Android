import 'package:flutter/material.dart';
import 'package:parcial_1_pineiro/domain/models/app_theme.dart';
import 'package:riverpod/riverpod.dart';

final Provider<List<Color>> colorListProvider = Provider((ref) => colorList);
final themeNotifierProvider =
    StateNotifierProvider<ThemeNotifier, AppTheme>((ref) => ThemeNotifier());

class ThemeNotifier extends StateNotifier<AppTheme> {
  ThemeNotifier() : super(AppTheme());

  void toggleDarkMode() {
    state = state.copyWith(isDarkMode: !state.isDarkMode);
  }

  void changeColorScheme(int color) {
    state = state.copyWith(selectedColor: color);
  }
}
