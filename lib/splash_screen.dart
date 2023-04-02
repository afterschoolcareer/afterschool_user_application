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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 300,
            height: 300,
            decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/logo_img.png"),
            ),
          )
        ),
            const CircularProgressIndicator(
              color: Color(0xff6633ff),
            )
    ]
    ),
      ));
  }

  void checkRoute() async{
    var sharedPreferences = await SharedPreferences.getInstance();
    var isLoggedIn = sharedPreferences.getBool('number');
    Timer(const Duration(seconds: 1), () {
      if(isLoggedIn != null) {
        if(isLoggedIn) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder:  (context) =>  Homescreen(),
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

