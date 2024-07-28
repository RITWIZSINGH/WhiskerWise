// ignore_for_file: avoid_print, prefer_const_constructors, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _response = '';

  Future<void> gemini() async {
    // Replace 'YOUR_API_KEY' with your actual API key
    const apiKey = 'AIzaSyDhBDrzL8jyEvI6zPaINmWrnp_tT0m0EOg';
    
    final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
    final content = [Content.text('Write a story about a magic backpack.')];
    
    try {
      final response = await model.generateContent(content);
      setState(() {
        _response = response.text ?? 'No response';
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        _response = 'Error occurred';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gemini AI Demo')),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: gemini,
                child: Text('Generate Story'),
              ),
              SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(_response),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}