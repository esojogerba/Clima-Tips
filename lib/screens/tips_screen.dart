import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/screens/current_search_screen.dart';



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
    Position position =
        await getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
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
      return 'It\'s hot outside!🍦 time ';
    } else if (temp > 65) {
      return 'Time for shorts and 👕  ';
    } else if (temp > 55) {
      return 'Bring a 🧥 just in case ';
    } else {
      return 'It\'s cold outside!You\'ll need 🧣 and 🧤 ';
    }
  }

  String getCondition(String conditions) {
    if (conditions !='clear sky') {
      return 'High chance of 🌧 don\'t forget your ☔️';
    }else
    {
       return 'The sky is clear,enjoy the beauiful day ☀️' ;
    }

  }

  String getActivity(int temp)
  {
    if (temp >80) {
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
      backgroundColor: Color(0xFF6190E8),
      body: Container(
         margin: const EdgeInsets.only(left: 20.0, right: 20.0),
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [const Color(0xFFA7BFE8), const Color(0xFF6190E8)],
          )),
          child: Center(
              child: Column(
                 crossAxisAlignment: CrossAxisAlignment.center,
           // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
               Text( "           ",
                  style: GoogleFonts.montserrat(
                      fontSize: 20, color: Color(0xFFFFFFFF))),
              Text(conditions != null ? getCondition(conditions) : "---",
               
                key: Key('weathercondition'),
                style: GoogleFonts.montserrat(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFFFFF)),
              ),

               Text( "           ",
                  style: GoogleFonts.montserrat(
                      fontSize: 20, color: Color(0xFFFFFFFF))),
              Text('🤷' ,
               
                style: GoogleFonts.montserrat(
                    fontSize: 50,
                   // fontWeight: FontWeight.bold,
                    color: Color(0xFFFFFFFF)),
              ),
              Text(temperature != null ? getMessage(temperature) : "---",
               
                key: Key('weathermessage'),
                style: GoogleFonts.montserrat(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFFFFF)),
              ),

               Text( "--------------------------",
                  style: GoogleFonts.montserrat(
                      fontSize: 35, color: Color(0xFFFFFFFF))),

                      
                       Text("Activity suggestion :      ",
                  style: GoogleFonts.montserrat(
                      fontSize: 30, color:Color(0xFFFFEB3B))),
              Text(temperature != null ? getActivity(temperature) : "---",
                  style: GoogleFonts.montserrat(
                      fontSize: 30, color: Color(0xFFFFFFFF)))
            ],
          ))),
    );
  }
}



//new code
