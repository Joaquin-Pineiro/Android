import 'package:floor/floor.dart';

@entity
class User {
  @primaryKey
  final int? id;
  String name;
  String lastName;
  String email;
  String password;
  String age;
  String location;
  String city;
  String? profileImg;

  User(
      {required this.id,
      required this.name,
      required this.lastName,
      required this.email,
      required this.age,
      required this.location,
      required this.city,
      required this.password,
      required this.profileImg});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      lastName: json['last_name'],
      email: json['email'],
      password: json['password'],
      age: json['age'],
      location: json['location'],
      city: json['city'],
      profileImg: json['profile_img'] != null ? json['profile_img'] : null,
    );
  }
}
