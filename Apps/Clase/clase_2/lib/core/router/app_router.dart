import 'package:clase_2/presentation/screen/home.dart';
import 'package:clase_2/presentation/screen/login.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(initialLocation: '/login', routes: [
  GoRoute(
    path: '/login',
    builder: (context, state) => LoginScreen(),
  ),
  GoRoute(
    path: '/home/:parameter',
    builder: (context, state) =>
        HomeScreen(nombre: state.pathParameters['parameter'] ?? 'Ale'),
  )
]);
