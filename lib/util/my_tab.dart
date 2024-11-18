import 'package:flutter/material.dart';

class MyTab extends StatelessWidget {
  final String IconPath;
  final String IconName;

  const MyTab({
    super.key,
    required this.IconPath,
    required this.IconName,
  });

  @override
  Widget build(BuildContext context) {
    return Tab(
      height: 80,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.asset(
              IconPath,
              height: 30,
              width: 30,
            ),
          ),
          Text(
            IconName,
            style: TextStyle(fontSize: 10),
          )
        ],
      ),
    );
  }
}
