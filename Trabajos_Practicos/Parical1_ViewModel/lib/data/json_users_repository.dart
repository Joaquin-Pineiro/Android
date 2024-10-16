import 'package:flutter/services.dart';
import 'package:parcial_1_pineiro/domain/models/user.dart';
import 'package:parcial_1_pineiro/domain/repositories/users_repository.dart';
import 'dart:convert';

class JsonUsersRepository implements UsersRepository {
  @override
  Future<List<User>> getUsers() {
    return Future.delayed(const Duration(seconds: 1), () async {
      final jsonString = await rootBundle.loadString('assets/users.json');
      final jsonList = json.decode(jsonString) as List;
      final users = jsonList.map((json) => User.fromJson(json)).toList();
      return users;
    });
  }

  @override
  Future<void> insertUser(User user) {
    return Future.delayed(
      const Duration(seconds: 1),
      () => null,
    );
  }

  @override
  Future<void> deleteUser(User user) {
    return Future.delayed(
      const Duration(seconds: 1),
      () => null,
    );
  }

  @override
  Future<void> updateUser(User user) {
    return Future.delayed(
      const Duration(seconds: 1),
      () => null,
    );
  }
}
