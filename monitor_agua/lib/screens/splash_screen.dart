import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import './login_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        children: [
          Center(
            child: Lottie.asset(
              "assets/animations/loadinganimation.json",
            ),
          ),
        ],
      ),
      nextScreen: const LoginScreen(), 
      splashIconSize: 400, 
      backgroundColor: Colors.black, 
      duration: 3000, 
    );
  }
}