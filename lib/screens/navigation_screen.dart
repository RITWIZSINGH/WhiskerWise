// ignore_for_file: prefer_const_constructors, unused_field, use_super_parameters, unused_import, unused_element, sort_child_properties_last

import 'package:flutter/material.dart';
import '../pages/home_page.dart';
import 'package:gemini_ai_app/pages/profile_page.dart';
import '../pages/camera_page.dart';
import 'package:gemini_ai_app/animation/custom_route.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _currentIndex = 0;
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

  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _changePage(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
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
        body: PageView(
          controller: _pageController,
          children: _pages,
          onPageChanged: (index){
            setState(() {
              _currentIndex = index;
            });
          },
          physics: NeverScrollableScrollPhysics(),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _changePage,
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
