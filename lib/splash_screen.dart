import 'dart:async';

import 'package:afterschool/Homescreen/home.dart';
import 'package:afterschool/Login/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkRoute();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/logo_img.png"),
          ),
        )
      ),
    ));
  }

  void checkRoute() async{
    var sharedPreferences = await SharedPreferences.getInstance();
    var isLoggedIn = sharedPreferences.getBool('number');
    Timer(const Duration(seconds: 2), () {
      if(isLoggedIn != null) {
        if(isLoggedIn) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder:  (context) => const Homescreen(),
              ));
        } else {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder:  (context) => const LoginPage(),
              ));
        }
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder:  (context) => const LoginPage(),
            ));
      }
    });
  }
}

