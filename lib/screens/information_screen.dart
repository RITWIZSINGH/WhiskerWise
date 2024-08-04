// ignore_for_file: use_key_in_widget_constructors, use_super_parameters, prefer_const_constructors_in_immutables, prefer_const_constructors

import 'dart:typed_data';

import 'package:flutter/material.dart';

class InformationScreen extends StatelessWidget {
  final Uint8List imageBytes;
  final String analysisResult;

  InformationScreen({
    Key? key,
    required this.imageBytes,
    required this.analysisResult,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pet Analysis'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.memory(
              imageBytes,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              analysisResult.isEmpty
                  ? 'No animal found in the image.'
                  : analysisResult,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
