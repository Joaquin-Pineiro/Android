import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parcial_1_pineiro/presentation/utils/base_state_screen.dart';
import 'package:parcial_1_pineiro/presentation/utils/functions.dart';
import 'package:parcial_1_pineiro/viewmodels/providers.dart';

class UserInfoField {
  final String field;
  final TextEditingController controller;
  final Icon? icon;
  final TextInputFormatter? formater;
  final bool? enableField;

  UserInfoField(
      {required this.field,
      required this.controller,
      this.icon,
      this.formater,
      this.enableField});
}

class LoginDetailScreen extends ConsumerStatefulWidget {
  const LoginDetailScreen({super.key, required this.userId});

  final String? userId;
  @override
  ConsumerState<LoginDetailScreen> createState() => _LoginDetailScreenState();
}

class _LoginDetailScreenState extends ConsumerState<LoginDetailScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  final nameController = TextEditingController();

  final lastNameController = TextEditingController();

  final emailController = TextEditingController();

  final cityController = TextEditingController();

  final locationController = TextEditingController();

  final passwordController = TextEditingController();

  final ageController = TextEditingController();

  late List<UserInfoField> info;

  String _profileImage = "";
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref
          .read(loginDetailViewModelProvider.notifier)
          .fetchUser(widget.userId);
      nameController.addListener(
        () {
          ref
              .read(loginDetailViewModelProvider.notifier)
              .updateNameText(nameController.text);
        },
      );
      lastNameController.addListener(
        () {
          ref
              .read(loginDetailViewModelProvider.notifier)
              .updateLastNameText(lastNameController.text);
        },
      );
      emailController.addListener(
        () {
          ref
              .read(loginDetailViewModelProvider.notifier)
              .updateEmailText(emailController.text);
        },
      );
      cityController.addListener(
        () {
          ref
              .read(loginDetailViewModelProvider.notifier)
              .updateCityText(cityController.text);
        },
      );

      locationController.addListener(
        () {
          ref
              .read(loginDetailViewModelProvider.notifier)
              .updateLocationText(locationController.text);
        },
      );
      passwordController.addListener(
        () {
          ref
              .read(loginDetailViewModelProvider.notifier)
              .updatePswText(passwordController.text);
        },
      );
      ageController.addListener(
        () {
          ref
              .read(loginDetailViewModelProvider.notifier)
              .updateAgeText(ageController.text);
        },
      );

      nameController.text = ref.read(loginDetailViewModelProvider).inputName;
      lastNameController.text =
          ref.read(loginDetailViewModelProvider).inputLastName;
      emailController.text = ref.read(loginDetailViewModelProvider).inputEmail;
      cityController.text = ref.read(loginDetailViewModelProvider).inputCity;
      locationController.text =
          ref.read(loginDetailViewModelProvider).inputLocation;
      ageController.text = ref.read(loginDetailViewModelProvider).inputAge;
      passwordController.text =
          ref.read(loginDetailViewModelProvider).inputPassword;
      _profileImage = ref.read(loginDetailViewModelProvider).inputProfileImage;
    });
    info = [
      UserInfoField(
          field: "Name",
          controller: nameController,
          formater: AlphabeticInputFormatter(),
          icon: const Icon(Icons.account_circle)),
      UserInfoField(
          field: "Last Name",
          controller: lastNameController,
          formater: AlphabeticInputFormatter()),
      UserInfoField(
          field: "Age",
          controller: ageController,
          formater: NumericInputFormatter()),
      UserInfoField(
          field: "Email",
          controller: emailController,
          icon: const Icon(Icons.alternate_email)),
      UserInfoField(
          field: "Location",
          controller: locationController,
          formater: AlphabeticInputFormatter(),
          icon: const Icon(Icons.location_on_outlined)),
      UserInfoField(
        field: "City",
        controller: cityController,
        formater: AlphabeticInputFormatter(),
      ),
      UserInfoField(
          field: "Password",
          controller: passwordController,
          enableField: widget.userId != null ? false : true),
    ];
  }

  Future<void> updateProfileImage() async {
    // Show a dialog to choose between camera or gallery
    final pickedFile = await showDialog<XFile?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Choose Profile Photo"),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                ListTile(
                  leading: const Icon(Icons.camera),
                  title: const Text('Camera'),
                  onTap: () async {
                    final image =
                        await _picker.pickImage(source: ImageSource.camera);
                    Navigator.pop(context, image);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo),
                  title: const Text('Gallery'),
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
          .read(loginDetailViewModelProvider.notifier)
          .updateProfileImage(pickedFile.path);
    }
  }

  void updateAddUser() {
    ref.read(loginDetailViewModelProvider.notifier).updateAddUser();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      loginDetailViewModelProvider,
      (_, state) {
        _profileImage = state.inputProfileImage;
      },
    );
    final state = ref.watch(loginDetailViewModelProvider);

    return Scaffold(
        appBar: AppBar(
          title: const Text("User Profile"),
          centerTitle: true,
        ),
        body: state.screenState.when(
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          idle: () {
            return _loginDetail();
          },
          empty: () {
            return _loginDetail();
          },
          error: () => Center(
            child: Text('Error: ${state.error}'),
          ),
        ));
  }

  Widget _loginDetail() {
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
                      updateProfileImage();
                    }, // Handle avatar tap
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: (_profileImage != "")
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.file(
                                File(_profileImage),
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
                                Icons.account_circle,
                                size: 100,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                            ),
                    ),
                  ),
                  ...info.map((info) => UserInfoView(
                        field: info.field,
                        textController: info.controller,
                        formater: info.formater,
                        icon: info.icon,
                        enableField: info.enableField,
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
                            child: const Text("Cancel")),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                updateAddUser();
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
      ),
    );
  }
}

class UserInfoView extends StatelessWidget {
  const UserInfoView({
    super.key,
    required this.field,
    required this.textController,
    this.icon,
    this.formater,
    this.enableField = true,
  });
  final String field;
  final bool? enableField;
  final TextEditingController textController;
  final Icon? icon;
  final TextInputFormatter? formater;

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
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: false,
              ),
              inputFormatters: (formater != null) ? [formater!] : null,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
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
