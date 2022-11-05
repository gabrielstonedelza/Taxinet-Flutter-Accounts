import 'dart:async';
import 'package:get/get.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:taxinet_accounts/homepage.dart';
import 'package:lottie/lottie.dart';
import 'constants/app_colors.dart';
import 'login.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final storage = GetStorage();
  late String username = "";
  late String token = "";
  late String userType = "";
  bool hasToken = false;
  bool hasViewedIntro = false;
  @override
  void initState() {
    super.initState();
    if (storage.read("username") != null && storage.read("userToken") != null) {
      username = storage.read("username");
      setState(() {
        hasToken = true;
      });
    }


    if (hasToken && storage.read("userType") == "Accounts") {
      Timer(const Duration(seconds: 10),
              () {
            Get.offAll(() => const HomePage());
          }
      );
    } else {
      Timer(const Duration(seconds:7),
              () => Get.offAll(() => const NewLogin()));
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/json/25227-accountant.json'),
          Center(
            child: SizedBox(
              width: 250,
              child: DefaultTextStyle(
                style: const TextStyle(
                    fontSize:40.0,
                    fontWeight: FontWeight.bold,
                    color: defaultTextColor2
                ),
                child: AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'Taxinet',
                      speed: const Duration(milliseconds:300),
                    ),
                    TypewriterAnimatedText(
                      'Accounts',
                      speed: const Duration(milliseconds: 300),
                    ),
                  ],

                  totalRepeatCount: 1,
                  pause: const Duration(milliseconds: 100),
                  displayFullTextOnTap: true,
                  stopPauseOnTap: true,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
