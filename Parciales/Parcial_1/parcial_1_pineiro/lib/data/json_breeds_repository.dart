import 'package:flutter/services.dart';
import 'package:parcial_1_pineiro/domain/models/breed.dart';
import 'package:parcial_1_pineiro/domain/repositories/breeds_repository.dart';
import 'dart:convert';

class JsonBreedsRepository implements BreedsRepository {
  @override
  Future<List<Breed>> getBreeds() {
    return Future.delayed(const Duration(seconds: 1), () async {
      final jsonString = await rootBundle.loadString('assets/breeds.json');
      final jsonList = json.decode(jsonString) as List;
      final breeds = jsonList.map((json) => Breed.fromJson(json)).toList();
      return breeds;
    });
  }

  @override
  Future<void> insertBreed(Breed breed) {
    return Future.delayed(
      const Duration(seconds: 1),
      () => null,
    );
  }

  @override
  Future<void> deleteBreed(Breed breed) {
    return Future.delayed(
      const Duration(seconds: 1),
      () => null,
    );
  }

  @override
  Future<void> updateBreed(Breed breed) {
    return Future.delayed(
      const Duration(seconds: 1),
      () => null,
    );
  }

  @override
  Future<List<Breed>> filterBreeds(
      String filter, List<Breed> filteredBreeds, List<Breed> sortedBreeds) {
    return Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<List<Breed>> filterBreeds2(bool lowHigh, String filter,
      List<Breed> filteredBreeds, List<Breed> sortedBreeds) {
    return Future.delayed(const Duration(seconds: 1));
  }
}
