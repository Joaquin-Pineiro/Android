import 'package:parcial_1_pineiro/domain/models/breed.dart';
import 'package:parcial_1_pineiro/presentation/utils/base_state_screen.dart';

class BreedsDetailState {
  final BaseScreenState screenState;
  final Breed? breed;
  final String error;
  final String inputBreedName;
  final String inputWeight;
  final String inputHeight;
  final String inputOrigin;
  final String inputLifeExpectancy;
  final String inputDescription;
  final String inputPosterUrl_1;
  final String inputPosterUrl_2;
  final String inputPosterUrl_3;

  BreedsDetailState({
    required this.screenState,
    this.breed,
    required this.error,
    required this.inputBreedName,
    required this.inputWeight,
    required this.inputHeight,
    required this.inputOrigin,
    required this.inputLifeExpectancy,
    required this.inputDescription,
    required this.inputPosterUrl_1,
    required this.inputPosterUrl_2,
    required this.inputPosterUrl_3,
  });

  factory BreedsDetailState.initial() {
    return BreedsDetailState(
      screenState: BaseScreenState.loading,
      breed: null,
      error: "",
      inputBreedName: "",
      inputWeight: "",
      inputHeight: "",
      inputOrigin: "",
      inputLifeExpectancy: "",
      inputDescription: "",
      inputPosterUrl_1: "",
      inputPosterUrl_2: "",
      inputPosterUrl_3: "",
    );
  }

  BreedsDetailState copyWith({
    BaseScreenState? screenState,
    Breed? breed,
    String? error,
    String? inputBreedName,
    String? inputWeight,
    String? inputHeight,
    String? inputOrigin,
    String? inputLifeExpectancy,
    String? inputDescription,
    String? inputPosterUrl_1,
    String? inputPosterUrl_2,
    String? inputPosterUrl_3,
  }) {
    return BreedsDetailState(
      screenState: screenState ?? this.screenState,
      breed: breed ?? this.breed,
      error: error ?? this.error,
      inputBreedName: inputBreedName ?? this.inputBreedName,
      inputWeight: inputWeight ?? this.inputWeight,
      inputHeight: inputHeight ?? this.inputHeight,
      inputOrigin: inputOrigin ?? this.inputOrigin,
      inputLifeExpectancy: inputLifeExpectancy ?? this.inputLifeExpectancy,
      inputDescription: inputDescription ?? this.inputDescription,
      inputPosterUrl_1: inputPosterUrl_1 ?? this.inputPosterUrl_1,
      inputPosterUrl_2: inputPosterUrl_1 ?? this.inputPosterUrl_2,
      inputPosterUrl_3: inputPosterUrl_1 ?? this.inputPosterUrl_3,
    );
  }
}
