import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:floor/floor.dart';

@entity
class User {
  @primaryKey
  final String? id;
  final String name;
  final String lastName;
  final String email;
  final String password;
  final String age;
  final String location;
  final String city;
  final String? profileImg;

  User(
      {this.id,
      required this.name,
      required this.lastName,
      required this.email,
      required this.age,
      required this.location,
      required this.city,
      required this.password,
      required this.profileImg});

  factory User.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return User(
      id: snapshot.id,
      name: data?['name'],
      lastName: data?['last_name'],
      email: data?['email'],
      age: data?['age'],
      location: data?['location'],
      city: data?['city'],
      password: data?['password'],
      profileImg: data?['profile_image'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "name": name,
      "last_name": lastName,
      "email": email,
      "age": location,
      "location": location,
      "city": city,
      "password": password,
      "profile_image": profileImg,
    };
  }
}
