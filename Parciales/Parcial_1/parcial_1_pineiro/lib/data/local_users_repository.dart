import 'package:parcial_1_pineiro/data/users_dao.dart';
import 'package:parcial_1_pineiro/domain/models/user.dart';
import 'package:parcial_1_pineiro/domain/repositories/users_repository.dart';
import 'package:parcial_1_pineiro/main.dart';

class LocalUserRepository implements UsersRepository {
  final UsersDao _usersDao = database.usersDao;
  //final List<User> _filteredRazas =

  @override
  Future<List<User>> getUsers() {
    return _usersDao.findAllUsers();
  }

  @override
  Future<void> insertUser(User user) async {
    await _usersDao.insertUser(user);
  }

  @override
  Future<void> updateUser(User user) async {
    await _usersDao.updateUser(user);
  }

  @override
  Future<void> deleteUser(User user) async {
    await _usersDao.deleteUser(user);
  }
}
