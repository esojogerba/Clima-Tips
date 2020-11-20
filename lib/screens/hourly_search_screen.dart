import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/models/hour.dart';

class HourlySearchScreen extends StatefulWidget {
  String value;

  HourlySearchScreen({Key, key, this.value}) : super(key: key);

  @override
  _HourlySearchScreenState createState() => _HourlySearchScreenState();
}

class _HourlySearchScreenState extends State<HourlySearchScreen> {
  //Varibles used to retrieve data from openweathermap API.
  var city;
  var lat;
  var long;

  var hourlyWeather = new List<HourWeather>();

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
    //Retrieves data from API.
    //This first call is used to get the latitude and longitude of the city that was searched.
    http.Response response1 = await http.get(
        "http://api.openweathermap.org/data/2.5/weather?q=" +
            "${widget.value}" +
            "&appid=956501a19b5653ae44c01509383e63a0");

    //"${widget.value}"

    //API results are in JSON format so they must be decoded.
    var results = jsonDecode(response1.body);
    //Variables are set to their corresponding information.
    setState(() {
      this.long = results['coord']['lon'];
      this.lat = results['coord']['lat'];
    });

    //Retrieves data from the API
    //Values of Latitude and Longitude are concatenated into the url to retrive the correct
    //information based on the user's current location.
    String url1 = "http://api.openweathermap.org/data/2.5/weather?lat=" +
        lat.toString() +
        "&lon=" +
        long.toString() +
        "&units=imperial&appid=956501a19b5653ae44c01509383e63a0";

    http.Response response = await http.get(url1);
    //API results are in JSON format so they must be decoded.
    results = jsonDecode(response.body);
    //Name of city is retrived from first API call.
    setState(() {
      this.city = results['name'];
    });
    //Second call to API retrieves hourly weather data.
    String url2 = "https://api.openweathermap.org/data/2.5/onecall?lat=" +
        lat.toString() +
        "&lon=" +
        long.toString() +
        "&exclude=current,minutely,daily,alerts&units=imperial&appid=956501a19b5653ae44c01509383e63a0";
    http.Response response2 = await http.get(url2);
    //API results are in JSON format so they must be decoded.
    //Second API call.
    //Retrieves the hourly weather information from the API.
    results = jsonDecode(response2.body);
    //New list that will be copied into hourlyWeather
    var hourlyCopy = new List<HourWeather>();
    //New HourWeather object that will be used to hold a temporary copy to pass into the list.
    HourWeather clone;
    var currDate = DateTime.now();
    var hour = currDate.hour + 1;
    var period = "A.M";

    //Copies each of the 48 hours of hourly weather provided by the API into hourlyCopy
    for (int i = 0; i < 48; i++) {
      clone = new HourWeather(null, null, null, null, null, null, null);

      if (hour == 24) {
        hour = 0;
      }
      if (hour == 0) {
        period = "A.M";
        clone.hour = 12;
        clone.period = period;
      }
      if (hour > 0 && hour < 12) {
        period = "A.M";
        clone.hour = hour;
        clone.period = period;
      }
      if (hour == 12) {
        period = "P.M";
        clone.hour = hour;
        clone.period = period;
      }
      if (hour > 12 && hour <= 23) {
        period = "P.M";
        clone.hour = hour - 12;
        clone.period = period;
      }

      hour++;

      clone.temp = results['hourly'][i]['temp'].round();
      clone.humidity = results['hourly'][i]['humidity'];
      clone.description = results['hourly'][i]['weather'][0]['main'];
      clone.iconCode = results['hourly'][i]['weather'][0]['icon'];
      clone.windSpeed = results['hourly'][i]['wind_speed'];

      hourlyCopy.add(clone);
    }

