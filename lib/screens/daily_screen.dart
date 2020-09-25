import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DailyScreen extends StatefulWidget {
  @override
  _DailyScreenState createState() => _DailyScreenState();
}

class _DailyScreenState extends State<DailyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6FEFF),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Daily Weather",
            key: Key('weather-app-text'),
            style: GoogleFonts.montserrat(
                fontSize: 45,
                fontWeight: FontWeight.bold,
                color: Color(0xFF005365)),
          ),
          Text("Weather by the day.",
              style: GoogleFonts.montserrat(
                  fontSize: 18, color: Color(0xFF005365)))
        ],
      )),
    );
  }
}
