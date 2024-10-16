import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parcial_1_pineiro/data/local_users_repository.dart';
import 'package:parcial_1_pineiro/domain/models/user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parcial_1_pineiro/presentation/screens/functions.dart';

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

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen(
      {super.key, required this.user, required this.repository});
  final User? user;
  final LocalUserRepository repository;

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  String? _profileImage;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();

  final lastNameController = TextEditingController();

  final emailController = TextEditingController();

  final cityController = TextEditingController();

  final locationController = TextEditingController();

  final passwordController = TextEditingController();

  final ageController = TextEditingController();

  late List<UserInfoField> info;

  Future<void> _updateProfileImage() async {
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

    // If an image was picked, update the profile image state
    if (pickedFile != null) {
      setState(() {
        _profileImage = pickedFile.path;
        if (widget.user != null) {
          widget.user!.profileImg = _profileImage;
          widget.repository.updateUser(widget.user!);
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      nameController.text = widget.user!.name;
      lastNameController.text = widget.user!.lastName;
      emailController.text = widget.user!.email;
      cityController.text = widget.user!.city;
      locationController.text = widget.user!.location;
      ageController.text = widget.user!.age;
      passwordController.text = widget.user!.password;
    }

    info = [
      UserInfoField(
          field: "Name",
          controller: nameController,
          formater: AlphabeticInputFormatter(),
          icon: Icon(Icons.account_circle)),
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
          icon: Icon(Icons.alternate_email)),
      UserInfoField(
          field: "Location",
          controller: locationController,
          formater: AlphabeticInputFormatter(),
          icon: Icon(Icons.location_on_outlined)),
      UserInfoField(
          field: "Password",
          controller: passwordController,
          enableField: widget.user != null ? false : true),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Profile"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Profile image or generic user avatar
                    GestureDetector(
                      onTap: _updateProfileImage, // Handle avatar tap
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: (widget.user != null &&
                                widget.user!.profileImg != null &&
                                widget.user!.profileImg!.isNotEmpty)
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.file(
                                  File(widget.user!.profileImg!),
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
                                  if (widget.user == null) {
                                    User newUser = User(
                                        id: null,
                                        name: nameController.text,
                                        lastName: lastNameController.text,
                                        email: emailController.text,
                                        age: ageController.text,
                                        location: locationController.text,
                                        city: cityController.text,
                                        password: passwordController.text,
                                        profileImg: _profileImage);
                                    widget.repository.insertUser(newUser);
                                  } else {
                                    widget.user!.name = nameController.text;
                                    widget.user!.lastName =
                                        lastNameController.text;
                                    widget.user!.email = emailController.text;
                                    widget.user!.age = ageController.text;
                                    widget.user!.city = cityController.text;
                                    widget.user!.location =
                                        locationController.text;
                                    widget.user!.password =
                                        passwordController.text;
                                    widget.repository.updateUser(widget.user!);
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
            SizedBox(width: 41),
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
