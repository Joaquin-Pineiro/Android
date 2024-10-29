import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parcial_1_pineiro/config/router/app_router.dart';
import 'package:parcial_1_pineiro/viewmodels/providers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

late FirebaseFirestore dataBaseFirestore;
//TOKEN 1//0hNau9r4R173_CgYIARAAGBESNwF-L9Ir5KOjdNq4czfMqRY2Rg27vk0P8lZ9Pi0kfnViHmdJQOMkqhLTJcTuWBjfZ7o972S7bRk
void main() async {
  // Ensure that the binding is initialized
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize the database and measure initialization time
  final stopwatch = Stopwatch()..start();
  dataBaseFirestore = FirebaseFirestore.instance;
  stopwatch.stop();
  log('Database initialized in ${stopwatch.elapsed.inMilliseconds}ms');

  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final config = ref.watch(configViewModelProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: ref.read(configViewModelProvider.notifier).getTheme(),
    );
  }
}
