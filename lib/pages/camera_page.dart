// ignore_for_file: avoid_print, unused_import, prefer_const_declarations, use_super_parameters, unused_local_variable, prefer_const_constructors, use_build_context_synchronously, prefer_final_fields, unused_field
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:gemini_ai_app/secrets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:gemini_ai_app/screens/information_screen.dart'; // Make sure to import this

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  State createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  String _response = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _openCamera();
  }

  Future<void> _openCamera() async {
    if (await Permission.camera.request().isGranted) {
      final imagePicker = ImagePicker();
      final pickedFile = await imagePicker.pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        await _sendImageToGemini(bytes);
      } else {
        // User cancelled the camera
        Navigator.pop(context);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Camera permission is required to use this feature')),
      );
      Navigator.pop(context);
    }
  }

  Future<void> _sendImageToGemini(Uint8List imageBytes) async {
    setState(() {
      _isLoading = true;
    });

    final url = 'https://generativelanguage.googleapis.com/v1/models/gemini-1.5-pro:generateContent';

    final headers = {
      'Content-Type': 'application/json',
      'x-goog-api-key': apiKey,
    };

    final base64Image = base64Encode(imageBytes);

    final body = jsonEncode({
      'contents': [
        {
          'parts': [
            {
              'text': """Analyze the animal in this image and provide the following information:
1. Can this animal be kept as a pet? Why or why not?
2. What are the food requirements for this animal if kept as a pet?
3. What does this animal typically like to eat in the wild?
4. What activities or enrichment does this animal enjoy or need?
5. What special care or habitat requirements does this animal have?
6. Are there any legal restrictions or ethical considerations for keeping this animal as a pet?
7. What is the typical lifespan of this animal in captivity?
8. Are there any potential health issues or veterinary care needs to be aware of?

Please provide detailed answers for each point and in your response dont write the above questions i just want to showcase your answer on my app so write according to that so that it doesn't look wierd.
Also write the answers in bullet points and if you can tell the name of animal first with bold letters and a different font suitable for a pet app"""
            },
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
      final response = await http.post(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final analysisResult = jsonResponse['candidates'][0]['content']['parts'][0]['text'];
        
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => InformationScreen(
              imageBytes: imageBytes,
              analysisResult: analysisResult,
            ),
          ),
        );
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      Navigator.pop(context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isLoading ? CircularProgressIndicator() : Text('Processing image...'),
      ),
    );
  }
}