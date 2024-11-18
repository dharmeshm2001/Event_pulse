import 'package:flutter/material.dart';

class IntercollegeTile extends StatelessWidget {
  final String eventname;
  final String eventprice;
  final String eventImage;
  final double borderRadius = 12;
  const IntercollegeTile(
      {super.key,
      required this.eventname,
      required this.eventImage,
      required this.eventprice});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.black, borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(borderRadius),
                          topRight: Radius.circular(borderRadius))),
                  padding: EdgeInsets.all(borderRadius),
                  child: Text(
                    'Rs$eventprice',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                )
              ],
            ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
                child: Image.asset(eventImage)),
            Text(
              eventname,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.white),
            ),
            const SizedBox(
              height: 4,
            ),
            const SizedBox(
              height: 12,
            ),
            const Row(
              children: [
                Icon(
                  Icons.favorite,
                  color: Colors.white,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
