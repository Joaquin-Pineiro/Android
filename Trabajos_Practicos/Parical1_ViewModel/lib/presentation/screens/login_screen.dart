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

  bool keepSignedIn = false;
  bool obscureText = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(loginViewModelProvider.notifier).loadSavedCredentials();

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

  Future<bool> validateUser() async {
    return await ref.read(loginViewModelProvider.notifier).validateUser();
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

    return Scaffold(
        appBar: AppBar(
          title: const Text("Login"),
          centerTitle: true,
        ),
        body: state.screenState.when(
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          idle: () {
            if (state.userId == null) {
              return login(); // Proceed with showing the login form
            }
          },
          empty: () {
            return;
          },
          error: () => Center(
            child: Text('Error: ${state.error}'),
          ),
        ));
  }

  Widget login() {
    return SingleChildScrollView(
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
                value: keepSignedIn,
                onChanged: (value) {
                  updateKeepSignedIn(value ?? false);
                },
                child: const Text("Keep me signed in"),
              ),
              const SizedBox(height: 29),
              OutlinedButton(
                child: const Text('Log In'),
                onPressed: () async {
                  final result = await validateUser();
                  if (!result) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Wrong Username or Password")));
                  }
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("New at Breeds?"),
                  TextButton(
                      onPressed: () async {
                        context.pushNamed('UserProfile', extra: null);
                      },
                      child: const Text("Create Account"))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
