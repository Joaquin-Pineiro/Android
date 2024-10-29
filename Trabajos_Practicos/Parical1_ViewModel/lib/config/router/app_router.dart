import 'dart:developer';

import 'package:go_router/go_router.dart';
import 'package:parcial_1_pineiro/presentation/screens/breeds_detail_screen.dart';
import 'package:parcial_1_pineiro/presentation/screens/breeds_info_screen.dart';
import 'package:parcial_1_pineiro/presentation/screens/breeds_screen.dart';
import 'package:parcial_1_pineiro/presentation/screens/config_screen.dart';

import 'package:parcial_1_pineiro/presentation/screens/login_detail_screen.dart';

import 'package:parcial_1_pineiro/presentation/screens/login_screen.dart';

final GoRouter appRouter =
    GoRouter(initialLocation: '/User', debugLogDiagnostics: true, routes: [
  GoRoute(
    name: 'User',
    path: '/user',
    builder: (context, state) => const LoginScreen(),
  ),
  GoRoute(
    name: 'UserProfile',
    path: '/user_profile',
    builder: (context, state) {
      String? userId = state.extra == null ? null : state.extra as String;
      return LoginDetailScreen(userId: userId);
    },
  ),
  GoRoute(
    name: 'Breeds',
    path: '/breeds',
    builder: (context, state) {
      final String userId = state.extra as String;
      //log("hola");
      return BreedsScreen(userId: userId);
    },
  ),
  GoRoute(
    name: 'BreedDetail',
    path: '/breed_detail',
    builder: (context, state) {
      final String? breedId =
          state.extra == null ? null : state.extra as String;
      return BreedDetailScreen(breedId: breedId);
    },
  ),
  GoRoute(
    name: 'BreedsInfo',
    path: '/breeds_info',
    builder: (context, state) {
      return BreedsInfoScreen(breedId: state.extra as String);
    },
  ),
  GoRoute(
    name: 'Config',
    path: '/config',
    builder: (context, state) {
      return const ConfigScreen();
    },
  ),
]);
