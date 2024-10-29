import 'package:parcial_1_pineiro/domain/models/user.dart';
import 'package:parcial_1_pineiro/presentation/utils/base_state_screen.dart';

class LoginState {
  final BaseScreenState screenState;
  final String? userId;
  final String error;
  final String inputUsr;
  final String inputPsw;
  final bool keepSignedIn;

  LoginState({
    required this.screenState,
    required this.userId,
    required this.error,
    required this.inputPsw,
    required this.inputUsr,
    required this.keepSignedIn,
  });

  factory LoginState.initial() {
    return LoginState(
      screenState: BaseScreenState.idle,
      userId: null,
      error: "",
      inputPsw: "",
      inputUsr: "",
      keepSignedIn: false,
    );
  }

  LoginState copyWith({
    BaseScreenState? screenState,
    String? userId,
    String? error,
    String? inputUsr,
    String? inputPsw,
    bool? keepSignedIn,
    bool setUserIdNull = false,
  }) {
    return LoginState(
        screenState: screenState ?? this.screenState,
        userId: setUserIdNull ? null : userId ?? this.userId,
        error: error ?? this.error,
        inputUsr: inputUsr ?? this.inputUsr,
        inputPsw: inputPsw ?? this.inputPsw,
        keepSignedIn: keepSignedIn ?? this.keepSignedIn);
  }
}
