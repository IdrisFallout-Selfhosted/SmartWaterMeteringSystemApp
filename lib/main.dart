import 'package:flutter/material.dart';
import 'dart:async';
import 'login_screen.dart'; // Import MyHomePage from login_screen.dart

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    precacheImage(AssetImage('assets/logo.png'), context); // Preload the image
    return MaterialApp(
      title: 'Login Demo',
      theme: ThemeData(
        primaryColor: Color(0xFF4C337B), // Changed primaryColor to #4C337B
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF4C337B), // Changed appBar background color to #4C337B
        ),
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 3), // Change duration as needed
          () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => MyHomePage(title: 'Login')),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/logo.png', // Adjust the path to your logo image
          fit: BoxFit.contain, // Fit the image within the constraints of its container
          width: MediaQuery.of(context).size.width * 0.5, // Adjust the size as needed
          height: MediaQuery.of(context).size.height * 0.5, // Adjust the size as needed
        ),
      ),
    );
  }
}
