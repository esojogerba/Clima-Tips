import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/screens/current_screen.dart';
import 'package:weather_app/screens/daily_screen.dart';
import 'package:weather_app/screens/hourly_screen.dart';
import 'package:weather_app/screens/tips_screen.dart';
import 'package:weather_app/services/auth.dart';

//API Key: 956501a19b5653ae44c01509383e63a0

class HomeScreen extends StatefulWidget {
  //final AuthService _auth = AuthService();

  HomeScreen({Key key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _auth = AuthService();
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
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: AppBar(
            backgroundColor: Color(0xFFFFFFFF),
            elevation: 0.0,
            actions: <Widget>[
              FlatButton.icon(
                icon: Icon(
                  Icons.person,
                  color: Color(0xFF6190E8),
                ),
                label: Text(
                  'Log Out',
                  style: GoogleFonts.montserrat(
                    color: Color(0xFF6190E8),
                  ),
                ),
                onPressed: () async {
                  await _auth.signOut();
                },
              ),
            ],
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
          )),
      body: PageView(
        controller: _pageController,
        children: _screens,
        onPageChanged: _onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      backgroundColor: Color(0xFFFFFFFF),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        backgroundColor: Color(0xFFFFFFFF),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xFF6190E8),
        unselectedItemColor: Colors.blueGrey[300],
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
              Icons.lightbulb_outline,
            ),
            title: Text(
              'Tips',
              style: GoogleFonts.montserrat(),
            ),
          ),
        ],
        onTap: _onItemTapped,
      ),
    );
  }
}
