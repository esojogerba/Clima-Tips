import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/screens/current_screen.dart';
import 'package:weather_app/screens/daily_screen.dart';
import 'package:weather_app/screens/hourly_screen.dart';
import 'package:weather_app/screens/settings_screen.dart';

//API Key: 956501a19b5653ae44c01509383e63a0

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  PageController _pageController = PageController();
  //List of all the pages the NavBar will lead to. If new pages are added to the navbar
  //they must be added here too.
  List<Widget> _screens = [
    CurrentScreen(),
    HourlyScreen(),
    DailyScreen(),
    SettingsScreen(),
  ];

  //currentIndex is set to the index of the current page when page is changed.
  void _onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  //Changes the page when an item in the navbar is selected.
  void _onItemTapped(int selectedIndex) {
    _pageController.jumpToPage(selectedIndex);
  }

  //Builds the navbar.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: _screens,
        onPageChanged: _onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      backgroundColor: Color(0xFFF6FEFF),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        backgroundColor: Color(0xFFD4FFF7),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xFF005365),
        unselectedItemColor: Color(0xFF0084A0),
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.place,
            ),
            title: Text(
              'Current',
              style: GoogleFonts.montserrat(),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.access_time,
            ),
            title: Text(
              'Hourly',
              style: GoogleFonts.montserrat(),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.insert_invitation,
            ),
            title: Text(
              'Daily',
              style: GoogleFonts.montserrat(),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
            ),
            title: Text(
              'Settings',
              style: GoogleFonts.montserrat(),
            ),
          ),
        ],
        onTap: _onItemTapped,
      ),
    );
  }
}
