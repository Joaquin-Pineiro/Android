import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parcial_1_pineiro/data/local_users_repository.dart';
import 'package:parcial_1_pineiro/domain/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String parameter = 'ale';

  final TextEditingController _inputUser = TextEditingController();
  final TextEditingController _inputPsw = TextEditingController();
  final repository = LocalUserRepository();
  bool userOk = false;
  bool pswOk = false;
  bool _keepSignedIn = false;

  bool obscureText = true;

  @override
  void initState() {
    super.initState();
    // Load saved credentials when the screen initializes
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _keepSignedIn = prefs.getBool('keepSignedIn') ?? false;
      if (_keepSignedIn == true) {
        _inputUser.text = prefs.getString('email') ?? '';
        _inputPsw.text = prefs.getString('password') ?? '';
      }
    });
  }

  Future<void> _saveCredentials(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('keepSignedIn', _keepSignedIn);
    if (_keepSignedIn == true) {
      await prefs.setString('email', email);
      await prefs.setString('password', password);
    }
  }

  Future<void> _clearCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.remove('password');
    await prefs.remove('keepSignedIn');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: SizedBox(
                      child: Image.asset(
                    'assets/Dog_Breeds_app_logo.png',
                    height: 300,
                  )),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon: IconButton(
                          onPressed: _inputUser.clear,
                          icon: const Icon(Icons.clear)),
                    ),
                    controller: _inputUser,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Password',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      suffixIcon: GestureDetector(
                        child: Icon(obscureText
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onTapDown: (details) {
                          setState(() {
                            obscureText = false;
                          });
                        },
                        onTapUp: (details) {
                          setState(() {
                            obscureText = true;
                          });
                        },
                      ),
                    ),
                    controller: _inputPsw,
                    obscureText: obscureText,
                  ),
                ),
                CheckboxMenuButton(
                  value: _keepSignedIn,
                  onChanged: (value) {
                    setState(() {
                      _keepSignedIn = value ?? false;
                    });
                  },
                  child: Text("Keep me signed in"),
                ),
                const SizedBox(height: 29),
                OutlinedButton(
                  child: const Text('Log In'),
                  onPressed: () async {
                    List<User> users = await repository.getUsers();
                    for (var element in users) {
                      log('Psw_element: ${element.password}');
                      log('User_element: ${element.email}');
                      if (_inputUser.text == element.email) {
                        userOk = true;
                        if (_inputPsw.text == element.password) {
                          parameter = element.name;
                          // Save email and password in SharedPreferences
                          if (_keepSignedIn == true)
                            await _saveCredentials(
                                _inputUser.text, _inputPsw.text);
                          else
                            await _clearCredentials();
                          context.goNamed("Breeds", extra: element);
                          pswOk = true;
                          break;
                        } else {
                          pswOk = false;
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Wrong Password")));
                          break;
                        }
                      } else {
                        userOk = false;
                      }
                    }
                    if (userOk == false) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Wrong Username")));
                    }
                    log('Psw: ${_inputPsw.text}');
                    log('User: ${_inputUser.text}');
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("New at Breeds?"),
                    TextButton(
                        onPressed: () async {
                          final result = await context.pushNamed('UserProfile',
                              extra: {'repository': repository, 'breed': null});
                        },
                        child: Text("Create Account"))
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
