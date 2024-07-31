// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:io';
class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {

  void main() async {
  // Access your API key as an environment variable (see "Set up your API key" above)
  final apiKey = Platform.environment['AIzaSyDhBDrzL8jyEvI6zPaINmWrnp_tT0m0EOg'];
  if (apiKey == null) {
    print('No \$API_KEY environment variable');
    exit(1);
  }
  // The Gemini 1.5 models are versatile and work with both text-only and multimodal prompts
  final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
  final (firstImage, secondImage) = await (
    File('image0.jpg').readAsBytes(),
    File('image1.jpg').readAsBytes()
  ).wait;
  final prompt = TextPart("What's different between these pictures?");
  final imageParts = [
    DataPart('image/jpeg', firstImage),
    DataPart('image/jpeg', secondImage),
  ];
  final response = await model.generateContent([
    Content.multi([prompt, ...imageParts])
  ]);
  print(response.text);
}
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}