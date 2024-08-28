import 'package:clase_3/presentation/screens/login.dart';
import 'package:clase_3/presentation/screens/razas_detail_screen.dart';
import 'package:clase_3/presentation/screens/razas_screen.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(initialLocation: '/login', routes: [
  GoRoute(
    path: '/raza_detail/:parameter',
    builder: (context, state) => RazasDetailScreen(
      razaId: state.pathParameters['parameter'] ?? '0',
    ),
  ),
  GoRoute(
    path: '/raza/:parameter',
    builder: (context, state) => RazasScreen(
      user: state.pathParameters['parameter'] ?? 'Ale',
    ),
  ),
  GoRoute(
    path: '/login',
    builder: (context, state) => LoginScreen(),
  ),
]);
