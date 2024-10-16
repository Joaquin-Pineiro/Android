import 'package:floor/floor.dart';
import 'package:parcial_1_pineiro/domain/models/breed.dart';

@dao
abstract class BreedsDao {
  @Query('SELECT * FROM Breed')
  Future<List<Breed>> findAllBreeds();

  @Query('SELECT * FROM Breed where id = :id')
  Future<Breed?> findBreedById(int id);

  @insert
  Future<void> insertBreed(Breed breed);

  @delete
  Future<void> deleteBreed(Breed breed);

  @update
  Future<void> updateBreed(Breed breed);
}
