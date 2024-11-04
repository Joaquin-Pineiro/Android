import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
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

    if (filter != "") {
      state = state.copyWith(
          filteredBreeds: await breedsRepository.filterBreeds(filter));
    } else {
      state =
          state.copyWith(filteredBreeds: await breedsRepository.getBreeds());
    }

    sortBreeds(null, null);
  }

  void sortBreeds(bool? lowHigh, String? filter) async {
    if (lowHigh != null) {
      state = state.copyWith(lowHigh: lowHigh, typeFilter: filter);
    }

    if (state.lowHigh == true) {
      final breeds2sort = state.filteredBreeds
          .map(
            (breed) => Breed(
                breed: breed.breed,
                weight: breed.weight,
                height: breed.height,
                origin: breed.origin,
                posterUrl_1: breed.posterUrl_1,
                posterUrl_2: breed.posterUrl_2,
                posterUrl_3: breed.posterUrl_3,
                lifeExpectancy: breed.lifeExpectancy,
                description: breed.description),
          )
          .toList();
      breeds2sort.sort((a, b) {
        // Remove non-numeric characters (e.g., "kg") and parse the lower bound of the weight
        double weightA = double.parse(a
            .toMap()[state.typeFilter]
            .split('-')[0]
            .replaceAll(RegExp(r'[^0-9.]'), ''));
        double weightB = double.parse(b
            .toMap()[state.typeFilter]
            .split('-')[0]
            .replaceAll(RegExp(r'[^0-9.]'), ''));
        return weightA.compareTo(weightB);
      });
      state = state.copyWith(breeds: breeds2sort);
    } else {
      state = state.copyWith(breeds: state.filteredBreeds);
    }
  }

  Future<bool> logOut() async {
    try {
      state = state.copyWith(
        screenState: BaseScreenState.idle,
        error: '',
      );
      await FirebaseAuth.instance.signOut();

      return true;
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        screenState: BaseScreenState.error,
        error: e.code.toString(),
      );
      log(e.code.toString());
      return false;
    }
  }
}
