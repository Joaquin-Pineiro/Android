import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parcial_1_pineiro/domain/models/translation_service.dart';
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

final List<String> languageCodeList = [
  'en',
  'es',
  'fr',
  'de',
  'it',
];
List<String> languageList = [
  'English',
  'Spanish',
  'French',
  'German',
  'Italian',
];

class ConfigNotifier extends Notifier<ConfigState> {
  @override
  ConfigState build() {
    return ConfigState.initial();
  }

  Future<void> restoreConfiguration() async {
    final prefs = await SharedPreferences.getInstance();

    final String language = prefs.getString('language') ?? "";
    if (language != "") {
      log("HOLA");
      final List<String> textsApp = prefs.getStringList('textsApp') ?? [];
      final List<String> auxLanguageList =
          prefs.getStringList('languageList') ?? [];
      final String language = prefs.getString('language') ?? "";

      Map<String, String> aux = Map.from(state.textsApp);

      int i = 0;
      aux.updateAll((key, value) => textsApp[i++]);
      state = state.copyWith(
          screenState: BaseScreenState.idle,
          textsApp: aux,
          targetLanguage: language);
      languageList = auxLanguageList;
    }
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

  Future<void> translate(String targetLanguage) async {
    final translationService = TranslationService();
    Map<String, String> aux = Map.from(state.textsApp);

    // Set screen state to loading
    state = state.copyWith(
        screenState: BaseScreenState.loading, targetLanguage: targetLanguage);

    List<String> translatedText = await translationService.translateBatch(
        state.textsApp.values.toList(), state.targetLanguage);

    int i = 0;
    aux.updateAll((key, value) => translatedText[i++]);
    state = state.copyWith(screenState: BaseScreenState.idle, textsApp: aux);

    translatedText = await translationService.translateBatch(
        languageList, state.targetLanguage);
    languageList = translatedText;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('textsApp', state.textsApp.values.toList());
    await prefs.setStringList('languageList', languageList);
    await prefs.setString('language', state.targetLanguage);
  }
}
