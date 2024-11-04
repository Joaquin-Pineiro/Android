import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parcial_1_pineiro/config/router/app_router.dart';
import 'package:parcial_1_pineiro/presentation/utils/base_state_screen.dart';
import 'package:parcial_1_pineiro/presentation/utils/functions.dart';
import 'package:parcial_1_pineiro/viewmodels/providers.dart';

class UserInfoField {
  final String field;
  final TextEditingController controller;
  final Icon? icon;
  final TextInputFormatter? formater;
  final bool? enableField;
  final bool obscureText;

  UserInfoField({
    required this.field,
    required this.controller,
    this.icon,
    this.formater,
    this.enableField,
    required this.obscureText,
  });
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
    final textsApp = ref.read(configViewModelProvider).textsApp;
    info = [
      UserInfoField(
          field: textsApp['Name']!,
          controller: nameController,
          formater: AlphabeticInputFormatter(),
          icon: const Icon(Icons.account_circle),
          obscureText: false),
      UserInfoField(
          field: textsApp["Last Name"]!,
          controller: lastNameController,
          formater: AlphabeticInputFormatter(),
          obscureText: false),
      UserInfoField(
          field: textsApp["Age"]!,
          controller: ageController,
          formater: NumericInputFormatter(),
          obscureText: false),
      UserInfoField(
          field: textsApp["Email"]!,
          controller: emailController,
          icon: const Icon(Icons.alternate_email),
          enableField: widget.userId != null ? false : true,
          obscureText: false),
      UserInfoField(
          field: textsApp["Location"]!,
          controller: locationController,
          formater: AlphabeticInputFormatter(),
          icon: const Icon(Icons.location_on_outlined),
          obscureText: false),
      UserInfoField(
          field: textsApp["City"]!,
          controller: cityController,
          formater: AlphabeticInputFormatter(),
          obscureText: false),
      UserInfoField(
          field: textsApp["Password"]!,
          controller: passwordController,
          enableField: widget.userId != null ? false : true,
          obscureText: widget.userId != null ? true : false),
    ];
  }

  Future<void> updateProfileImage() async {
    final textsApp = ref.read(configViewModelProvider).textsApp;
    final pickedFile = await showDialog<XFile?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(textsApp["Choose Profile Photo"]!),
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
          .read(loginDetailViewModelProvider.notifier)
          .updateProfileImage(pickedFile.path);
    }
  }

  Future<String?> updateAddUser() async {
    return await ref
        .read(loginDetailViewModelProvider.notifier)
        .updateAddUser();
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
    final textsApp = ref.watch(configViewModelProvider).textsApp;

    return Scaffold(
        appBar: AppBar(
          title: Text(textsApp["User Profile"]!),
          centerTitle: true,
        ),
        body: state.screenState.when(
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          idle: () {
            return _loginDetail(textsApp);
          },
          empty: () {
            return _loginDetail(textsApp);
          },
          error: () {
            return _loginDetail(textsApp);
          },
        ));
  }

  Widget _loginDetail(Map<String, String> textsApp) {
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
                        textsApp: textsApp,
                        obscureText: info.obscureText,
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
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                final result = await updateAddUser();

                                if (result == 'weak-password') {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(textsApp[
                                              'The password provided is too weak.']!)));
                                } else if (result == 'email-already-in-use') {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(textsApp[
                                              'The account already exists for that email.']!)));
                                } else if (result == 'invalid-email') {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(textsApp[
                                            'Invalid e-mail format']!)),
                                  );
                                } else {
                                  context.goNamed('Breeds', extra: result);
                                }
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

class UserInfoView extends StatelessWidget {
  const UserInfoView({
    super.key,
    required this.field,
    required this.textController,
    this.icon,
    this.formater,
    this.enableField = true,
    required this.textsApp,
    required this.obscureText,
  });
  final String field;
  final bool? enableField;
  final TextEditingController textController;
  final Icon? icon;
  final TextInputFormatter? formater;
  final Map<String, String> textsApp;
  final bool obscureText;

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
              obscureText: obscureText,
              decoration: InputDecoration(
                labelText: field,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: false,
              ),
              inputFormatters: (formater != null) ? [formater!] : null,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return textsApp['Please enter some text'];
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
