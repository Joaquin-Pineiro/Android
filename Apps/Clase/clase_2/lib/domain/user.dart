import 'dart:io';

class User {
  String id;
  String name;
  String email;
  String password;
  int age;

  User(
      {required this.id,
      required this.name,
      required this.email,
      required this.age,
      required this.password});

  void printUser() {
    print('User : this.name');
  }
}
