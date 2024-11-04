import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parcial_1_pineiro/domain/models/user.dart';
import 'package:parcial_1_pineiro/domain/repositories/users_repository.dart';
import 'package:parcial_1_pineiro/main.dart';

class LocalUsersFirestoreRepository implements UsersRepository {
  @override
  Future<List<User>> getUsers() async {
    final usersCollection =
        dataBaseFirestore.collection('users').withConverter<User>(
              fromFirestore: User.fromFirestore,
              toFirestore: (User user, _) => user.toFirestore(),
            );

    try {
      final documentsSnap = await usersCollection.get();
      log("Number of users fetched: ${documentsSnap.size}");
      final users = documentsSnap.docs.map((doc) => doc.data()).toList();

      for (var user in users) {
        log('Retrieved User: ${user.id}', name: 'UserDataRetrieval');
        log('Retrieved User: ${user.name}', name: 'UserDataRetrieval');
        log('Retrieved User: ${user.lastName}', name: 'UserDataRetrieval');
        log('Retrieved User: ${user.email}', name: 'UserDataRetrieval');
        log('Retrieved User: ${user.age}', name: 'UserDataRetrieval');
        log('Retrieved User: ${user.location}', name: 'UserDataRetrieval');
        log('Retrieved User: ${user.city}', name: 'UserDataRetrieval');
        log('Retrieved User: ${user.password}', name: 'UserDataRetrieval');
        log('Retrieved User: ${user.profileImg}', name: 'UserDataRetrieval');
      }
      return users;
    } catch (e, stackTrace) {
      log("Error fetching users: $e", name: 'UserDataRetrieval');
      log("StackTrace: $stackTrace", name: 'UserDataRetrieval');
      return [];
    }
  }

  @override
  Future<User?> getUser(String documentId) async {
    final usersCollection =
        dataBaseFirestore.collection('users').withConverter<User>(
              fromFirestore: User.fromFirestore,
              toFirestore: (User user, _) => user.toFirestore(),
            );
    final documentSnap = await usersCollection.doc(documentId).get();

    return documentSnap.data();
  }

  @override
  Future<void> insertUser(User user) async {
    final usersCollection =
        dataBaseFirestore.collection('users').withConverter<User>(
              fromFirestore: User.fromFirestore,
              toFirestore: (User user, _) => user.toFirestore(),
            );

    try {
      final docRef = await usersCollection.doc(user.id).set(user);
      log("User inserted successfully with document ID: ${user.id}");
    } catch (e) {
      log("Failed to insert user: $e");
    }
  }

  @override
  Future<void> updateUser(User user) async {
    final usersCollection =
        dataBaseFirestore.collection("users").withConverter<User>(
              fromFirestore: User.fromFirestore,
              toFirestore: (User user, _) => user.toFirestore(),
            );

    try {
      await usersCollection.doc(user.id).set(user, SetOptions(merge: true));
      log("User updated successfully!");
    } catch (e) {
      log("Failed to update user: $e");
    }
  }

  @override
  Future<void> deleteUser(User user) async {
    final usersCollection = dataBaseFirestore.collection("users");

    try {
      await usersCollection.doc(user.id).delete();
      log("User deleted successfully!");
    } catch (e) {
      log("Failed to delete user: $e");
    }
  }
}
