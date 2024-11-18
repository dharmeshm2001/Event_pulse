import 'package:flutter/material.dart';
import 'dart:async';
import 'package:demo/screens/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void redirectToMainScreen() {
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        // Check if the widget is still mounted
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Mainscreen()),
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    redirectToMainScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(30),
          height: 300,
          width: 300,
          child: Image.asset("assets/images/logo.png"),
        ),
      ),
    );
  }
}
