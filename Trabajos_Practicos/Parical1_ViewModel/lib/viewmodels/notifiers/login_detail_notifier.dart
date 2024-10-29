import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parcial_1_pineiro/data/providers.dart';
import 'package:parcial_1_pineiro/domain/models/user.dart';
import 'package:parcial_1_pineiro/presentation/utils/base_state_screen.dart';
import 'package:parcial_1_pineiro/viewmodels/states/login_detail_state.dart';

class LoginDetailNotifier extends Notifier<LoginDetailState> {
  @override
  LoginDetailState build() {
    return LoginDetailState.initial();
  }

  Future<void> fetchUser(String? userId) async {
    state = state.copyWith(screenState: BaseScreenState.loading);
    final userRepository = ref.read(usersRepositoryProvider);
    if (userId != null) {
      try {
        final user = await userRepository.getUser(userId);
        state = state.copyWith(
          inputName: user!.name,
          inputLastName: user.lastName,
          inputEmail: user.email,
          inputCity: user.city,
          inputLocation: user.location,
          inputAge: user.age,
          inputPassword: user.password,
          inputProfileImage: user.profileImg,
          screenState: BaseScreenState.idle,
          user: user,
          error: '',
        );
      } catch (e) {
        state = state.copyWith(
          screenState: BaseScreenState.error,
          error: e.toString(),
        );
      }
    } else {
      state = state.copyWith(
        user: null,
        screenState: BaseScreenState.empty,
        inputName: "",
        inputLastName: "",
        inputEmail: "",
        inputCity: "",
        inputLocation: "",
        inputAge: "",
        inputPassword: "",
        inputProfileImage: "",
        error: '',
      );
    }
  }

  Future<void> updateAddUser() async {
    state = state.copyWith(screenState: BaseScreenState.loading);
    final userRepository = ref.read(usersRepositoryProvider);
    try {
      if (state.user != null) {
        state = state.copyWith(
          user: User(
            id: state.user!.id,
            name: state.inputName,
            lastName: state.inputLastName,
            email: state.inputEmail,
            age: state.inputAge,
            location: state.inputLocation,
            city: state.inputCity,
            password: state.inputPassword,
            profileImg: state.inputProfileImage,
          ),
          screenState: BaseScreenState.idle,
          error: '',
        );

        userRepository.updateUser(state.user!);
      } else {
        log("Nuevo Usuario");
        state = state.copyWith(
          user: User(
            id: null,
            name: state.inputName,
            lastName: state.inputLastName,
            email: state.inputEmail,
            age: state.inputAge,
            location: state.inputLocation,
            city: state.inputCity,
            password: state.inputPassword,
            profileImg: state.inputProfileImage,
          ),
          screenState: BaseScreenState.idle,
          error: '',
        );
        log("New user Email: ${state.user!.email}");
        userRepository.insertUser(state.user!);
      }
    } catch (e) {
      state = state.copyWith(
        screenState: BaseScreenState.error,
        error: e.toString(),
      );
    }
  }

  void updateNameText(String name) {
    state = state.copyWith(inputName: name);
  }

  void updateLastNameText(String lastName) {
    state = state.copyWith(inputLastName: lastName);
  }

  void updateEmailText(String email) {
    state = state.copyWith(inputEmail: email);
  }

  void updateCityText(String city) {
    state = state.copyWith(inputCity: city);
  }

  void updateLocationText(String location) {
    state = state.copyWith(inputLocation: location);
  }

  void updateAgeText(String age) {
    state = state.copyWith(inputAge: age);
  }

  void updatePswText(String psw) {
    state = state.copyWith(inputPassword: psw);
  }

  void updateProfileImage(String profileImage) {
    state = state.copyWith(inputProfileImage: profileImage);
  }
}
