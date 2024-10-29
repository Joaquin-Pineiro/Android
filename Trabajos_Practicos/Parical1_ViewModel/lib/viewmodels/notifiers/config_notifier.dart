import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parcial_1_pineiro/data/providers.dart';
import 'package:parcial_1_pineiro/domain/models/user.dart';
import 'package:parcial_1_pineiro/presentation/utils/base_state_screen.dart';
import 'package:parcial_1_pineiro/viewmodels/states/config_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

final List<Color> colorList = [
  Colors.red,
  Colors.green,
  Colors.blue,
  Colors.yellow,
  Colors.purple,
  Colors.orange,
  Colors.pink,
  Colors.teal,
  Colors.cyan,
  Colors.indigo,
  Colors.lime,
  Colors.amber,
  Colors.brown,
  Colors.grey,
  Colors.blueGrey,
  Colors.black,
  Colors.white,
  Colors.transparent,
];

class ConfigNotifier extends Notifier<ConfigState> {
  @override
  ConfigState build() {
    return ConfigState.initial();
  }

  void toggleDarkMode() {
    state = state.copyWith(isDarkMode: !state.isDarkMode);
  }

  void changeColorScheme(int color) {
    state = state.copyWith(selectedColor: color);
  }

  ThemeData getTheme() {
    return ThemeData(
        colorSchemeSeed: colorList[state.selectedColor],
        brightness: state.isDarkMode ? Brightness.dark : Brightness.light,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(centerTitle: false));
  }
}
