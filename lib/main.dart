import 'package:demo/auth/auth.dart';
import 'package:demo/screens/loginhome.dart';
import 'package:demo/volunteer/voluntter_home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

void main() async {
  //this function will keep login even if the user exit from the application
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Event Pulse',
      home: const AuthPage(),
      routes: {
        '/login': (context) => const Login(),
        '/home': (context) => const VolunteerHome(),
      },
    );
  }
}
