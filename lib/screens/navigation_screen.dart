// ignore_for_file: prefer_const_constructors, unused_field, use_super_parameters

import 'package:flutter/material.dart';
import '../pages/home_page.dart';
import 'package:gemini_ai_app/pages/profile_page.dart';
import '../pages/camera_page.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int currentIndex = 0;
  final List<Widget> _pages = [
    HomePage(),
    CameraPage(),
    ProfilePage(),
  ];

  // Pet-friendly color palette
  final Color _primaryColor = Color(0xFF6B4E71); // Deep purple
  final Color _secondaryColor = Color(0xFFFF9E80); // Coral
  final Color _accentColor = Color(0xFF8BC34A); // Light green
  final Color _backgroundColor = Color(0xFFF5E6D3); // Beige

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
        body: AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          child: _pages[currentIndex],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index){
            setState(() {
              currentIndex = index;
            });
          },
          iconSize: 28,
          selectedItemColor: _secondaryColor,
          unselectedItemColor: _primaryColor.withOpacity(0.5),
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.camera), label: "Camera"),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_2_outlined), label: "Profile"),
          ],
        ),
      ),
    );
  }
}
