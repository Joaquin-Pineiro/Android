import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:parcial_1_pineiro/config/database/database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parcial_1_pineiro/config/router/app_router.dart';
import 'package:parcial_1_pineiro/domain/models/app_theme.dart';
import 'package:parcial_1_pineiro/presentation/providers/theme_provider.dart';

late AppDatabase database;

void main() async {
  // Ensure that the binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the database and measure initialization time
  final stopwatch = Stopwatch()..start();
  database = await AppDatabase.create('app_database.db');
  stopwatch.stop();
  log('Database initialized in ${stopwatch.elapsed.inMilliseconds}ms');

  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, ref) {
    AppTheme appTheme = ref.watch(themeNotifierProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: appTheme.getTheme(),
    );
  }
}
