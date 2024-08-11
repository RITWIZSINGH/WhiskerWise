// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, prefer_const_declarations, use_super_parameters, unused_import
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:gemini_ai_app/screens/information_screen.dart';
import 'package:gemini_ai_app/secrets.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  State createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  bool _isLoading = false;

  final List<String> questions = [
    "Can this animal be kept as a pet? Why or why not?",
    "What are the basic needs (food, water, shelter) for this animal if kept as a pet?",
    "What are the health care requirements for this animal?",
    "What are the diet and nutrition needs for this animal?",
    "What exercise and activities does this animal need?",
    "What are the grooming requirements for this animal?",
    "What behavior and training considerations are there for this animal?",
    "What safety measures are needed for this animal?",
    "What routine and consistency does this animal require?",
    "What are the love, attention, and emergency preparedness needs for this animal?"
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _openCamera();
    });
  }

  Future<List<String>> _sendImageToGemini(Uint8List imageBytes) async {
    setState(() {
      _isLoading = true;
    });

    List<String> responses = [];

    for (String question in questions) {
      final url =
          'https://generativelanguage.googleapis.com/v1/models/gemini-1.5-pro:generateContent';
      final headers = {
        'Content-Type': 'application/json',
        'x-goog-api-key': apiKey,
      };

      final base64Image = base64Encode(imageBytes);
      final body = jsonEncode({
        'contents': [
          {
            'parts': [
              {'text': question},
              {
                'inline_data': {
                  'mime_type': 'image/jpeg',
                  'data': base64Image,
                },
              },
            ],
          },
        ],
        'generationConfig': {
          'temperature': 0.4,
          'topK': 32,
          'topP': 1,
          'maxOutputTokens': 1024,
        },
      });

      try {
        final response =
            await http.post(Uri.parse(url), headers: headers, body: body);
        if (response.statusCode == 200) {
          final jsonResponse = jsonDecode(response.body);
          final analysisResult =
              jsonResponse['candidates'][0]['content']['parts'][0]['text'];
          responses.add(analysisResult);
        } else {
          throw Exception('Error ${response.statusCode}: ${response.body}');
        }
      } catch (e) {
        responses.add('Error: $e');
      }
    }

    setState(() {
      _isLoading = false;
    });

    return responses;
  }

  Future<void> _openCamera() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    if (!mounted) return; // Check if the widget is still mounted

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      final responses = await _sendImageToGemini(bytes);
      if (!mounted) return; // Check again before navigating
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => InformationScreen(
            imageBytes: bytes,
            analysisResults: responses,
            questions: questions,
          ),
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : ElevatedButton(
                onPressed: _openCamera,
                child: Text('Take a photo')),
      ),
    );
  }
}
