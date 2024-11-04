import 'package:parcial_1_pineiro/domain/models/breed.dart';
import 'package:parcial_1_pineiro/presentation/utils/base_state_screen.dart';

class BreedsState {
  final BaseScreenState screenState;
  final List<Breed> breeds;
  final List<Breed> filteredBreeds;
  final List<Breed> sortedBreeds;
  final String error;
  final String inputFilter;
  final bool lowHigh;
  final String? typeFilter;

  BreedsState(
      {required this.screenState,
      required this.breeds,
      required this.filteredBreeds,
      required this.sortedBreeds,
      required this.error,
      required this.inputFilter,
      required this.lowHigh,
      this.typeFilter});

  factory BreedsState.initial() {
    return BreedsState(
      screenState: BaseScreenState.loading,
      breeds: [],
      filteredBreeds: [],
      sortedBreeds: [],
      error: "",
      inputFilter: "",
      lowHigh: false,
    );
  }

  BreedsState copyWith({
    BaseScreenState? screenState,
    List<Breed>? breeds,
    List<Breed>? filteredBreeds,
    List<Breed>? sortedBreeds,
    String? error,
    String? inputFilter,
    bool? lowHigh,
    String? typeFilter,
  }) {
    return BreedsState(
        screenState: screenState ?? this.screenState,
        breeds: breeds ?? this.breeds,
        filteredBreeds: filteredBreeds ?? this.filteredBreeds,
        sortedBreeds: sortedBreeds ?? this.sortedBreeds,
        error: error ?? this.error,
        inputFilter: inputFilter ?? this.inputFilter,
        lowHigh: lowHigh ?? this.lowHigh,
        typeFilter: typeFilter ?? this.typeFilter);
  }
}
