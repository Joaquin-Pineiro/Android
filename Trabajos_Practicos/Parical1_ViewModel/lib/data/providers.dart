import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parcial_1_pineiro/data/local_breeds_firestore_repository.dart';
import 'package:parcial_1_pineiro/data/local_users_repository.dart';
import 'package:parcial_1_pineiro/domain/repositories/breeds_repository.dart';
import 'package:parcial_1_pineiro/domain/repositories/users_repository.dart';

final breedsRepositoryProvider = Provider<BreedsRepository>(
  (ref) {
    return LocalBreedFirestoreRepository();
  },
);

final usersRepositoryProvider = Provider<UsersRepository>(
  (ref) {
    return LocalUsersFirestoreRepository();
  },
);
