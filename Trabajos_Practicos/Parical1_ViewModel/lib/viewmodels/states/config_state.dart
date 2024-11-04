import 'dart:developer';

import 'package:parcial_1_pineiro/presentation/utils/base_state_screen.dart';

class ConfigState {
  final BaseScreenState screenState;
  final int selectedColor;
  final bool isDarkMode;
  final String targetLanguage;
  final Map<String, String> textsApp;

  ConfigState(
      {required this.screenState,
      required this.selectedColor,
      required this.isDarkMode,
      required this.targetLanguage,
      required this.textsApp});

  factory ConfigState.initial() {
    return ConfigState(
      screenState: BaseScreenState.idle,
      selectedColor: 1,
      isDarkMode: true,
      targetLanguage: 'en',
      textsApp: {
        'Log In': 'Log In',
        'Email': 'Email',
        'Password': 'Password',
        'Keep me signed in': 'Keep me signed in',
        'Wrong Username or Password': 'Wrong Username or Password',
        'New at Dog Breeds?': 'New at Dog Breeds?',
        'Create Account': 'Create Account',
        'Name': 'Name',
        'Last Name': 'Last Name',
        'Age': 'Age',
        'Location': 'Location',
        'City': 'City',
        'Choose Profile Photo': 'Choose Profile Photo',
        'Camera': 'Camera',
        'Gallery': 'Gallery',
        'User Profile': 'User Profile',
        'Cancel': 'Cancel',
        'Submit': 'Submit',
        'Please enter some text': 'Please enter some text',
        'The password provided is too weak.':
            'The password provided is too weak.',
        'The account already exists for that email.':
            'The account already exists for that email.',
        'Invalid e-mail format': 'Invalid e-mail format',
        'Wrong Password': 'Wrong Password',
        'User not Found': 'User not Found',
        'Wrong Password or Email': 'Wrong Password or Email',
        'Settings': 'Settings',
        'Dark Mode': 'Dark Mode',
        'App Theme': 'App Theme',
        'Language': 'Language',
        'Color': 'Color',
        'Log Out': 'Log Out',
        'English': 'English',
        'Spanish': 'Spanish',
        'Dog Breeds': 'Dog Breeds',
        'Menu': 'Menu',
        'Search': 'Search',
        'Weight': 'Weight',
        'Height': 'Height',
        'Origin': 'Origin',
        'Description': 'Description',
        'Stats': 'Stats',
        'Life Expectancy': 'Life Expectancy',
        'They can weigh between': 'They can weigh between',
        'and grow up to': 'and grow up to',
        'Their life expectancy can range between':
            'Their life expectancy can range between',
        'Are you sure?': 'Are you sure?',
        'No': 'No',
        'Yes': 'Yes',
        'Dog Breed Detail': 'Dog Breed Detail',
        'Edit': 'Edit',
        'Delete': 'Delete',
        'Choose A Dog Photo': 'Choose A Dog Photo',
      },
    );
  }

  ConfigState copyWith({
    BaseScreenState? screenState,
    int? selectedColor,
    bool? isDarkMode,
    String? targetLanguage,
    Map<String, String>? textsApp,
  }) {
    return ConfigState(
      screenState: screenState ?? this.screenState,
      selectedColor: selectedColor ?? this.selectedColor,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      targetLanguage: targetLanguage ?? this.targetLanguage,
      textsApp: textsApp ?? this.textsApp,
    );
  }
}
