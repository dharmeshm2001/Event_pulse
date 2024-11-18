import 'dart:async';
import 'dart:convert';
import 'package:demo/co_ordinator/cohome.dart';
import 'package:demo/screens/forgot_password.dart';
import 'package:demo/screens/signup.dart';
import 'package:demo/student/student_home.dart';
import 'package:demo/volunteer/voluntter_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const List<String> scopes = <String>[
  'email',
  'http://www.googleapis.com/auth/contacts.readonly'
];

GoogleSignIn _googleSignIN = GoogleSignIn(
  scopes: scopes,
);

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();

  void signIn() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailTextController.text,
        password: passwordTextController.text,
      );
      final user = userCredential.user;
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('user')
            .doc(user.email)
            .get();
        if (userDoc.exists) {
          String role = userDoc['role'];
          if (role == 'Coordinator') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Cohome()),
            );
          } else if (role == 'Volunteer') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const VolunteerHome()),
            );
          } else if (role == 'Student') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const StudentHome()),
            );
          } else {
            displayMessage("Unknown role");
          }
        } else {
          displayMessage("User data not found");
        }
      }
    } on FirebaseAuthException catch (e) {
      displayMessage(e.message ?? "An error occurred");
    }
  }

  void displayMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
      ),
    );
  }

  GoogleSignInAccount? _currentUser;
  bool _isAuthorized = false;
  String _contactText = '';

  @override
  void initState() {
    super.initState();
    _googleSignIN.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      bool isAuthorized = account != null;
      setState(() {
        _currentUser = account;
        _isAuthorized = isAuthorized;
      });
      if (isAuthorized) {
        unawaited(_handleGetContact(account));
      }
    });
    _googleSignIN.signInSilently();
  }

  Future<void> _handleGetContact(GoogleSignInAccount user) async {
    setState(() {
      _contactText = "Loading Contact info...";
    });

    final http.Response response = await http.get(
      Uri.parse('https://people.googleapis.com/v1/people/me/connections?'
          'requestMask.includeField=person.names'),
      headers: await user.authHeaders,
    );
    if (response.statusCode != 200) {
      setState(() {
        _contactText = 'People API gave a ${response.statusCode} response.';
      });
      return;
    }

    final Map<String, dynamic> data =
        json.decode(response.body) as Map<String, dynamic>;
    final String? namedContact = _pickFirstNamedContact(data);

    setState(() {
      _contactText = namedContact != null
          ? 'I see you know $namedContact!'
          : 'No contacts to display';
    });
  }

  String? _pickFirstNamedContact(Map<String, dynamic> data) {
    final List<dynamic>? connections = data['connections'] as List<dynamic>?;
    final Map<String, dynamic>? contact = connections?.firstWhere(
      (dynamic contact) => (contact as Map<String, dynamic>)['names'] != null,
      orElse: () => null,
    ) as Map<String, dynamic>?;

    if (contact != null) {
      final List<dynamic> names = contact['names'] as List<dynamic>;
      final Map<String, dynamic>? name = names.firstWhere(
        (dynamic name) => (name as Map<String, dynamic>)['displayName'] != null,
        orElse: () => null,
      ) as Map<String, dynamic>?;
      return name?['displayName'] as String?;
    }
    return null;
  }

  Future<void> _handleSignIN() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIN.signIn();
      if (account != null) {
        final GoogleSignInAuthentication auth = await account.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: auth.accessToken,
          idToken: auth.idToken,
        );

        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        final user = userCredential.user;
        if (user != null) {
          DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

          if (userDoc.exists) {
            String role = userDoc['role'];

            if (role == 'coordinator') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Cohome()),
              );
            } else if (role == 'volunteer') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const VolunteerHome()),
              );
            } else if (role == 'student') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const StudentHome()),
              );
            } else {
              displayMessage("Unknown role");
            }
          } else {
            displayMessage("User data not found");
          }
        }
      }
    } catch (error) {
      displayMessage(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.1),
              padding: const EdgeInsets.all(0),
              height: 150,
              width: 150,
              child: Image.asset("assets/images/logo.png"),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.07),
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(75),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  const Text(
                    "Welcome back!",
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Text(
                    "Login to Access your account",
                    style: TextStyle(
                      fontSize: 15,
                      color: Color.fromARGB(255, 48, 46, 46),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextFormField(
                      controller: emailTextController,
                      decoration: InputDecoration(
                        label: const Text("Email"),
                        hintText: "Enter your email",
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 2),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextFormField(
                      controller: passwordTextController,
                      obscureText: true,
                      decoration: InputDecoration(
                        label: const Text("Password"),
                        hintText: "Enter your password",
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 2),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ForgotPassword(),
                            ),
                          );
                        },
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith(
                          (states) => Colors.black),
                      minimumSize: WidgetStateProperty.resolveWith(
                          (states) => const Size(250, 50)),
                    ),
                    onPressed: signIn,
                    child: const Text(
                      "Login",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Signup(),
                            ),
                          );
                        },
                        child: const Text(
                          "Register now",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 150,
                        child: Divider(
                          thickness: 2,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "OR",
                        style: TextStyle(color: Colors.black),
                      ),
                      SizedBox(
                        width: 150,
                        child: Divider(
                          thickness: 2,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: _handleSignIN,
                    child: Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width * 0.7,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.red),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.g_mobiledata, color: Colors.red, size: 35),
                          Text(
                            "Continue With Google",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
