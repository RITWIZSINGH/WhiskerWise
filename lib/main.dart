// ignore_for_file: avoid_print, prefer_const_constructors, avoid_unnecessary_containers, unused_import, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:gemini_ai_app/screens/navigation_screen.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:gemini_ai_app/pages/home_page.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      name: "whisker-wise",
      options: FirebaseOptions(
          apiKey: "AIzaSyD3FCukEvPCsdd-F0M2leUXbLm2nfooZAs",
          appId: "1:220580041211:web:0bdbda5303ad43c8e2bb5e",
          messagingSenderId: "220580041211",
          projectId: "whisker-wise"));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NavigationScreen(),
    );
  }
}