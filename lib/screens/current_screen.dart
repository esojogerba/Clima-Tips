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
  var iconCode;
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
      this.iconCode = results['weather'][0]['icon'];
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
        backgroundColor: Color(0xFF6190E8),
        body: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [const Color(0xFFA7BFE8), const Color(0xFF6190E8)],
            )),
            child: Center(
                child: new SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        width: 350,
                        height: 30,
                        margin: const EdgeInsets.fromLTRB(0, 20, 0, 30),
                        child: TextField(
                            key: Key('search-bar'),
                            decoration: InputDecoration(
                              //color: Color(0xFFFFFFFF),
                              border: new OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(30.0),
                                ),
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                                color: Color(0xFFFFFFFF),
                              ),
                            ))),
                    Text(city != null ? city.toString() : "---",
                        style: GoogleFonts.montserrat(
                          fontSize: 30,
                          color: Color(0xFFFFFFFF),
                        )),
                    Text(currently != null ? currently.toString() : "---",
                        style: GoogleFonts.montserrat(
                          fontSize: 20,
                          color: Color(0xFFFFFFFF),
                        )),
                    Container(
                        width: 300,
                        margin: const EdgeInsets.fromLTRB(0, 30, 0, 30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Image.network(
                              "http://openweathermap.org/img/wn/" +
                                  iconCode.toString() +
                                  ".png",
                            ),
                            Text(
                              temperature != null
                                  ? temperature.toString() + "\u00B0" + "f"
                                  : "---",
                              style: GoogleFonts.montserrat(
                                fontSize: 70,
                                color: Color(0xFFFFFFFF),
                              ),
                            )
                          ],
                        )),
                    Container(
                        width: 375,
                        height: 50,
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        decoration: BoxDecoration(
                          color: Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                width: 50,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(2.0),
                                margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: Icon(
                                  Icons.cloud_outlined,
                                  color: Color(0xFF6190E8),
                                  size: 30,
                                )),
                            Container(
                                width: 150,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(10.0),
                                margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                child: Text("Conditions:",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 16,
                                      color: Color(0xFF6190E8),
                                    ))),
                            Container(
                                width: 150,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(10.0),
                                margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                                child: Text(
                                    conditions != null
                                        ? conditions.toString()
                                        : "---",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 16,
                                      color: Color(0xFF6190E8),
                                    )))
                          ],
                        )),
                    Container(
                        width: 375,
                        height: 50,
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        decoration: BoxDecoration(
                          color: Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                                width: 50,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(2.0),
                                margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: Icon(
                                  Icons.bubble_chart_outlined,
                                  color: Color(0xFF6190E8),
                                  size: 30,
                                )),
                            Container(
                                width: 150,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(10.0),
                                margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                child: Text("Humidity:",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 16,
                                      color: Color(0xFF6190E8),
                                    ))),
                            Container(
                                width: 150,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(10.0),
                                margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                                child: Text(
                                    humidity != null
                                        ? humidity.toString() + "%"
                                        : "---",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 16,
                                      color: Color(0xFF6190E8),
                                    )))
                          ],
                        )),
                    Container(
                        width: 375,
                        height: 50,
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 100),
                        decoration: BoxDecoration(
                          color: Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                                width: 50,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(2.0),
                                margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: Icon(
                                  Icons.toys_outlined,
                                  color: Color(0xFF6190E8),
                                  size: 30,
                                )),
                            Container(
                                width: 150,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(10.0),
                                margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                child: Text("Wind Speed:",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 16,
                                      color: Color(0xFF6190E8),
                                    ))),
                            Container(
                                width: 150,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(10.0),
                                margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                                child: Text(
                                    windSpeed != null
                                        ? windSpeed.toString() + " mph"
                                        : "---",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 16,
                                      color: Color(0xFF6190E8),
                                    )))
                          ],
                        )),
                    Container(
                        width: 350,
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 200),
                        child: Column(
                          children: [
                            Text("Lat: " + lat.toString(),
                                style: GoogleFonts.montserrat(
                                  fontSize: 20,
                                  color: Color(0xFFFFFFFF),
                                )),
                            Text("Long: " + long.toString(),
                                style: GoogleFonts.montserrat(
                                  fontSize: 20,
                                  color: Color(0xFFFFFFFF),
                                )),
                          ],
                        )),
                  ]),
            ))));
  }
}
