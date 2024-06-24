import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_vendor_side/screens/login_screen.dart';
import 'package:grocery_vendor_side/screens/product_screen.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  static const String id = "splash-screen";

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () {
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user == null) {
          Get.offNamed(LoginScreen.id);
        } else {
          Get.offNamed(ProductScreen.id);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: size.height / 1.5,
              width: size.width / 1.1,
              child: Column(
                children: [
                  Lottie.asset("assets/lottie/splash.json"),

                  AnimatedTextKit(
                    animatedTexts: [
                      FadeAnimatedText(
                        textStyle: TextStyle(fontSize: 35,color: Colors.green),
                        "Grocify Business",
                        duration: Duration(seconds: 5)
                      ),
                    ],
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
