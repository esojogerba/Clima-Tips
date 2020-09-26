import 'package:flutter/material.dart';
import 'package:weather_app/screens/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/services/auth.dart';
import 'package:weather_app/models/user.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}
