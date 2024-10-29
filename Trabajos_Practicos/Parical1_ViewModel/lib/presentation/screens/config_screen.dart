import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parcial_1_pineiro/presentation/utils/base_state_screen.dart';
import 'package:parcial_1_pineiro/viewmodels/notifiers/config_notifier.dart';
import 'package:parcial_1_pineiro/viewmodels/providers.dart';

class ConfigScreen extends ConsumerStatefulWidget {
  const ConfigScreen({super.key});

  @override
  ConsumerState<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends ConsumerState<ConfigScreen> {
  int selectedColor = 0;
  bool isDarkMode = true;
  @override
  void initState() {
    super.initState();

    selectedColor = ref.read(configViewModelProvider).selectedColor;
    isDarkMode = ref.read(configViewModelProvider).isDarkMode;
    log("Selected Color in addPostFrameCallback $selectedColor");
  }

  toggleDarkMode() {
    ref.read(configViewModelProvider.notifier).toggleDarkMode();
  }

  changeColorScheme(int value) {
    ref.read(configViewModelProvider.notifier).changeColorScheme(value);
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
      },
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: state.screenState.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        idle: () {
          return config();
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

  Widget config() {
    return ListView(
      children: [
        SwitchListTile(
            title: const Text('Dark Mode'),
            value: isDarkMode,
            onChanged: (value) {
              toggleDarkMode();
            }),
        const Divider(
          thickness: 2,
        ),
        ExpansionTile(
          title: const Text("Theme"),
          subtitle: Text(
            "Color $selectedColor",
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
                      "Color $index",
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
        )
      ],
    );
  }
}
