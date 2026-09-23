import 'package:flutter/material.dart';

import '../screens/home_screen.dart';

class CncJarvisApp extends StatelessWidget {
  const CncJarvisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CNC JARVIS',
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF080B0F),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00E676),
          brightness: Brightness.dark,
        ),
        fontFamily: 'Arial',
      ),
      home: const HomeScreen(),
    );
  }
}
