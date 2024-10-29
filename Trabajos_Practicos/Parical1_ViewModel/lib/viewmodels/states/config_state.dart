import 'dart:developer';

import 'package:parcial_1_pineiro/presentation/utils/base_state_screen.dart';

class ConfigState {
  final BaseScreenState screenState;
  final int selectedColor;
  final bool isDarkMode;

  ConfigState({
    required this.screenState,
    required this.selectedColor,
    required this.isDarkMode,
  });

  factory ConfigState.initial() {
    return ConfigState(
      screenState: BaseScreenState.idle,
      selectedColor: 0,
      isDarkMode: true,
    );
  }

  ConfigState copyWith({
    BaseScreenState? screenState,
    int? selectedColor,
    bool? isDarkMode,
  }) {
    return ConfigState(
      screenState: screenState ?? this.screenState,
      selectedColor: selectedColor ?? this.selectedColor,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }
}
