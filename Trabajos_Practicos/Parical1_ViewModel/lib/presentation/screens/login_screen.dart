import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:parcial_1_pineiro/presentation/utils/base_state_screen.dart';
import 'package:parcial_1_pineiro/viewmodels/providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _inputUser = TextEditingController();
  final TextEditingController _inputPsw = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool keepSignedIn = false;
  bool obscureText = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(loginViewModelProvider.notifier).loadSavedCredentials();
      ref.read(configViewModelProvider.notifier).restoreConfiguration();

      _inputUser.text = ref.read(loginViewModelProvider).inputUsr;
      _inputPsw.text = ref.read(loginViewModelProvider).inputPsw;

      _inputUser.addListener(
        () {
          ref
              .read(loginViewModelProvider.notifier)
              .updateUsrText(_inputUser.text);
        },
      );

      _inputPsw.addListener(
        () {
          ref
              .read(loginViewModelProvider.notifier)
              .updatePswText(_inputPsw.text);
        },
      );
    });
  }

  Future<String?> signIn() async {
    return await ref.read(loginViewModelProvider.notifier).signIn();
  }

  void updateKeepSignedIn(bool value) {
    ref.read(loginViewModelProvider.notifier).updateKeepSignedIn(value);
  }

  void saveCredentials() {
    ref.read(loginViewModelProvider.notifier).saveCredentials();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      loginViewModelProvider,
      (_, state) {
        if (state.userId != null) {
          saveCredentials();
          context.goNamed("Breeds", extra: state.userId);
        }

        keepSignedIn = state.keepSignedIn;
      },
    );

    final state = ref.watch(loginViewModelProvider);
    final textsApp = ref.watch(configViewModelProvider).textsApp;
    return Scaffold(
        appBar: AppBar(
          title: Text(textsApp["Log In"]!),
          centerTitle: true,
        ),
        body: state.screenState.when(
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          idle: () {
            if (state.userId == null) {
              return login(textsApp); // Proceed with showing the login form
            }
          },
          empty: () {
            if (state.userId == null) {
              return login(textsApp); // Proceed with showing the login form
            }
          },
          error: () {
            return login(textsApp);
          },
        ));
  }

  Widget login(Map<String, String> textsApp) {
    return SingleChildScrollView(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Center(
          child: Form(
            key: _formKey,
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
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'abc@gmail.com',
                      hintStyle: TextStyle(color: Colors.grey.shade700),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon: IconButton(
                          onPressed: _inputUser.clear,
                          icon: const Icon(Icons.clear)),
                    ),
                    controller: _inputUser,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return textsApp['Please enter some text'];
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: textsApp['Password'],
                      hintStyle: TextStyle(color: Colors.grey.shade700),
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return textsApp['Please enter some text'];
                      }
                      return null;
                    },
                  ),
                ),
                CheckboxMenuButton(
                  value: keepSignedIn,
                  onChanged: (value) {
                    updateKeepSignedIn(value ?? false);
                  },
                  child: Text(textsApp['Keep me signed in']!),
                ),
                const SizedBox(height: 29),
                OutlinedButton(
                  child: Text(textsApp['Log In']!),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final result = await signIn();

                      if (result == 'wrong-password') {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(textsApp['Wrong Password']!)));
                      } else if (result == 'user-not-found') {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(textsApp['User not Found']!)));
                      } else if (result == 'invalid-email') {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(textsApp['Invalid e-mail format']!),
                        ));
                      } else if (result == 'invalid-credential') {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(textsApp['Wrong Password or Email']!),
                        ));
                      }
                    }
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(textsApp['New at Dog Breeds?']!),
                    TextButton(
                        onPressed: () async {
                          context.pushNamed('UserProfile', extra: null);
                        },
                        child: Text(textsApp['Create Account']!))
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
