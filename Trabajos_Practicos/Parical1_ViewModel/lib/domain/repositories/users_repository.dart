import 'package:parcial_1_pineiro/domain/models/user.dart';

abstract class UsersRepository {
  Future<List<User>> getUsers();
  Future<User?> getUser(String documentId);
  Future<void> insertUser(User user);
  Future<void> updateUser(User user);
  Future<void> deleteUser(User user);
}
