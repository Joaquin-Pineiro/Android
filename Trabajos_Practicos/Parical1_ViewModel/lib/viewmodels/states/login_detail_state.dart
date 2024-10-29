import 'package:parcial_1_pineiro/domain/models/user.dart';
import 'package:parcial_1_pineiro/presentation/utils/base_state_screen.dart';

class LoginDetailState {
  final BaseScreenState screenState;
  final User? user;
  final String? error;
  final String inputName;
  final String inputLastName;
  final String inputEmail;
  final String inputCity;
  final String inputLocation;
  final String inputPassword;
  final String inputAge;
  final String inputProfileImage;

  LoginDetailState({
    required this.screenState,
    this.user,
    this.error,
    required this.inputName,
    required this.inputLastName,
    required this.inputEmail,
    required this.inputCity,
    required this.inputLocation,
    required this.inputPassword,
    required this.inputAge,
    required this.inputProfileImage,
  });

  factory LoginDetailState.initial() {
    return LoginDetailState(
        screenState: BaseScreenState.loading,
        inputName: "",
        inputLastName: "",
        inputEmail: "",
        inputCity: "",
        inputLocation: "",
        inputPassword: "",
        inputAge: "",
        inputProfileImage: "");
  }

  LoginDetailState copyWith({
    BaseScreenState? screenState,
    User? user,
    String? error,
    String? inputName,
    String? inputLastName,
    String? inputEmail,
    String? inputCity,
    String? inputLocation,
    String? inputPassword,
    String? inputAge,
    String? inputProfileImage,
  }) {
    return LoginDetailState(
        screenState: screenState ?? this.screenState,
        user: user ?? this.user,
        error: error ?? this.error,
        inputName: inputName ?? this.inputName,
        inputLastName: inputLastName ?? this.inputLastName,
        inputEmail: inputEmail ?? this.inputEmail,
        inputCity: inputCity ?? this.inputCity,
        inputLocation: inputLocation ?? this.inputLocation,
        inputPassword: inputPassword ?? this.inputPassword,
        inputAge: inputAge ?? this.inputAge,
        inputProfileImage: inputProfileImage ?? this.inputProfileImage);
  }
}
