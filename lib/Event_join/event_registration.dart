import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EventRegistration extends StatefulWidget {
  final Map<String, dynamic> eventData;
  final String role;

  const EventRegistration({
    super.key,
    required this.eventData,
    required this.role,
  });

  @override
  _EventRegistrationState createState() => _EventRegistrationState();
}

class _EventRegistrationState extends State<EventRegistration> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _collegeController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _collegeController.dispose();
    super.dispose();
  }

  Future<void> registerUser() async {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        (widget.role == 'Student' || widget.role == 'Coordinator') &&
            _collegeController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text("Please fill in all the fields"),
          );
        },
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('registrations').add({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'college': widget.role == 'Student' || widget.role == 'Coordinator'
            ? _collegeController.text.trim()
            : '',
        'event_title': widget.eventData['title'],
        'timestamp': Timestamp.now(),
      });

      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text("Successfully registered!"),
          );
        },
      );

      _nameController.clear();
      _emailController.clear();
      _phoneController.clear();
      _collegeController.clear();
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text("Error: ${e.toString()}"),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            child: Container(
              width: double.maxFinite,
              height: 350,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: widget.eventData['poster_url'] != null
                      ? NetworkImage(widget.eventData['poster_url'])
                      : const AssetImage('assets/images/Event_poster.png')
                          as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            top: 300,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 300,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Register for the Event",
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        label: const Text("Name"),
                        hintText: "Enter your name",
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        label: const Text("Email"),
                        hintText: "Enter your email",
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        label: const Text("Phone Number"),
                        hintText: "+91XXXXXXXXXX",
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (widget.role == 'Student' ||
                        widget.role == 'Coordinator')
                      Column(
                        children: [
                          TextFormField(
                            controller: _collegeController,
                            decoration: InputDecoration(
                              label: const Text("College Name"),
                              hintText: "Enter your college name",
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black, width: 2),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.resolveWith(
                            (states) => Colors.black),
                        minimumSize: WidgetStateProperty.resolveWith(
                            (states) => const Size(120, 50)),
                      ),
                      onPressed: () async {
                        await registerUser();
                        Navigator.pop(context);
                      },
                      child: Center(
                        child: const Text(
                          'Register',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
