// ignore_for_file: avoid_print, unused_import
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:gemini_ai_app/secrets.dart'; // Make sure to create this file with your API key

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  State createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  Uint8List? _imageBytes;
  String _response = '';

  Future<void> _captureImage() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _imageBytes = bytes;
      });
    }
  }

  Future<void> _sendImageToGemini() async {
    if (_imageBytes == null) {
      setState(() {
        _response = 'Please capture an image first.';
      });
      return;
    }

    final url = 'https://generativelanguage.googleapis.com/v1/models/gemini-1.5-flash:generateContent';

    final headers = {
      'Content-Type': 'application/json',
      'x-goog-api-key': apiKey, // apiKey is imported from secrets.dart
    };

    final base64Image = base64Encode(_imageBytes!);

    final body = jsonEncode({
      'contents': [
        {
          'parts': [
            {'text': "What's in this image?"},
            {
              'inline_data': {
                'mime_type': 'image/jpeg',
                'data': base64Image,
              },
            },
          ],
        },
      ],
    });

    try {
      final response = await http.post(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        setState(() {
          _response = jsonResponse['candidates'][0]['content']['parts'][0]['text'];
        });
      } else {
        setState(() {
          _response = 'Error ${response.statusCode}: ${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        _response = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera and Gemini API'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_imageBytes != null)
                Image.memory(_imageBytes!, height: 200),
              ElevatedButton(
                onPressed: _captureImage,
                child: const Text('Capture Image'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _sendImageToGemini,
                child: const Text('Send to Gemini API'),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(_response),
              ),
            ],
          ),
        ),
      ),
    );
  }
}