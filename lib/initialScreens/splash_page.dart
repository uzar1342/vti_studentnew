import 'dart:async';

import 'package:animated_splash_screen/animated_splash_screen.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vti_student/configs/globals.dart';
import 'package:vti_student/configs/shared_prefs_keys.dart';
import 'package:vti_student/home/dash_page.dart';

import 'package:vti_student/initialScreens/on_boarding_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool isUserLoggedIn = false;

  fetchUserLoginStatus() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      isUserLoggedIn = _prefs.getBool(userLoginStatusKey) ?? false;
      userEmail = _prefs.getString(userEmailKey) ?? '';
      userPhone = _prefs.getString(userPhoneKey) ?? '';
      userId = _prefs.getString(userIdKey) ?? '';
      userFirstName = _prefs.getString(userFirstNameKey) ?? '';
    });

    if (isUserLoggedIn) {
      Timer(
          Duration(seconds: 2),
          () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const DashPage()),
              (route) => false));
    } else {
      print("HERE");
      Timer(
          Duration(seconds: 2),
          () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const OnBoardingPage()),
              (route) => false));
    }
  }

  @override
  void initState() {
    fetchUserLoginStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                "assets/images/temp_doodle.jpg",
              ),
              fit: BoxFit.fitHeight),
        ),
        child: Center(
          child: Image.asset(
            "assets/images/logo_png.png",
            height: 300,
            width: 300,
          ),
        ),
      ),
    );
  }
}
