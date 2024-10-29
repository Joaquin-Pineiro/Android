import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parcial_1_pineiro/data/providers.dart';
import 'package:parcial_1_pineiro/domain/models/user.dart';
import 'package:parcial_1_pineiro/presentation/utils/base_state_screen.dart';
import 'package:parcial_1_pineiro/viewmodels/states/login_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    final prefs = await SharedPreferences.getInstance();
    final String usr;
    final String psw;
    final keepSignedIn = prefs.getBool('keepSignedIn') ?? false;

    log("Cargando Credenciales");
    if (keepSignedIn == true) {
      usr = prefs.getString('email') ?? '';
      psw = prefs.getString('password') ?? '';
      log("Credenciales Cargadas");
      state = state.copyWith(
          keepSignedIn: keepSignedIn,
          inputUsr: usr,
          inputPsw: psw,
          setUserIdNull: true);
    } else {
      log("Credenciales NO Cargadas");
      state = state.copyWith(
          keepSignedIn: keepSignedIn,
          inputUsr: "",
          inputPsw: "",
          setUserIdNull: true);
    }
  }

  Future<void> saveCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('keepSignedIn', state.keepSignedIn);
    if (state.keepSignedIn == true) {
      log("Credenciales Guardadas");
      await prefs.setString('email', state.inputUsr);
      await prefs.setString('password', state.inputPsw);
    }
  }

  Future<void> clearCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.remove('password');
    await prefs.remove('keepSignedIn');
  }

  Future<bool> validateUser() async {
    final usersRepository = ref.read(usersRepositoryProvider);
    final List<User> users;
    try {
      users = await usersRepository.getUsers();
      state = state.copyWith(
        screenState: BaseScreenState.idle,
        userId: null,
        error: '',
      );
    } catch (e) {
      state = state.copyWith(
        screenState: BaseScreenState.error,
        userId: null,
        error: e.toString(),
      );
      return false;
    }
    for (var element in users) {
      //log('Psw_element: ${element.password}');
      //log('User_element: ${element.email}');
      if (state.inputUsr == element.email) {
        if (state.inputPsw == element.password) {
          state = state.copyWith(userId: element.id);
          // Save email and password in SharedPreferences
          if (state.keepSignedIn == true) {
            await saveCredentials();
          } else {
            await clearCredentials();
          }
          return true;
        } else {
          return false;
        }
      }
    }
    return false;
  }
}
