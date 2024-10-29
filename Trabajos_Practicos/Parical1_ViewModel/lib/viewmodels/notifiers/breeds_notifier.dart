import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parcial_1_pineiro/data/providers.dart';
import 'package:parcial_1_pineiro/domain/models/breed.dart';
import 'package:parcial_1_pineiro/presentation/utils/base_state_screen.dart';
import 'package:parcial_1_pineiro/viewmodels/states/breeds_state.dart';

class BreedsNotifier extends Notifier<BreedsState> {
  @override
  BreedsState build() {
    return BreedsState.initial();
  }

  Future<void> fetchBreds() async {
    state = state.copyWith(screenState: BaseScreenState.loading);

    final breedsRepository = ref.read(breedsRepositoryProvider);

    try {
      final breeds = await breedsRepository.getBreeds();
      for (var element in breeds) {
        log("Breeds: ${element.breed}");
      }

      state = state.copyWith(
        screenState: BaseScreenState.idle,
        breeds: breeds,
        filteredBreeds: breeds,
        sortedBreeds: breeds,
        error: '',
      );
    } catch (e) {
      state = state.copyWith(
        screenState: BaseScreenState.error,
        breeds: [],
        error: e.toString(),
      );
    }
  }

  void updateFilterText(String filterText) {
    state = state.copyWith(inputFilter: filterText);
  }

  void filterBreeds(String filter) async {
    final breedsRepository = ref.read(breedsRepositoryProvider);

    final breeds = await breedsRepository.getBreeds();

    if (filter != "") {
      state = state.copyWith(
          filteredBreeds: breeds.where((breed) {
        return breed.breed.toLowerCase().contains(filter.toLowerCase());
      }).toList());
    } else {
      state = state.copyWith(filteredBreeds: breeds);
    }

    Set<String> idsA = state.sortedBreeds.map((item) => item.id!).toSet();
    Set<String> idsB = state.filteredBreeds.map((item) => item.id!).toSet();
    Set<String> commonIds = idsA.intersection(idsB);
    List<Breed> intersection = state.sortedBreeds
        .where((item) => commonIds.contains(item.id))
        .toList();

    state = state.copyWith(breeds: intersection);
  }

  void sortBreeds(bool lowHigh, String filter) async {
    final breedsRepository = ref.read(breedsRepositoryProvider);

    final breeds = await breedsRepository.getBreeds();

    if (lowHigh == true) {
      breeds.sort((a, b) {
        // Remove non-numeric characters (e.g., "kg") and parse the lower bound of the weight
        double weightA = double.parse(
            a.toMap()[filter].split('-')[0].replaceAll(RegExp(r'[^0-9.]'), ''));
        double weightB = double.parse(
            b.toMap()[filter].split('-')[0].replaceAll(RegExp(r'[^0-9.]'), ''));
        return weightA.compareTo(weightB);
      });
      state = state.copyWith(sortedBreeds: breeds);
    } else {
      state = state.copyWith(sortedBreeds: breeds);
    }

    Set<String> idsA = state.sortedBreeds.map((item) => item.id!).toSet();
    Set<String> idsB = state.filteredBreeds.map((item) => item.id!).toSet();
    Set<String> commonIds = idsA.intersection(idsB);
    List<Breed> intersection = state.sortedBreeds
        .where((item) => commonIds.contains(item.id))
        .toList();

    state = state.copyWith(breeds: intersection);
  }
}
