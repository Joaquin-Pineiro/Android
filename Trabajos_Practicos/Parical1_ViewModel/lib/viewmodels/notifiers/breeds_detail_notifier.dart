import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parcial_1_pineiro/data/providers.dart';
import 'package:parcial_1_pineiro/domain/models/breed.dart';

import 'package:parcial_1_pineiro/presentation/utils/base_state_screen.dart';
import 'package:parcial_1_pineiro/viewmodels/states/breeds_detail_state.dart';

class BreedsDetailNotifier extends Notifier<BreedsDetailState> {
  @override
  BreedsDetailState build() {
    return BreedsDetailState.initial();
  }

  Future<void> fetchBreed(String? breedId) async {
    state = state.copyWith(screenState: BaseScreenState.loading);
    final breedsRepository = ref.read(breedsRepositoryProvider);
    if (breedId != null) {
      try {
        final breed = await breedsRepository.getBreed(breedId);
        state = state.copyWith(
          inputBreedName: breed!.breed,
          inputWeight: breed.weight.replaceAll(RegExp(r'[^0-9-]'), ''),
          inputHeight: breed.height.replaceAll(RegExp(r'[^0-9-]'), ''),
          inputOrigin: breed.origin,
          inputLifeExpectancy:
              breed.lifeExpectancy.replaceAll(RegExp(r'[^0-9-]'), ''),
          inputDescription: breed.description,
          inputPosterUrl_1: breed.posterUrl_1,
          inputPosterUrl_2: breed.posterUrl_2,
          inputPosterUrl_3: breed.posterUrl_3,
          screenState: BaseScreenState.idle,
          breed: breed,
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
        breed: null,
        screenState: BaseScreenState.empty,
        inputBreedName: "",
        inputWeight: "",
        inputHeight: "",
        inputOrigin: "",
        inputLifeExpectancy: "",
        inputDescription: "",
        inputPosterUrl_1: "",
        inputPosterUrl_2: "",
        inputPosterUrl_3: "",
        error: '',
      );
    }
  }

  Future<void> updateAddBreed() async {
    state = state.copyWith(screenState: BaseScreenState.loading);
    final breedRepository = ref.read(breedsRepositoryProvider);
    try {
      if (state.breed != null) {
        state = state.copyWith(
          breed: Breed(
            id: state.breed!.id,
            breed: state.inputBreedName,
            weight: "${state.inputWeight} kg",
            height: "${state.inputHeight} cm",
            origin: state.inputOrigin,
            lifeExpectancy: "${state.inputLifeExpectancy} years",
            description: state.inputDescription,
            posterUrl_1: state.inputPosterUrl_1,
            posterUrl_2: state.breed!.posterUrl_2,
            posterUrl_3: state.breed!.posterUrl_3,
          ),
          screenState: BaseScreenState.idle,
          error: '',
        );

        await breedRepository.updateBreed(state.breed!);
      } else {
        log("Nueva Raza");
        state = state.copyWith(
          breed: Breed(
            id: null,
            breed: state.inputBreedName,
            weight: "${state.inputWeight} kg",
            height: "${state.inputHeight} cm",
            origin: state.inputOrigin,
            lifeExpectancy: "${state.inputLifeExpectancy} years",
            description: state.inputDescription,
            posterUrl_1: state.inputPosterUrl_1,
            posterUrl_2: state.inputPosterUrl_1,
            posterUrl_3: state.inputPosterUrl_1,
          ),
          screenState: BaseScreenState.idle,
          error: '',
        );
        log("New Breed Name: ${state.breed!.breed}");
        breedRepository.insertBreed(state.breed!);
      }
    } catch (e) {
      log("ERROR");
      state = state.copyWith(
        screenState: BaseScreenState.error,
        error: e.toString(),
      );
    }
  }

  void updateBreedNameText(String name) {
    state = state.copyWith(inputBreedName: name);
  }

  void updateWeightText(String weight) {
    state = state.copyWith(inputWeight: weight);
  }

  void updateHeightText(String height) {
    state = state.copyWith(inputHeight: height);
  }

  void updateOriginText(String origin) {
    state = state.copyWith(inputOrigin: origin);
  }

  void updateLifeExpectancyText(String lifeExpectancy) {
    state = state.copyWith(inputLifeExpectancy: lifeExpectancy);
  }

  void updateDescriptionText(String description) {
    state = state.copyWith(inputDescription: description);
  }

  void updatePosterUrl1(String posterUrl1) {
    state = state.copyWith(inputPosterUrl_1: posterUrl1);
  }
}
