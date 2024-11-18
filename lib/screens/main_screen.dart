import 'package:demo/screens/screen1.dart';
import 'package:demo/screens/screen2.dart';
import 'package:demo/screens/screen3.dart';
import 'package:demo/screens/welcome.dart';

import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Mainscreen extends StatefulWidget {
  const Mainscreen({super.key});

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  PageController pageController = PageController();
  String buttonText = "Skip";
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            PageView(
              controller: pageController,
              onPageChanged: (index) {
                currentPageIndex = index;
                if (index == 2) {
                  buttonText = "Finish";
                } else {
                  buttonText = "Skip";
                }
                setState(() {});
              },
              children: const [
                Screen1(),
                Screen2(),
                Screen3(),
              ],
            ),
            Container(
              alignment: const Alignment(0, 0.8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return const Welcome();
                            },
                          ),
                        );
                      },
                      child: Text(
                        buttonText,
                        style: const TextStyle(color: Colors.white),
                      )),
                  SmoothPageIndicator(controller: pageController, count: 3),
                  currentPageIndex == 2
                      ? const SizedBox(width: 10)
                      : GestureDetector(
                          onTap: () {
                            pageController.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeIn);
                          },
                          child: const Text(
                            "Next",
                            style: TextStyle(color: Colors.white),
                          )),
                ],
              ),
            ),
          ],
        ));
  }
}
