import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HourlyScreen extends StatefulWidget {
  @override
  _HourlyScreenState createState() => _HourlyScreenState();
}

class _HourlyScreenState extends State<HourlyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6FEFF),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Hourly Weather",
            key: Key('weather-app-text'),
            style: GoogleFonts.montserrat(
                fontSize: 45,
                fontWeight: FontWeight.bold,
                color: Color(0xFF005365)),
          ),
          Text("Weather by the hour.",
              style: GoogleFonts.montserrat(
                  fontSize: 18, color: Color(0xFF005365)))
        ],
      )),
    );
  }
}
