import 'package:flutter/material.dart';
import 'package:signal_app/router/router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'SIGNAL',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Color(0xFF217EFA))),
      routerConfig: router,
    );
  }
}
