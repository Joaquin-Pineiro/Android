import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parcial_1_pineiro/presentation/utils/base_state_screen.dart';
import 'package:parcial_1_pineiro/presentation/utils/functions.dart';
import 'package:parcial_1_pineiro/viewmodels/providers.dart';

class BreedInfoField {
  final String field;
  final TextEditingController controller;
  final Icon? icon;
  final TextInputFormatter? formater;
  final bool? enableField;
  final String? suffixText;
  final Function? prettyText;

  BreedInfoField({
    required this.field,
    required this.controller,
    this.icon,
    this.formater,
    this.enableField,
    this.suffixText,
    this.prettyText,
  });
}

class BreedDetailScreen extends ConsumerStatefulWidget {
  const BreedDetailScreen({super.key, required this.breedId});

  final String? breedId;
  @override
  ConsumerState<BreedDetailScreen> createState() => _BreedDetailScreenState();
}

class _BreedDetailScreenState extends ConsumerState<BreedDetailScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  final breedNameController = TextEditingController();

  final weightController = TextEditingController();

  final heightController = TextEditingController();

  final originController = TextEditingController();

  final lifeExpectancyController = TextEditingController();

  final descriptionController = TextEditingController();

  late List<BreedInfoField> info;

  String _posterUrl1 = "";
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref
          .read(breedsDetailViewModelProvider.notifier)
          .fetchBreed(widget.breedId);

      breedNameController.addListener(
        () {
          ref
              .read(breedsDetailViewModelProvider.notifier)
              .updateBreedNameText(breedNameController.text);
        },
      );
      weightController.addListener(
        () {
          ref
              .read(breedsDetailViewModelProvider.notifier)
              .updateWeightText(weightController.text);
        },
      );
      heightController.addListener(
        () {
          ref
              .read(breedsDetailViewModelProvider.notifier)
              .updateHeightText(heightController.text);
        },
      );
      originController.addListener(
        () {
          ref
              .read(breedsDetailViewModelProvider.notifier)
              .updateOriginText(originController.text);
        },
      );

      lifeExpectancyController.addListener(
        () {
          ref
              .read(breedsDetailViewModelProvider.notifier)
              .updateLifeExpectancyText(lifeExpectancyController.text);
        },
      );
      descriptionController.addListener(
        () {
          ref
              .read(breedsDetailViewModelProvider.notifier)
              .updateDescriptionText(descriptionController.text);
        },
      );

      breedNameController.text =
          ref.read(breedsDetailViewModelProvider).inputBreedName;
      weightController.text =
          ref.read(breedsDetailViewModelProvider).inputWeight;
      heightController.text =
          ref.read(breedsDetailViewModelProvider).inputHeight;
      originController.text =
          ref.read(breedsDetailViewModelProvider).inputOrigin;
      lifeExpectancyController.text =
          ref.read(breedsDetailViewModelProvider).inputLifeExpectancy;
      descriptionController.text =
          ref.read(breedsDetailViewModelProvider).inputDescription;

      _posterUrl1 = ref.read(breedsDetailViewModelProvider).inputPosterUrl_1;
    });
    final textsApp = ref.read(configViewModelProvider).textsApp;
    info = [
      BreedInfoField(
          field: textsApp["Name"]!,
          controller: breedNameController,
          formater: AlphabeticInputFormatter(),
          icon: const Icon(Icons.pets)),
      BreedInfoField(
          field: textsApp["Weight"]!,
          controller: weightController,
          formater: NumericInputFormatter(),
          icon: const Icon(Icons.fitness_center),
          suffixText: ("kg"),
          prettyText: prettyText),
      BreedInfoField(
          field: textsApp["Height"]!,
          controller: heightController,
          formater: NumericInputFormatter(),
          icon: const Icon(Icons.height),
          suffixText: ("cm"),
          prettyText: prettyText),
      BreedInfoField(
          field: textsApp["Origin"]!,
          controller: originController,
          formater: AlphabeticInputFormatter(),
          icon: const Icon(Icons.public)),
      BreedInfoField(
          field: textsApp["Life Expectancy"]!,
          controller: lifeExpectancyController,
          formater: NumericInputFormatter(),
          icon: const Icon(Icons.access_time),
          suffixText: ("years"),
          prettyText: prettyText),
      BreedInfoField(
        field: textsApp["Description"]!,
        controller: descriptionController,
        formater: AlphabeticInputFormatter(),
        icon: const Icon(Icons.notes),
      ),
    ];
  }

  void prettyText(TextEditingController textController, String value) {
    // Remove any previous hyphen to avoid multiple hyphens
    String cleanedValue = value.replaceAll('-', '');

    if (cleanedValue.length > 2) {
      // Insert hyphen after the second digit
      cleanedValue =
          cleanedValue.substring(0, 2) + '-' + cleanedValue.substring(2);
    }

    // Update the controller with the formatted value
    textController.value = TextEditingValue(
      text: cleanedValue,
      selection: TextSelection.collapsed(offset: cleanedValue.length),
    );
  }

  Future<void> updateProfileImage(Map<String, String> textsApp) async {
    // Show a dialog to choose between camera or gallery
    final pickedFile = await showDialog<XFile?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(textsApp["Choose Breed Photo"]!),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                ListTile(
                  leading: const Icon(Icons.camera),
                  title: Text(textsApp['Camera']!),
                  onTap: () async {
                    final image =
                        await _picker.pickImage(source: ImageSource.camera);
                    Navigator.pop(context, image);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo),
                  title: Text(textsApp['Gallery']!),
                  onTap: () async {
                    final image =
                        await _picker.pickImage(source: ImageSource.gallery);
                    Navigator.pop(context, image);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
    if (pickedFile != null) {
      ref
          .read(breedsDetailViewModelProvider.notifier)
          .updatePosterUrl1(pickedFile.path);
    }
  }

  void updateAddBreed() {
    ref.read(breedsDetailViewModelProvider.notifier).updateAddBreed();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      breedsDetailViewModelProvider,
      (_, state) {
        _posterUrl1 = state.inputPosterUrl_1;
      },
    );
    final state = ref.watch(breedsDetailViewModelProvider);
    final textsApp = ref.watch(configViewModelProvider).textsApp;
    return Scaffold(
        appBar: AppBar(
          title: Text(textsApp["Dog Breed Detail"]!),
          centerTitle: true,
        ),
        body: state.screenState.when(
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          idle: () {
            return _breedDetail(textsApp);
          },
          empty: () {
            return _breedDetail(textsApp);
          },
          error: () => Center(
            child: Text('Error: ${state.error}'),
          ),
        ));
  }

  Widget _breedDetail(Map<String, String> textsApp) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      updateProfileImage(textsApp);
                    }, // Handle avatar tap
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: (_posterUrl1 != "")
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.network(
                                _posterUrl1,
                                width: 200,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            )
                          : CircleAvatar(
                              radius: 50,
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerHighest,
                              child: Icon(
                                Icons.pets,
                                size: 100,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                            ),
                    ),
                  ),
                  ...info.map((info) => BreedDetailView(
                        field: info.field,
                        textController: info.controller,
                        formater: info.formater,
                        icon: info.icon,
                        enableField: info.enableField,
                        suffixText: info.suffixText,
                        prettyText: info.prettyText,
                        textsApp: textsApp,
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextButton(
                            onPressed: () {
                              Navigator.pop(context, false);
                            },
                            child: Text(textsApp["Cancel"]!)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                updateAddBreed();
                                Navigator.pop(context, true);
                              }
                            },
                            child: Text(textsApp["Submit"]!)),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BreedDetailView extends StatelessWidget {
  const BreedDetailView({
    super.key,
    required this.field,
    required this.textController,
    this.icon,
    this.formater,
    this.enableField = true,
    this.suffixText,
    this.prettyText,
    required this.textsApp,
  });
  final String field;
  final bool? enableField;
  final TextEditingController textController;
  final Icon? icon;
  final TextInputFormatter? formater;
  final String? suffixText;
  final Function? prettyText;
  final Map<String, String> textsApp;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          if (icon != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: icon,
            )
          else
            const SizedBox(width: 41),
          Expanded(
            child: TextFormField(
              enabled: enableField,
              controller: textController,
              decoration: InputDecoration(
                  labelText: field,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  filled: false,
                  suffixText: suffixText != null ? suffixText : null),
              inputFormatters: (formater != null) ? [formater!] : null,
              onChanged: (value) {
                if (prettyText == null) {
                  return;
                } else {
                  prettyText!(textController, value);
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return textsApp['Please enter some text']!;
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}
