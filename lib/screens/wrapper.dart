import 'package:flutter/material.dart';
import 'package:weather_app/screens/authenticate/authenticate.dart';
import 'package:weather_app/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/models/user.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    print(user);
    //return either home or authenticate widget
    if (user == null) {
      return Authenticate();
    } else {
      return HomeScreen();
    }
  }
}
