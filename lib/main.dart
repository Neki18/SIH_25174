import 'package:flutter/material.dart';
import 'screens/register_screen.dart';
import 'screens/login_screen.dart'; // <- import login screen

void main() {
  runApp(FishMVPApp());
}

class FishMVPApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fish MVP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginScreen(), // <- start with login screen
    );
  }
}
