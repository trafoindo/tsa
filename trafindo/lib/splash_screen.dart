import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trafindo/screen/location_options_screen.dart';
import 'package:trafindo/screen/walkthrough_screen.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String loadingText = "";

  @override
  void initState() {
    super.initState();
    animateLoadingText();
    Timer(
      const Duration(seconds: 7),
      () => checkUserLoginStatus(),
    );
  }

  void animateLoadingText() {
    const loadingPhrase = "Services...";
    const delayBetweenLetters = Duration(milliseconds: 500);

    for (int i = 0; i < loadingPhrase.length; i++) {
      Future.delayed(
        delayBetweenLetters * i,
        () {
          setState(() {
            loadingText = loadingPhrase.substring(0, i + 1);
          });
        },
      );
    }
  }

  void checkUserLoginStatus() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Navigator.pushReplacement(
        context,
        // MaterialPageRoute(builder: (context) => const BottomBar(index: 0)),
        MaterialPageRoute(builder: (context) => const LocationOptionsScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WalkThroughScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/image/background.jpg'), // Change to your image path
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 80,
                child: Image.asset(
                  'assets/image/logo_tpp.png',
                  fit: BoxFit.cover,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    loadingText,
                    style: GoogleFonts.lobster(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}