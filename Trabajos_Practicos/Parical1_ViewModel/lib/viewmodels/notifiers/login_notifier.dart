import 'dart:developer';

import 'package:encrypt_shared_preferences/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parcial_1_pineiro/data/providers.dart';
import 'package:parcial_1_pineiro/domain/models/user.dart';
import 'package:parcial_1_pineiro/presentation/utils/base_state_screen.dart';
import 'package:parcial_1_pineiro/viewmodels/states/login_state.dart';

class LoginNotifier extends Notifier<LoginState> {
  @override
  LoginState build() {
    return LoginState.initial();
  }

  void updateUsrText(String usrText) {
    state = state.copyWith(inputUsr: usrText);
  }

  void updatePswText(String pswText) {
    state = state.copyWith(inputPsw: pswText);
  }

  void updateKeepSignedIn(bool keepSignedIn) {
    state = state.copyWith(keepSignedIn: keepSignedIn);
  }

  Future<void> loadSavedCredentials() async {
    final prefs = EncryptedSharedPreferences.getInstance();
    final String usr;
    final String psw;
    final keepSignedIn = prefs.getBoolean('keepSignedIn') ?? false;

    final auth.User? userCredentials = auth.FirebaseAuth.instance.currentUser;

    log("Cargando Credenciales");
    if (keepSignedIn == true) {
      usr = prefs.getString('email') ?? '';
      psw = prefs.getString('password') ?? '';
      log("Credenciales Cargadas");
      if (userCredentials == null) {
        state = state.copyWith(
            keepSignedIn: keepSignedIn,
            inputUsr: usr,
            inputPsw: psw,
            setUserIdNull: true);
      } else {
        state = state.copyWith(
            keepSignedIn: keepSignedIn,
            inputUsr: usr,
            inputPsw: psw,
            userId: userCredentials.uid,
            setUserIdNull: false);
      }
    } else {
      log("Credenciales NO Cargadas");
      if (userCredentials == null) {
        state = state.copyWith(
            keepSignedIn: keepSignedIn,
            inputUsr: "",
            inputPsw: "",
            setUserIdNull: true);
      } else {
        state = state.copyWith(
            keepSignedIn: keepSignedIn,
            inputUsr: "",
            inputPsw: "",
            userId: userCredentials.uid,
            setUserIdNull: false);
      }
    }
  }

  Future<void> saveCredentials() async {
    final prefs = EncryptedSharedPreferences.getInstance();
    await prefs.setBoolean('keepSignedIn', state.keepSignedIn);
    if (state.keepSignedIn == true) {
      log("Credenciales Guardadas");
      await prefs.setString('email', state.inputUsr);
      await prefs.setString('password', state.inputPsw);
    }
  }

  Future<void> clearCredentials() async {
    final prefs = EncryptedSharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.remove('password');
    await prefs.remove('keepSignedIn');
  }

  Future<String?> signIn() async {
    try {
      state = state.copyWith(
        screenState: BaseScreenState.idle,
        userId: null,
        error: '',
      );
      final credential = await auth.FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: state.inputUsr, password: state.inputPsw);
      state = state.copyWith(
        screenState: BaseScreenState.idle,
        userId: credential.user!.uid,
      );
      if (state.keepSignedIn == true) {
        await saveCredentials();
      } else {
        await clearCredentials();
      }
      return null;
    } on auth.FirebaseAuthException catch (e) {
      state = state.copyWith(
        screenState: BaseScreenState.error,
        error: e.code.toString(),
      );
      log(e.code.toString());
      return state.error;
    }
  }
}
