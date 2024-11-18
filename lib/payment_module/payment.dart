import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class Payment extends StatefulWidget {
  final Map<String, dynamic> eventDoc;
  Payment({required this.eventDoc});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  String eventImage = '';
  TextEditingController _cardNumberController = TextEditingController();
  String cardNumber = '';
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime(2015),
      lastDate: DateTime(2101),
    );
  }

  @override
  void initState() {
    super.initState();
    try {
      eventImage = widget.eventDoc['poster_url'] ?? '';
    } catch (e) {
      eventImage = '';
    }
  }

  int _type = 1;
  void _handleRadio(Object? e) => setState(() {
        _type = e as int;
      });

  Future<void> sendEmail(String email, String eventName) async {
    final Email confirmationEmail = Email(
      body:
          'Your payment  request for the event "$eventName" has been successfully sent to your email.',
      subject: 'Payment Confirmation for $eventName',
      recipients: [email],
      isHTML: false,
    );

    try {
      await FlutterEmailSender.send(confirmationEmail);
      print("Email Sent");
    } catch (error) {
      print("Failed to send email: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    int debitCard_charge = 70;
    DateTime? endDate;
    if (widget.eventDoc['end_date'] != null) {
      endDate = (widget.eventDoc['end_date'] as Timestamp).toDate();
    }

    String formattedEndDate = endDate != null
        ? DateFormat('dd MMM yyyy').format(endDate)
        : 'No end date available';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 27,
                        height: 27,
                        padding: const EdgeInsets.all(3),
                        child: Icon(Icons.arrow_back),
                      ),
                    ),
                  ),
                  const Expanded(
                    flex: 10,
                    child: Center(
                      child: Text(
                        "Payment for Event",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 23,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const Expanded(flex: 1, child: Text('')),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 2,
                      spreadRadius: 1,
                      color: const Color(0xff393939).withOpacity(0.15),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 100,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: eventImage.isNotEmpty
                              ? NetworkImage(eventImage)
                              : const AssetImage(
                                      'assets/images/Event_poster.png')
                                  as ImageProvider,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                widget.eventDoc['title'] ?? 'No title',
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: Colors.black,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                widget.eventDoc['location'] ??
                                    'Unknown location',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 7,
                            width: 20,
                          ),
                          Text(
                            formattedEndDate,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Row(
                            children: [
                              const SizedBox(width: 5),
                              Text(
                                widget.eventDoc['price'] != null
                                    ? widget.eventDoc['price'].toString()
                                    : 'No fee for this event',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              const Text(
                'Payment Method',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: size.width,
                height: 55,
                margin: const EdgeInsets.only(right: 20),
                decoration: BoxDecoration(
                    border: _type == 1
                        ? Border.all(width: 1, color: const Color(0xFFDB3022))
                        : Border.all(width: 0.3, color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.transparent),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Radio(
                              value: 1,
                              groupValue: _type,
                              onChanged: _handleRadio,
                              activeColor: const Color(0xFFDB3022),
                            ),
                            Text("Add Card Details",
                                style: _type == 1
                                    ? const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black)
                                    : const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey)),
                          ],
                        ),
                        const Icon(
                          Icons.credit_card,
                          size: 30,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (_type == 1)
                Column(
                  children: [
                    const SizedBox(height: 10),
                    TextField(
                      controller: _cardNumberController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Card Number',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        cardNumber = value;
                      },
                    ),
                  ],
                ),
              const SizedBox(height: 15),
              Container(
                width: size.width,
                height: 55,
                margin: const EdgeInsets.only(right: 20),
                decoration: BoxDecoration(
                    border: _type == 2
                        ? Border.all(width: 1, color: const Color(0xFFDB3022))
                        : Border.all(width: 0.3, color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.transparent),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Radio(
                              value: 2,
                              groupValue: _type,
                              onChanged: _handleRadio,
                              activeColor: const Color(0xFFDB3022),
                            ),
                            Text("Stripe",
                                style: _type == 2
                                    ? const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black)
                                    : const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey)),
                          ],
                        ),
                        Image.asset(
                          'assets/images/stripe.png',
                          width: 60,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_type == 1 && cardNumber.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Please enter card details')),
                      );
                      return;
                    }

                    String email = 'user@example.com';
                    String eventName = widget.eventDoc['title'];

                    await sendEmail(email, eventName);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'Payment Successful! Confirmation email sent.')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffdb3022),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    fixedSize: Size(size.width * 0.8, 50),
                  ),
                  child: const Text(
                    'Proceed to Payment',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
