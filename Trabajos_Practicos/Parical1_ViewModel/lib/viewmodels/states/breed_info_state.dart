import 'package:parcial_1_pineiro/domain/models/breed.dart';
import 'package:parcial_1_pineiro/presentation/utils/base_state_screen.dart';

class BreedsInfoState {
  final BaseScreenState screenState;
  final Breed? breed;
  final String error;

  BreedsInfoState({
    required this.screenState,
    required this.breed,
    required this.error,
  });

  factory BreedsInfoState.initial() {
    return BreedsInfoState(
      screenState: BaseScreenState.loading,
      breed: null,
      error: "",
    );
  }

  BreedsInfoState copyWith({
    BaseScreenState? screenState,
    Breed? breed,
    String? error,
  }) {
    return BreedsInfoState(
      screenState: screenState ?? this.screenState,
      breed: breed ?? this.breed,
      error: error ?? this.error,
    );
  }
}
