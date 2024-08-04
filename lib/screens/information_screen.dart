// ignore_for_file: use_key_in_widget_constructors, use_super_parameters

import 'dart:typed_data';

import 'package:flutter/material.dart';

class InformationScreen extends StatelessWidget {

   final Uint8List imageBytes;
   final String analysisResult;

  const InformationScreen({Key? key,required this.imageBytes,required this.analysisResult,}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}