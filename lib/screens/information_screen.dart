// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, prefer_const_declarations, use_super_parameters, unused_import, prefer_const_constructors_in_immutables, avoid_print
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

class InformationScreen extends StatelessWidget {
final Uint8List imageBytes;
  final List<String> analysisResults;
  final List<String> questions;

  InformationScreen({
    Key? key,
    required this.imageBytes,
    required this.analysisResults,
    required this.questions,
  }) : super(key: key);

  Future<void> _saveToFirebase() async {
    try {
      String base64Image = base64Encode(imageBytes);
      await FirebaseFirestore.instance.collection('animals').add({
        'image': base64Image,
        'analysis': analysisResults,
        'questions': questions,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error saving to Firebase: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pet Analysis'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              _saveToFirebase();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Analysis saved to home page')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: Image.memory(
                imageBytes,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16),
            for (int i = 0; i < questions.length; i++)
              Card(
                margin: EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        questions[i],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        analysisResults[i],
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Merriweather',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}