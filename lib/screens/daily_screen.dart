import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/models/day.dart';
import 'package:weather_app/screens/daily_search_screen.dart';

class DailyScreen extends StatefulWidget {
  @override
  _DailyScreenState createState() => _DailyScreenState();
}

class _DailyScreenState extends State<DailyScreen> {
  //Varibles used to retrieve data from openweathermap API.
  var city;
  var lat;
  var long;

  var dailyWeather = new List<DayWeather>();

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

  //Used to return the name of the month that corresponds to the int passed.
  String getMonth(int mo) {
    if (mo == 1) {
      return "January";
    } else if (mo == 2) {
      return "February";
    } else if (mo == 3) {
      return "March";
    } else if (mo == 4) {
      return "April";
    } else if (mo == 5) {
      return "May";
    } else if (mo == 6) {
      return "June";
    } else if (mo == 7) {
      return "July";
    } else if (mo == 8) {
      return "August";
    } else if (mo == 9) {
      return "September";
    } else if (mo == 10) {
      return "October";
    } else if (mo == 11) {
      return "November";
    } else if (mo == 12) {
      return "December";
    } else {
      return "null";
    }
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
    String url1 = "http://api.openweathermap.org/data/2.5/weather?lat=" +
        lat.toString() +
        "&lon=" +
        long.toString() +
        "&units=imperial&appid=956501a19b5653ae44c01509383e63a0";

    http.Response response = await http.get(url1);
    //API results are in JSON format so they must be decoded.
    var results = jsonDecode(response.body);
    //Name of city is retrived from first API call.
    setState(() {
      this.city = results['name'];
    });
    //Second call to API retrieves hourly weather data.
    String url2 = "https://api.openweathermap.org/data/2.5/onecall?lat=" +
        lat.toString() +
        "&lon=" +
        long.toString() +
        "&exclude=current,minutely,hourly,alerts&units=imperial&appid=956501a19b5653ae44c01509383e63a0";
    http.Response response2 = await http.get(url2);
    //API results are in JSON format so they must be decoded.
    //Second API call.
    //Retrieves the daily weather information from the API.
    results = jsonDecode(response2.body);
    //New list that will be copied into dailyWeather
    var dailyCopy = new List<DayWeather>();
    //New DayWeather object that will be used to hold a temporary copy to pass into the list.
    DayWeather clone;
    //Holds the current date
    var currDate = DateTime.now();

    //Copies each of the 8 days of daily weather provided by the API into dailyCopy
    for (int i = 0; i < 8; i++) {
      clone = new DayWeather(null, null, null, null, null, null, null);

      currDate = currDate.add(Duration(days: 1));

      clone.date = currDate;
      clone.high = results['daily'][i]['temp']['max'].round();
      clone.low = results['daily'][i]['temp']['min'].round();
      clone.humidity = results['daily'][i]['humidity'];
      clone.description = results['daily'][i]['weather'][0]['main'];
      clone.iconCode = results['daily'][i]['weather'][0]['icon'];
      clone.windSpeed = results['daily'][i]['wind_speed'];

      dailyCopy.add(clone);
    }

    //Makes dailyWeather equal to dailyCopy.
    setState(() {
      this.dailyWeather = dailyCopy;
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
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        width: 350,
                        height: 30,
                        margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: 300,
                              height: 30,
                              margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                              child: TextField(
                                  key: Key('search-bar'),
                                  controller: _textController,
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
                                      size: 25,
                                    ),
                                  )),
                            ),
                            Container(
                              width: 30,
                              height: 30,
                              child: Ink(
                                decoration: const ShapeDecoration(
                                  color: Colors.white,
                                  shape: CircleBorder(),
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    var route = new MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          new DailySearchScreen(
                                              value: _textController.text),
                                    );
                                    Navigator.of(context).push(route);
                                  },
                                  icon: Icon(Icons.search),
                                  color: Color(0xFFFFFFFF),
                                ),
                              ),
                            )
                          ],
                        )),
                    Container(
                      child: Text(city != null ? city.toString() : "---",
                          style: GoogleFonts.montserrat(
                            fontSize: 30,
                            color: Color(0xFFFFFFFF),
                          )),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 5, 0, 20),
                      child: Text("Daily Forecast",
                          style: GoogleFonts.montserrat(
                            fontSize: 20,
                            color: Color(0xFFFFFFFF),
                          )),
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: dailyWeather.length,
                          itemBuilder: (context, index) {
                            return Container(
                                height: 190,
                                margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: BoxDecoration(
                                    color: Color(0xFFFFFFFF),
                                    borderRadius: BorderRadius.circular(15.0),
                                    border: Border.all(
                                      width: 3,
                                      color: Color(0xFF6190E8),
                                    )),
                                child: Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      margin: const EdgeInsets.fromLTRB(
                                          0, 10, 0, 10),
                                      child: Text(
                                          dailyWeather.isNotEmpty
                                              ? getMonth(dailyWeather[index]
                                                      .date
                                                      .month) +
                                                  " " +
                                                  dailyWeather[index]
                                                      .date
                                                      .day
                                                      .toString() +
                                                  ", " +
                                                  dailyWeather[index]
                                                      .date
                                                      .year
                                                      .toString()
                                              : "---",
                                          style: GoogleFonts.montserrat(
                                            fontSize: 25,
                                            color: Color(0xFF6190E8),
                                          )),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.arrow_drop_up,
                                                  color: Color(0xFF6190E8),
                                                  size: 20,
                                                ),
                                                Container(
                                                  alignment: Alignment.center,
                                                  margin:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 5, 0, 5),
                                                  child: Text(
                                                      dailyWeather.isNotEmpty
                                                          ? " High: " +
                                                              dailyWeather[
                                                                      index]
                                                                  .high
                                                                  .toString() +
                                                              "\u00B0" +
                                                              "f"
                                                          : "---",
                                                      style: GoogleFonts
                                                          .montserrat(
                                                        fontSize: 16,
                                                        color:
                                                            Color(0xFF6190E8),
                                                      )),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.arrow_drop_down,
                                                  color: Color(0xFF6190E8),
                                                  size: 20,
                                                ),
                                                Container(
                                                  alignment: Alignment.center,
                                                  margin:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 5, 0, 5),
                                                  child: Text(
                                                      dailyWeather.isNotEmpty
                                                          ? " Low: " +
                                                              dailyWeather[
                                                                      index]
                                                                  .low
                                                                  .toString() +
                                                              "\u00B0" +
                                                              "f"
                                                          : "---",
                                                      style: GoogleFonts
                                                          .montserrat(
                                                        fontSize: 16,
                                                        color:
                                                            Color(0xFF6190E8),
                                                      )),
                                                ),
                                              ],
                                            ),
                                            Container(
                                                alignment: Alignment.center,
                                                margin:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 5, 0, 5),
                                                decoration: BoxDecoration(
                                                  color: Color(0xFFFFFFFF),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          40.0),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.bubble_chart,
                                                      color: Color(0xFF6190E8),
                                                      size: 20,
                                                    ),
                                                    Text(
                                                        dailyWeather.isNotEmpty
                                                            ? " Humidity: " +
                                                                dailyWeather[
                                                                        index]
                                                                    .humidity
                                                                    .toString() +
                                                                "%"
                                                            : "---",
                                                        style: GoogleFonts
                                                            .montserrat(
                                                          fontSize: 16,
                                                          color:
                                                              Color(0xFF6190E8),
                                                        )),
                                                  ],
                                                )),
                                            Container(
                                                alignment: Alignment.center,
                                                margin:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 5, 0, 5),
                                                decoration: BoxDecoration(
                                                  color: Color(0xFFFFFFFF),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          40.0),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.toys,
                                                      color: Color(0xFF6190E8),
                                                      size: 20,
                                                    ),
                                                    Text(
                                                        dailyWeather.isNotEmpty
                                                            ? " Wind Speed: " +
                                                                dailyWeather[
                                                                        index]
                                                                    .windSpeed
                                                                    .toString() +
                                                                " mph"
                                                            : "---",
                                                        style: GoogleFonts
                                                            .montserrat(
                                                          fontSize: 16,
                                                          color:
                                                              Color(0xFF6190E8),
                                                        )),
                                                  ],
                                                )),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.fromLTRB(
                                                  0, 0, 0, 10),
                                              child: Text(
                                                  dailyWeather[index]
                                                      .description
                                                      .toString(),
                                                  style: GoogleFonts.montserrat(
                                                    fontSize: 18,
                                                    color: Color(0xFF6190E8),
                                                  )),
                                            ),
                                            Container(
                                              width: 70,
                                              height: 70,
                                              decoration: BoxDecoration(
                                                color: Color(0xFF6190E8),
                                                borderRadius:
                                                    BorderRadius.circular(40.0),
                                              ),
                                              alignment: Alignment.center,
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              margin: const EdgeInsets.fromLTRB(
                                                  0, 0, 0, 0),
                                              child: Image.network(
                                                "http://openweathermap.org/img/wn/" +
                                                    dailyWeather[index]
                                                        .iconCode
                                                        .toString() +
                                                    ".png",
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ));
                          }),
                    ),
                  ]),
            )));
  }
}
