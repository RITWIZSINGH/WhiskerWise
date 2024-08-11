// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gemini_ai_app/screens/information_screen.dart';
import 'package:gemini_ai_app/pages/camera_page.dart';
import 'dart:convert';
import 'dart:typed_data';

class HomePage extends StatelessWidget {
  Uint8List _decodeImage(String imageString) {
    return base64Decode(imageString);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('WHISKERWISE')),
      body: SafeArea(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CameraPage()),
                );
              },
              child: Text('Analyze New Pet'),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('animals').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  return ListView(
                    children: snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                      Uint8List imageBytes = _decodeImage(data['image']);
                      return Card(
                        child: ListTile(
                          leading: Image.memory(
                            imageBytes,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          title: Text('Pet Analysis'),
                          subtitle: Text('Tap to view details'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InformationScreen(
                                  imageBytes: imageBytes,
                                  analysisResults: List<String>.from(data['analysis']),
                                  questions: List<String>.from(data['questions']),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}