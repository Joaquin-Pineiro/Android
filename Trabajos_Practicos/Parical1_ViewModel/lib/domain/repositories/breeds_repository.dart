import 'package:parcial_1_pineiro/domain/models/breed.dart';

abstract class BreedsRepository {
  Future<List<Breed>> getBreeds();
  Future<Breed?> getBreed(String id);
  Future<void> insertBreed(Breed breed);
  Future<void> updateBreed(Breed breed);
  Future<void> deleteBreed(Breed breed);
  Future<List<Breed>> filterBreeds(String filter);
}
