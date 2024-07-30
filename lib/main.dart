// ignore_for_file: avoid_print, prefer_const_constructors, avoid_unnecessary_containers, unused_import

import 'package:flutter/material.dart';
import 'package:gemini_ai_app/navigation_screen.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:gemini_ai_app/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NavigationScreen(),
    );
  }
}
