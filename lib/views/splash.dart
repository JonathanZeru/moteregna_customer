import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatelessWidget {
  final String animationPath;
  final int duration;

  const SplashScreen({required this.animationPath, required this.duration, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: Center(
        child: Lottie.asset(animationPath, fit: BoxFit.cover),
      ),
    );
  }
}
