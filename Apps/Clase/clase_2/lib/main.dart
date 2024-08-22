import 'package:clase_2/core/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:clase_2/presentation/screen/login.dart';

import 'package:clase_2/presentation/screen/home.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
    );
  }
}
