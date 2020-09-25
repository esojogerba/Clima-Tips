import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:geolocator/geolocator.dart';

//API Key: 956501a19b5653ae44c01509383e63a0

class CurrentScreen extends StatefulWidget {
  @override
  _CurrentScreenState createState() => _CurrentScreenState();
}

class _CurrentScreenState extends State<CurrentScreen> {
  //Variables used to retrive data from openweathermap API.
  var temperature;
  var conditions;
  var currently;
  var humidity;
  var windSpeed;
  var city;
  var lat;
  var long;

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
    });
  }

  //Calls this fucntions before the page is built.
  @override
  void initState() {
    this.getWeather();
    super.initState();
  }

  //Builds the CurrentScreen page.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFF6FEFF),
        body: Center(
            child: new SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                    width: 300,
                    height: 30,
                    margin: const EdgeInsets.fromLTRB(0, 50, 0, 30),
                    child: TextField(
                        key: Key('search-bar'),
                        decoration: InputDecoration(
                          border: new OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(30.0),
                            ),
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Color(0xFF005365),
                          ),
                        ))),
                Text(city != null ? city.toString() : "---",
                    key: Key('city-name'),
                    style: GoogleFonts.montserrat(
                      fontSize: 30,
                      color: Color(0xFF005365),
                    )),
                Container(
                    width: 300,
                    margin: const EdgeInsets.fromLTRB(0, 30, 0, 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.flare,
                          color: Color(0xFF005365),
                          size: 130.0,
                        ),
                        Text(
                          temperature != null
                              ? temperature.toString() + "\u00B0" + "f"
                              : "---",
                          style: GoogleFonts.montserrat(
                            fontSize: 70,
                            color: Color(0xFF005365),
                          ),
                        )
                      ],
                    )),
                Container(
                    width: 350,
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(5.0),
                            margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Color(0xFF0084A0),
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: Icon(
                              Icons.cloud,
                              color: Color(0xFFFFFFFF),
                              size: 30,
                            )),
                        Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(10.0),
                            margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                            width: 125,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Color(0xFF6AFAE0),
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: Text("Conditions",
                                style: GoogleFonts.montserrat(
                                  fontSize: 18,
                                  color: Color(0xFF005365),
                                ))),
                        Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(10.0),
                            margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                            width: 125,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Color(0xFFBDFBF0),
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: Text(
                                conditions != null
                                    ? conditions.toString()
                                    : "---",
                                style: GoogleFonts.montserrat(
                                  fontSize: 14,
                                  color: Color(0xFF005365),
                                )))
                      ],
                    )),
                Container(
                    width: 350,
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(5.0),
                            margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Color(0xFF0084A0),
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: Icon(
                              Icons.bubble_chart,
                              color: Color(0xFFFFFFFF),
                              size: 30,
                            )),
                        Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(10.0),
                            margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                            width: 125,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Color(0xFF6AFAE0),
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: Text("Humidity",
                                style: GoogleFonts.montserrat(
                                  fontSize: 18,
                                  color: Color(0xFF005365),
                                ))),
                        Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(10.0),
                            margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                            width: 125,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Color(0xFFBDFBF0),
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: Text(
                                humidity != null
                                    ? humidity.toString() + "%"
                                    : "---",
                                style: GoogleFonts.montserrat(
                                  fontSize: 18,
                                  color: Color(0xFF005365),
                                )))
                      ],
                    )),
                Container(
                    width: 350,
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 300),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(5.0),
                            margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Color(0xFF0084A0),
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: Icon(
                              Icons.toys,
                              color: Color(0xFFFFFFFF),
                              size: 30,
                            )),
                        Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(10.0),
                            margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                            width: 125,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Color(0xFF6AFAE0),
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: Text("Wind Speed",
                                style: GoogleFonts.montserrat(
                                  fontSize: 16,
                                  color: Color(0xFF005365),
                                ))),
                        Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(10.0),
                            margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                            width: 125,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Color(0xFFBDFBF0),
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: Text(
                                windSpeed != null
                                    ? windSpeed.toString() + " mph"
                                    : "---",
                                style: GoogleFonts.montserrat(
                                  fontSize: 18,
                                  color: Color(0xFF005365),
                                )))
                      ],
                    )),
                Text("Lat: " + lat.toString(),
                    style: GoogleFonts.montserrat(
                      fontSize: 20,
                      color: Color(0xFF005365),
                    )),
                Text("Long: " + long.toString(),
                    style: GoogleFonts.montserrat(
                      fontSize: 20,
                      color: Color(0xFF005365),
                    )),
              ]),
        )));
  }
}
