import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parcial_1_pineiro/data/providers.dart';
import 'package:parcial_1_pineiro/domain/models/breed.dart';
import 'package:parcial_1_pineiro/presentation/utils/base_state_screen.dart';
import 'package:parcial_1_pineiro/viewmodels/states/breed_info_state.dart';

class BreedsInfoNotifier extends Notifier<BreedsInfoState> {
  @override
  BreedsInfoState build() {
    return BreedsInfoState.initial();
  }

  Future<void> fetchBreed(String breedId) async {
    state = state.copyWith(screenState: BaseScreenState.loading);
    final breedsRepository = ref.read(breedsRepositoryProvider);

    try {
      final breed = await breedsRepository.getBreed(breedId);
      state = state.copyWith(
        screenState: BaseScreenState.idle,
        breed: breed,
        error: '',
      );
      log("NO ERROR");
    } catch (e) {
      log("ERROR");
      state = state.copyWith(
        screenState: BaseScreenState.error,
        error: e.toString(),
      );
    }
  }

  void deleteBreed(breedId) async {
    state = state.copyWith(screenState: BaseScreenState.loading);
    final breedsRepository = ref.read(breedsRepositoryProvider);

    try {
      await breedsRepository.deleteBreed(breedId);
      state = state.copyWith(
        screenState: BaseScreenState.idle,
        breed: null,
        error: '',
      );
    } catch (e) {
      state = state.copyWith(
        screenState: BaseScreenState.error,
        error: e.toString(),
      );
    }
  }
}
