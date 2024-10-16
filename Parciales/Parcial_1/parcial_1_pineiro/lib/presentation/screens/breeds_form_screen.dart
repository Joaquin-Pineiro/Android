import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parcial_1_pineiro/data/local_breeds_repository.dart';
import 'package:parcial_1_pineiro/domain/models/breed.dart';
import 'package:parcial_1_pineiro/presentation/screens/functions.dart';

class BreedsFormScreen extends StatefulWidget {
  BreedsFormScreen({super.key, required this.repository, this.breed});
  final LocalBreedRepository repository;
  Breed? breed;

  @override
  State<BreedsFormScreen> createState() => _BreedsFormScreenState();
}

class _BreedsFormScreenState extends State<BreedsFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final breedController = TextEditingController();

  final weightController = TextEditingController();

  final heightController = TextEditingController();

  final originController = TextEditingController();

  final lifeExpectancyController = TextEditingController();

  final descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.breed != null) {
      breedController.text = (widget.breed!).breed;
      weightController.text =
          widget.breed!.weight.replaceAll(RegExp(r'[^0-9-]'), '');
      heightController.text =
          widget.breed!.height.replaceAll(RegExp(r'[^0-9-]'), '');
      originController.text = (widget.breed!).origin;
      descriptionController.text = (widget.breed!).description;
      lifeExpectancyController.text =
          widget.breed!.lifeExpectancy.replaceAll(RegExp(r'[^0-9-]'), '');
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.breed == null
            ? const Text("New Breed")
            : const Text("Config Breed"),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Profile image or generic user avatar
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 0,
                      ),
                    ),
                    child: (widget.breed != null &&
                            widget.breed!.posterUrl_1 != null)
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.network(
                              widget.breed!.posterUrl_1!,
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
                              size: 50,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                          ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: breedController,
                    decoration: InputDecoration(
                        labelText: "Breed",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        filled: false,
                        prefixIcon: Icon(Icons.pets)),
                    inputFormatters: [AlphabeticInputFormatter()],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: weightController,
                    decoration: InputDecoration(
                        labelText: "Weight",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        filled: false,
                        prefixIcon: Icon(Icons.fitness_center),
                        suffixText: ("kg")),
                    inputFormatters: [NumericInputFormatter()],
                    onChanged: (value) {
                      prettyText(weightController, value);
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: heightController,
                    decoration: InputDecoration(
                        labelText: "Height",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        filled: false,
                        prefixIcon: Icon(Icons.height),
                        suffixText: ("cm")),
                    inputFormatters: [NumericInputFormatter()],
                    onChanged: (value) {
                      prettyText(heightController, value);
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: originController,
                    decoration: InputDecoration(
                        labelText: "Origin",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        filled: false,
                        prefixIcon: Icon(Icons.public)),
                    inputFormatters: [AlphabeticInputFormatter()],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: lifeExpectancyController,
                    decoration: InputDecoration(
                        labelText: "Life Expectancy",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        filled: false,
                        prefixIcon: Icon(Icons.access_time),
                        suffixText: 'years'),
                    inputFormatters: [NumericInputFormatter()],
                    onChanged: (value) {
                      prettyText(lifeExpectancyController, value);
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                        labelText: "Description",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        filled: false,
                        prefixIcon: Icon(Icons.notes)),
                    inputFormatters: [AlphabeticInputFormatter()],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          child: const Text("Cancel")),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              if (widget.breed == null) {
                                Breed newBreed = Breed(
                                    id: null,
                                    breed: breedController.text,
                                    weight: "${weightController.text} kg",
                                    height: "${heightController.text} cm",
                                    origin: originController.text,
                                    posterUrl_1: null,
                                    posterUrl_2: null,
                                    posterUrl_3: null,
                                    lifeExpectancy:
                                        lifeExpectancyController.text,
                                    description: descriptionController.text);
                                widget.repository.insertBreed(newBreed);
                              } else {
                                (widget.breed!).breed = breedController.text;
                                (widget.breed!).weight =
                                    "${weightController.text} kg";
                                (widget.breed!).height =
                                    "${heightController.text} cm";
                                (widget.breed!).lifeExpectancy =
                                    "${lifeExpectancyController.text} years";
                                (widget.breed!).origin = originController.text;
                                widget.repository.updateBreed(widget.breed!);
                              }
                              Navigator.pop(context, true);
                            }
                          },
                          child: const Text("Submit")),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
