import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/screens/current_search_screen.dart';

//import '../../../../Flutter/flutter/packages/flutter/lib/cupertino.dart';

//import '../../../../Flutter/flutter/packages/flutter/lib/cupertino.dart';
//import '../../../../Flutter/flutter/packages/flutter/lib/cupertino.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  var temperature;
  var conditions;
  var currently;
  var humidity;
  var windSpeed;
  var city;
  var iconCode;
  var lat;
  var long;

  //Variable for passing search bar data
  var _textController = new TextEditingController();

  //Used to capitalize strings.
  String capitalize(String string) {
    if (string == null) {
      throw ArgumentError("string: $string");
    }

    if (string.isEmpty) {
      return string;
    }

    return string[0].toUpperCase() + string.substring(1);
  }

  Future getWeather() async {
    //Gets Position using geolocator.
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    //Sets latitude and longitude.
    setState(() {
      lat = position.latitude;
      long = position.longitude;
    });

    //Retrieves data from the API
    //Values of Latitude and Longitude are concatenated into the url to retrive the correct
    //information based on the user's current location.
    http.Response response = await http.get(
        "http://api.openweathermap.org/data/2.5/weather?lat=" +
            lat.toString() +
            "&lon=" +
            long.toString() +
            "&units=imperial&appid=956501a19b5653ae44c01509383e63a0");
    //API results are in JSON format so they must be decoded.
    var results = jsonDecode(response.body);
    //Variables are set to their corresponding information.
    setState(() {
      this.temperature = results['main']['temp'].round();
      this.conditions = capitalize(results['weather'][0]['description']);
      this.currently = results['weather'][0]['main'];
      this.humidity = results['main']['humidity'];
      this.windSpeed = results['wind']['speed'];
      this.city = results['name'];
      this.iconCode = results['weather'][0]['icon'];
    });
  }

  //Calls this fucntions before the page is built.
  @override
  void initState() {
    this.getWeather();

    super.initState();
  }

  String getMessage(int temp) {
    if (temp > 85) {
      return 'It\'s hot outside! 🍦 time ';
    } else if (temp > 65) {
      return 'Time for shorts and 👕 ';
    } else if (temp > 55) {
      return 'Bring a 🧥 just in case ';
    } else {
      return 'It\'s cold outside! You\'ll need 🧣 and 🧤 ';
    }
  }

  String getCondition(String conditions) {
    if (conditions != 'clear sky') {
      return 'High chance of 🌧 don\'t forget your ☔️';
    } else {
      return 'The sky is clear, enjoy the beauiful day ☀️';
    }
  }

  String getActivity(int temp) {
    if (temp > 80) {
      return ' Travel to the nearest beach, wear sun block';
    } else if (temp > 70) {
      return ' Go to a park, or a lake near by! ';
    } else if (temp > 50) {
      return 'Get a coffee at a local coffee shop, go to a movie';
    } else {
      return ' Stay indoors, watch a movie at home!';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [const Color(0xFFA7BFE8), const Color(0xFF6190E8)],
      )),
      child: SingleChildScrollView(
          child: Center(
              child: Padding(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      alignment: Alignment.center,
                      child: Text(
                        "Tips for Current Conditions",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          fontSize: 25,
                          color: Color(0xFF6190E8),
                        ),
                      ),
                    ),
                    Divider(
                      height: 3,
                      thickness: 2,
                      color: Color(0xFF6190E8),
                      indent: 5,
                      endIndent: 5,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                      alignment: Alignment.center,
                      child: Text(
                        conditions != null ? getCondition(conditions) : "---",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          fontSize: 20,
                          color: Color(0xFF6190E8),
                        ),
                      ),
                    ),
                  ],
                )),
            Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      alignment: Alignment.center,
                      child: Text(
                        "Recommended Attire",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          fontSize: 25,
                          color: Color(0xFF6190E8),
                        ),
                      ),
                    ),
                    Divider(
                      height: 3,
                      thickness: 2,
                      color: Color(0xFF6190E8),
                      indent: 5,
                      endIndent: 5,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                      alignment: Alignment.center,
                      child: Text(
                        temperature != null ? getMessage(temperature) : "---",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          fontSize: 20,
                          color: Color(0xFF6190E8),
                        ),
                      ),
                    ),
                  ],
                )),
            Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      alignment: Alignment.center,
                      child: Text(
                        "Activity Suggestion",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          fontSize: 25,
                          color: Color(0xFF6190E8),
                        ),
                      ),
                    ),
                    Divider(
                      height: 3,
                      thickness: 2,
                      color: Color(0xFF6190E8),
                      indent: 5,
                      endIndent: 5,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                      alignment: Alignment.center,
                      child: Text(
                        temperature != null ? getActivity(temperature) : "---",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          fontSize: 20,
                          color: Color(0xFF6190E8),
                        ),
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ))),
    ));
  }
}

//new code
