// ignore_for_file: prefer_const_constructors, unused_field

import 'package:flutter/material.dart';
import '../pages/home_page.dart';
import 'package:gemini_ai_app/pages/profile_page.dart';
import '../pages/camera_page.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int currentIndex = 0;
  Widget _currentPage = HomePage();

  // Pet-friendly color palette
  final Color _primaryColor = Color(0xFF6B4E71); // Deep purple
  final Color _secondaryColor = Color(0xFFFF9E80); // Coral
  final Color _accentColor = Color(0xFF8BC34A); // Light green
  final Color _backgroundColor = Color(0xFFF5E6D3); // Beige

  void changePage(int index) {
    setState(() {
      currentIndex = index;
      if (index == 0) {
        _currentPage = HomePage();
      } else if (index == 1) {
        _currentPage = const CameraPage();
      } else if (index == 2) {
        _currentPage = const ProfilePage();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: _primaryColor,
        colorScheme: ColorScheme.light(
          primary: _primaryColor,
          secondary: _secondaryColor,
          background: _backgroundColor,
        ),
        scaffoldBackgroundColor: _backgroundColor,
      ),
      child: Scaffold(
        body: _currentPage,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: changePage,
          iconSize: 28,
          selectedItemColor: _secondaryColor,
          unselectedItemColor: _primaryColor.withOpacity(0.5),
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.camera), label: "Camera"),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_2_outlined), label: "Profile"),
          ],
        ),
      ),
    );
  }
}