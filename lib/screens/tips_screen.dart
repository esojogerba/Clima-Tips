import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF6190E8),
      body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [const Color(0xFFA7BFE8), const Color(0xFF6190E8)],
          )),
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Tips",
                key: Key('weather-app-text'),
                style: GoogleFonts.montserrat(
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFFFFF)),
              ),
              Text("Attire. Safety. Activities.",
                  style: GoogleFonts.montserrat(
                      fontSize: 18, color: Color(0xFFFFFFFF)))
            ],
          ))),
    );
  }
}
