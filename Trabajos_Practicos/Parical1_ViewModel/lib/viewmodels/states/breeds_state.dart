import 'package:parcial_1_pineiro/domain/models/breed.dart';
import 'package:parcial_1_pineiro/presentation/utils/base_state_screen.dart';

class BreedsState {
  final BaseScreenState screenState;
  final List<Breed> breeds;
  final List<Breed> filteredBreeds;
  final List<Breed> sortedBreeds;
  final String error;
  final String inputFilter;

  BreedsState({
    required this.screenState,
    required this.breeds,
    required this.filteredBreeds,
    required this.sortedBreeds,
    required this.error,
    required this.inputFilter,
  });

  factory BreedsState.initial() {
    return BreedsState(
      screenState: BaseScreenState.loading,
      breeds: [],
      filteredBreeds: [],
      sortedBreeds: [],
      error: "",
      inputFilter: "",
    );
  }

  BreedsState copyWith({
    BaseScreenState? screenState,
    List<Breed>? breeds,
    List<Breed>? filteredBreeds,
    List<Breed>? sortedBreeds,
    String? error,
    String? inputFilter,
  }) {
    return BreedsState(
      screenState: screenState ?? this.screenState,
      breeds: breeds ?? this.breeds,
      filteredBreeds: filteredBreeds ?? this.filteredBreeds,
      sortedBreeds: sortedBreeds ?? this.sortedBreeds,
      error: error ?? this.error,
      inputFilter: inputFilter ?? this.inputFilter,
    );
  }
}
