import 'package:go_router/go_router.dart';
import 'package:parcial_1_pineiro/data/local_breeds_repository.dart';
import 'package:parcial_1_pineiro/data/local_users_repository.dart';
import 'package:parcial_1_pineiro/domain/models/breed.dart';
import 'package:parcial_1_pineiro/domain/models/user.dart';
import 'package:parcial_1_pineiro/presentation/screens/breeds_detail_screen.dart';
import 'package:parcial_1_pineiro/presentation/screens/breeds_form_screen.dart';
import 'package:parcial_1_pineiro/presentation/screens/breeds_screen.dart';
import 'package:parcial_1_pineiro/presentation/screens/config_screen.dart';
import 'package:parcial_1_pineiro/presentation/screens/login_screen.dart';
import 'package:parcial_1_pineiro/presentation/screens/user_profile_screen.dart';

final GoRouter appRouter = GoRouter(initialLocation: '/User', routes: [
  GoRoute(
    name: 'User',
    path: '/user',
    builder: (context, state) => LoginScreen(),
  ),
  GoRoute(
    name: 'BreedDetail',
    path: '/breed_detail',
    builder: (context, state) {
      final Map<String, dynamic> extras = state.extra as Map<String, dynamic>;
      Breed breed = extras['breed'];
      LocalBreedRepository repository = extras['repository'];
      return BreedsDetailScreen(
        breed: breed,
        repository: repository,
      );
    },
  ),
  GoRoute(
    name: 'Breeds',
    path: '/breed',
    builder: (context, state) => BreedsScreen(
      user: state.extra as User,
    ),
  ),
  GoRoute(
    name: 'BreedsForm',
    path: '/breed_form',
    builder: (context, state) {
      final Map<String, dynamic> extras = state.extra as Map<String, dynamic>;
      Breed? breed = extras['breed'];
      LocalBreedRepository repository = extras['repository'];
      return BreedsFormScreen(
        breed: breed,
        repository: repository,
      );
    },
  ),
  GoRoute(
    name: 'UserProfile',
    path: '/user_profile',
    builder: (context, state) {
      final Map<String, dynamic> extras = state.extra as Map<String, dynamic>;
      User? user = extras['user'];
      LocalUserRepository repository = extras['repository'];
      return UserProfileScreen(
        user: user,
        repository: repository,
      );
    },
  ),
  GoRoute(
    name: 'Config',
    path: '/config',
    builder: (context, state) {
      return ConfigScreen();
    },
  )
]);
