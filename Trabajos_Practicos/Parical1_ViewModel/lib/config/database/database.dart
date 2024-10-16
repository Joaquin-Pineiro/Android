import 'package:floor/floor.dart';
import 'package:parcial_1_pineiro/data/breeds_dao.dart';
import 'package:parcial_1_pineiro/data/json_breeds_repository.dart';
import 'package:parcial_1_pineiro/data/json_users_repository.dart';
import 'package:parcial_1_pineiro/data/users_dao.dart';
import 'package:parcial_1_pineiro/domain/models/breed.dart';
import 'package:parcial_1_pineiro/domain/models/user.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'dart:async';
part 'database.g.dart';

@Database(version: 1, entities: [Breed, User])
abstract class AppDatabase extends FloorDatabase {
  BreedsDao get breedsDao;
  UsersDao get usersDao;

  static Future<AppDatabase> create(String name) {
    return $FloorAppDatabase.databaseBuilder(name).addCallback(Callback(
      onCreate: (database, version) async {
        await _prepopulateDb(database);
      },
    )).build();
  }

  static Future<void> _prepopulateDb(sqflite.DatabaseExecutor database) async {
    final breedsRepository = JsonBreedsRepository();
    final usersRepository = JsonUsersRepository();
    final breeds = await breedsRepository.getBreeds();
    final users = await usersRepository.getUsers();

    for (final breed in breeds) {
      await InsertionAdapter(
        database,
        'Breed',
        (Breed item) => <String, Object?>{
          'id': item.id,
          'breed': item.breed,
          'weight': item.weight,
          'height': item.height,
          'origin': item.origin,
          'posterUrl_1': item.posterUrl_1,
          'posterUrl_2': item.posterUrl_2,
          'posterUrl_3': item.posterUrl_3,
          'lifeExpectancy': item.lifeExpectancy,
          'description': item.description
        },
      ).insert(breed, OnConflictStrategy.replace);
    }
    for (final user in users) {
      await InsertionAdapter(
        database,
        'User',
        (User item) => <String, Object?>{
          'id': item.id,
          'name': item.name,
          'lastName': item.lastName,
          'email': item.email,
          'password': item.password,
          'age': item.age,
          'location': item.location,
          'city': item.city,
          'profileImg': item.profileImg,
        },
      ).insert(user, OnConflictStrategy.replace);
    }
  }
}
