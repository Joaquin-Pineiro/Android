import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:parcial_1_pineiro/config/router/app_router.dart';
import 'package:parcial_1_pineiro/presentation/utils/base_state_screen.dart';
import 'package:parcial_1_pineiro/viewmodels/notifiers/config_notifier.dart';
import 'package:parcial_1_pineiro/viewmodels/providers.dart';

class ConfigScreen extends ConsumerStatefulWidget {
  const ConfigScreen({super.key, required this.userId});
  final String userId;
  @override
  ConsumerState<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends ConsumerState<ConfigScreen> {
  int selectedColor = 0;
  String selectedLanguaje = 'en';
  bool isDarkMode = true;
  @override
  void initState() {
    super.initState();

    selectedColor = ref.read(configViewModelProvider).selectedColor;
    isDarkMode = ref.read(configViewModelProvider).isDarkMode;
    selectedLanguaje = ref.read(configViewModelProvider).targetLanguage;
  }

  toggleDarkMode() {
    ref.read(configViewModelProvider.notifier).toggleDarkMode();
  }

  changeColorScheme(int value) {
    ref.read(configViewModelProvider.notifier).changeColorScheme(value);
  }

  changeLanguage(String targetLanguage) {
    ref.read(configViewModelProvider.notifier).translate(targetLanguage);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(configViewModelProvider);
    log("Selected Color in build $selectedColor");
    log("Selected Color in state ${state.selectedColor}");
    ref.listen(
      configViewModelProvider,
      (_, state) {
        selectedColor = state.selectedColor;
        isDarkMode = state.isDarkMode;
        selectedLanguaje = state.targetLanguage;
      },
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(state.textsApp['Settings']!),
        leading: IconButton(
            onPressed: () => context.goNamed('Breeds', extra: widget.userId),
            icon: const Icon(Icons.arrow_back)),
      ),
      body: state.screenState.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        idle: () {
          return config(state.textsApp);
        },
        empty: () {
          return;
        },
        error: () => const Center(
          child: Text('Error:'),
        ),
      ),
    );
  }

  Widget config(Map<String, String> textsApp) {
    return ListView(
      children: [
        SwitchListTile(
            title: Text(textsApp['Dark Mode']!),
            value: isDarkMode,
            onChanged: (value) {
              toggleDarkMode();
            }),
        const Divider(
          thickness: 2,
        ),
        ExpansionTile(
          title: Text(textsApp["App Theme"]!),
          trailing: const Icon(Icons.format_color_fill),
          subtitle: Text(
            "${textsApp['Color']!} $selectedColor",
            style: TextStyle(color: colorList[selectedColor]),
          ),
          children: [
            SizedBox(
              height: 200,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: colorList.length,
                itemBuilder: (context, index) {
                  return RadioListTile(
                    title: Text(
                      "${textsApp['Color']!} $index",
                      style: TextStyle(color: colorList[index]),
                    ),
                    subtitle:
                        Text("# ${colorList[index].value.toRadixString(16)}"),
                    value: index,
                    groupValue: selectedColor,
                    onChanged: (value) {
                      changeColorScheme(value ?? 0);
                    },
                  );
                },
              ),
            )
          ],
        ),
        const Divider(
          thickness: 2,
        ),
        ExpansionTile(
          title: Text(textsApp["Language"]!),
          subtitle: Text(selectedLanguaje),
          trailing: const Icon(Icons.translate),
          children: [
            SizedBox(
              height: 200,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: languageList.length,
                itemBuilder: (context, index) {
                  return RadioListTile(
                    title: Text(languageList[index]),
                    value: languageCodeList[index],
                    groupValue: selectedLanguaje,
                    onChanged: (value) {
                      changeLanguage(value ?? 'en');
                    },
                  );
                },
              ),
            )
          ],
        )
      ],
    );
  }
}
