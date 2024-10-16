import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parcial_1_pineiro/domain/models/app_theme.dart';
import 'package:parcial_1_pineiro/presentation/providers/theme_provider.dart';

class ConfigScreen extends ConsumerWidget {
  const ConfigScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    bool isDarkMode = ref.watch(themeNotifierProvider).isDarkMode;
    int selectedColor = ref.watch(themeNotifierProvider).selectedColor;
    //List<Color> colorList = ref.watch(colorListProvider);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: ListView(
          children: [
            SwitchListTile(
                title: const Text('Dark Mode'),
                value: isDarkMode,
                onChanged: (value) {
                  ref.read(themeNotifierProvider.notifier).toggleDarkMode();
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
                        subtitle: Text(
                            "# ${colorList[index].value.toRadixString(16)}"),
                        value: index,
                        groupValue: selectedColor,
                        onChanged: (value) {
                          ref
                              .read(themeNotifierProvider.notifier)
                              .changeColorScheme(value ?? 0);
                        },
                      );
                    },
                  ),
                )
              ],
            )
          ],
        ));
  }
}
// enum Transportation { car, bike, bus, train }

// bool isBreakfast = false;
// bool isLunch = false;

// class ConfigScreen extends StatefulWidget {
//   static const name = 'ui_controls_screen';
//   const ConfigScreen({super.key});

//   @override
//   State<ConfigScreen> createState() => _ConfigScreenState();
// }

// class _ConfigScreenState extends State<ConfigScreen> {
//   bool isDeveloper = false;
//   Transportation selectedTransport = Transportation.car;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Settings'),
//       ),
//       body: ListView(
//         children: [
//           SwitchListTile(
//               title: const Text('Developer mode'),
//               subtitle: const Text('Enable developer mode'),
//               value: isDeveloper,
//               onChanged: (value) {
//                 setState(() {
//                   isDeveloper = !isDeveloper;
//                 });
//               }),
//           ExpansionTile(
//             title: const Text('Theme'),
//             subtitle: Text('$selectedTransport'),
//             children: [
//               RadioListTile(
//                 value: Transportation.car,
//                 groupValue: selectedTransport,
//                 onChanged: (value) {
//                   setState(() {
//                     selectedTransport = value as Transportation;
//                   });
//                 },
//                 title: Text(Transportation.car.name),
//                 subtitle: const Text('Travel by car'),
//               ),
//               RadioListTile(
//                 value: Transportation.bike,
//                 groupValue: selectedTransport,
//                 onChanged: (value) {
//                   setState(() {
//                     selectedTransport = value as Transportation;
//                   });
//                 },
//                 title: Text(Transportation.bike.name),
//                 subtitle: const Text('Travel by bike'),
//               ),
//               RadioListTile(
//                 value: Transportation.bus,
//                 groupValue: selectedTransport,
//                 onChanged: (value) {
//                   setState(() {
//                     selectedTransport = value as Transportation;
//                   });
//                 },
//                 title: Text(Transportation.bus.name),
//                 subtitle: const Text('Travel by bus'),
//               ),
//               RadioListTile(
//                 value: Transportation.train,
//                 groupValue: selectedTransport,
//                 onChanged: (value) {
//                   setState(() {
//                     selectedTransport = value as Transportation;
//                   });
//                 },
//                 title: Text(Transportation.train.name),
//                 subtitle: const Text('Travel by train'),
//               ),
//             ],
//           ),
//           CheckboxListTile(
//             value: isBreakfast,
//             onChanged: (value) => {
//               setState(() {
//                 isBreakfast = !isBreakfast;
//               })
//             },
//             title: const Text('Breakfast?'),
//           ),
//           CheckboxListTile(
//             value: isLunch,
//             onChanged: (value) => {
//               setState(() {
//                 isLunch = !isLunch;
//               })
//             },
//             title: const Text('Launch?'),
//           )
//         ],
//       ),
//     );
//   }
// }
