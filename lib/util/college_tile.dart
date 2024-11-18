import 'package:flutter/material.dart';

class CollegeTile extends StatelessWidget {
  final String eventname;
  final String eventprice;
  final String eventImage;
  final double borderRadius = 12;
  const CollegeTile({
    super.key,
    required this.eventname,
    required this.eventImage,
    required this.eventprice,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: 200,
        height: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
          image: DecorationImage(
            image: eventImage.startsWith('assets')
                ? AssetImage(eventImage) as ImageProvider
                : NetworkImage(eventImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.white.withOpacity(0.8),
              child: Text(
                eventname,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