    //Makes hourlyWeather equal to hourlyCopy.
    setState(() {
      this.hourlyWeather = hourlyCopy;
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
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(40.0),
            child: AppBar(
              backgroundColor: Color(0xFFFFFFFF),
              elevation: 0.0,
              // Here we take the value from the MyHomePage object that was created by
              // the App.build method, and use it to set our appbar title.
            )),
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: Text(city != null ? city.toString() : "---",
                          style: GoogleFonts.montserrat(
                            fontSize: 30,
                            color: Color(0xFFFFFFFF),
                          )),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 5, 0, 20),
                      child: Text("Hourly Forecast",
                          style: GoogleFonts.montserrat(
                            fontSize: 20,
                            color: Color(0xFFFFFFFF),
                          )),
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: hourlyWeather.length,
                          itemBuilder: (context, index) {
                            return Container(
                                height: 50,
                                margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                decoration: BoxDecoration(
                                  color: Color(0xFFFFFFFF),
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                        width: 70,
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.all(10.0),
                                        margin: const EdgeInsets.fromLTRB(
                                            0, 0, 0, 0),
                                        child: Text(
                                            hourlyWeather.isNotEmpty
                                                ? hourlyWeather[index]
                                                        .hour
                                                        .toString() +
                                                    " " +
                                                    hourlyWeather[index]
                                                        .period
                                                        .toString()
                                                : "---",
                                            style: GoogleFonts.montserrat(
                                              fontSize: 12,
                                              color: Color(0xFF6190E8),
                                            ))),
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Color(0xFF6190E8),
                                        borderRadius:
                                            BorderRadius.circular(40.0),
                                      ),
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.all(2.0),
                                      margin:
                                          const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      child: Image.network(
                                        "http://openweathermap.org/img/wn/" +
                                            hourlyWeather[index]
                                                .iconCode
                                                .toString() +
                                            ".png",
                                        width: 40,
                                        height: 40,
                                      ),
                                    ),
                                    Container(
                                        width: 70,
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.all(10.0),
                                        margin: const EdgeInsets.fromLTRB(
                                            0, 0, 0, 0),
                                        child: Text(
                                            hourlyWeather.isNotEmpty
                                                ? hourlyWeather[index]
                                                        .temp
                                                        .toString() +
                                                    "\u00B0" +
                                                    "f"
                                                : "---",
                                            style: GoogleFonts.montserrat(
                                              fontSize: 12,
                                              color: Color(0xFF6190E8),
                                            ))),
                                    Container(
                                        width: 20,
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.all(2.0),
                                        margin: const EdgeInsets.fromLTRB(
                                            0, 0, 0, 0),
                                        child: Icon(
                                          Icons.bubble_chart,
                                          color: Color(0xFF6190E8),
                                          size: 20,
                                        )),
                                    Container(
                                        width: 70,
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.all(10.0),
                                        margin: const EdgeInsets.fromLTRB(
                                            0, 0, 0, 0),
                                        child: Text(
                                            hourlyWeather.isNotEmpty
                                                ? hourlyWeather[index]
                                                        .humidity
                                                        .toString() +
                                                    "%"
                                                : "---",
                                            style: GoogleFonts.montserrat(
                                              fontSize: 12,
                                              color: Color(0xFF6190E8),
                                            ))),
                                    Container(
                                        width: 20,
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.all(2.0),
                                        margin: const EdgeInsets.fromLTRB(
                                            0, 0, 0, 0),
                                        child: Icon(
                                          Icons.toys,
                                          color: Color(0xFF6190E8),
                                          size: 20,
                                        )),
                                    Container(
                                        width: 70,
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.all(10.0),
                                        margin: const EdgeInsets.fromLTRB(
                                            0, 0, 0, 0),
                                        child: Text(
                                            hourlyWeather.isNotEmpty
                                                ? hourlyWeather[index]
                                                        .windSpeed
                                                        .toString() +
                                                    "\n" +
                                                    "mph"
                                                : "---",
                                            style: GoogleFonts.montserrat(
                                              fontSize: 12,
                                              color: Color(0xFF6190E8),
                                            ))),
                                  ],
                                ));
                          }),
                    ),
                  ]),
            )));
  }
}
