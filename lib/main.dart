import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:afterschool/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:otpless_flutter/otpless_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';
import 'Login/finish_signup_whatsapp.dart';
import 'package:http/http.dart' as http;

void main() async {
  HttpOverrides.global = MyHttpOverrides();

  WidgetsFlutterBinding.ensureInitialized();
  ByteData data = await PlatformAssetBundle().load('assets/ca/lets-encrypt-r3.pem');
  SecurityContext.defaultContext.setTrustedCertificatesBytes(data.buffer.asUint8List());

  runApp(const MyApp());
}
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {

  @override
  void initState() {
    initPlatformState();
    super.initState();
  }

  final _otplessFlutterPlugin = Otpless();
  String _waId = 'Unknown';
  static String tokenVal = "Unknown";

  void initPlatformState() async {
    log("listening token");
    _otplessFlutterPlugin.authStream.listen((token) {
      setState(() {
        log("$token");
        _waId = token ?? "Unknown";
        log("_waID: $_waId");
          tokenVal = _waId;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title : 'AfterSchool',
        home: UpgradeAlert(
          child: const SplashScreen(),
        ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}
