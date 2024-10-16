import 'dart:developer';

import 'package:parcial_1_pineiro/data/breeds_dao.dart';
import 'package:parcial_1_pineiro/domain/models/breed.dart';
import 'package:parcial_1_pineiro/domain/repositories/breeds_repository.dart';
import 'package:parcial_1_pineiro/main.dart';

class LocalBreedRepository implements BreedsRepository {
  final BreedsDao _breedsDao = database.breedsDao;

  @override
  Future<List<Breed>> getBreeds() {
    return _breedsDao.findAllBreeds();
  }

  @override
  Future<void> insertBreed(Breed breed) async {
    await _breedsDao.insertBreed(breed);
  }

  @override
  Future<void> updateBreed(Breed breed) async {
    await _breedsDao.updateBreed(breed);
  }

  @override
  Future<void> deleteBreed(Breed breed) async {
    await _breedsDao.deleteBreed(breed);
  }

  @override
  Future<List<Breed>> filterBreeds(String filter, List<Breed> filteredBreeds,
      List<Breed> sortedBreeds) async {
    List<Breed> staticBreed = await getBreeds();

    filteredBreeds.clear();
    if (filter != "") {
      filteredBreeds.addAll(staticBreed.where((breed) {
        return breed.breed.toLowerCase().contains(filter.toLowerCase());
      }).toList());
    } else {
      filteredBreeds.addAll(staticBreed
          .map((breed) => Breed(
              id: breed.id,
              breed: breed.breed,
              weight: breed.weight,
              height: breed.height,
              origin: breed.origin,
              lifeExpectancy: breed.lifeExpectancy,
              description: breed.description,
              posterUrl_1: breed.posterUrl_1,
              posterUrl_2: breed.posterUrl_2,
              posterUrl_3: breed.posterUrl_3))
          .toList());
    }
    Set<int> idsA = sortedBreeds.map((item) => item.id!).toSet();
    Set<int> idsB = filteredBreeds.map((item) => item.id!).toSet();
    Set<int> commonIds = idsA.intersection(idsB);
    List<Breed> intersection =
        sortedBreeds.where((item) => commonIds.contains(item.id)).toList();

    return intersection;
    // return sortedBreeds
    //     .toSet()
    //     .intersection(filteredBreeds.toSet())
    //     .toList();
  }

  @override
  Future<List<Breed>> filterBreeds2(bool lowHigh, String filter,
      List<Breed> filteredBreeds, List<Breed> sortedBreeds) async {
    if (lowHigh == true) {
      sortedBreeds.sort((a, b) {
        // Remove non-numeric characters (e.g., "kg") and parse the lower bound of the weight
        double weightA = double.parse(
            a.toMap()[filter].split('-')[0].replaceAll(RegExp(r'[^0-9.]'), ''));
        double weightB = double.parse(
            b.toMap()[filter].split('-')[0].replaceAll(RegExp(r'[^0-9.]'), ''));
        return weightA.compareTo(weightB);
      });
    } else {
      List<Breed> staticBreed = await getBreeds();
      sortedBreeds = staticBreed
          .map((breed) => Breed(
              id: breed.id,
              breed: breed.breed,
              weight: breed.weight,
              height: breed.height,
              origin: breed.origin,
              lifeExpectancy: breed.lifeExpectancy,
              description: breed.description,
              posterUrl_1: breed.posterUrl_1,
              posterUrl_2: breed.posterUrl_2,
              posterUrl_3: breed.posterUrl_3))
          .toList();
    }

    Set<int> idsA = sortedBreeds.map((item) => item.id!).toSet();
    Set<int> idsB = filteredBreeds.map((item) => item.id!).toSet();
    Set<int> commonIds = idsA.intersection(idsB);
    List<Breed> intersection =
        sortedBreeds.where((item) => commonIds.contains(item.id)).toList();

    return intersection;
    //return aux;
  }
}
