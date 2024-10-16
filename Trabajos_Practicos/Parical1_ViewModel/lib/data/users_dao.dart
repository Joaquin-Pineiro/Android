import 'package:floor/floor.dart';
import 'package:parcial_1_pineiro/domain/models/user.dart';

@dao
abstract class UsersDao {
  @Query('SELECT * FROM User')
  Future<List<User>> findAllUsers();

  @Query('SELECT * FROM User where id = :id')
  Future<User?> findUserById(int id);

  @insert
  Future<void> insertUser(User user);

  @delete
  Future<void> deleteUser(User user);

  @update
  Future<void> updateUser(User user);
}
