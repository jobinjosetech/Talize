import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class DashBoard extends StatelessWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFF171717),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: AnimatedTextKit(
            totalRepeatCount: 1,
            animatedTexts: [
              WavyAnimatedText(
                'DashBoard',
                textStyle: TextStyle(
                  fontSize: 45,
                  fontFamily: 'poppins',
                  fontWeight: FontWeight.w800,
                  color: Color(0XFF346751),
                ),
              ),
            ],
            isRepeatingAnimation: true,
          ),
        ),
      ),
    );
  }
}
