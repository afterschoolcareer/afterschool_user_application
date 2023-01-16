import 'package:afterschool/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  static Future init() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  }
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title : 'AfterSchool',
        home: SplashScreen(),
    );
  }
}
