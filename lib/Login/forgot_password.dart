import 'dart:convert';

import 'package:flutter/material.dart';
import 'loginpage.dart';
import 'reset_password.dart';
import 'package:http/http.dart' as http;
import 'dart:ui';
import 'package:flutter/cupertino.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ForgotPasswordState();

}

class _ForgotPasswordState extends State<ForgotPassword> {

  TextEditingController phoneNum = TextEditingController();
  static var client = http.Client();
  static String baseUrl = 'https://afterschoolcareer.com:8080/resetPassword/';

  void onForgotPasswordButtonTap() async {
    String phone = phoneNum.text;
    var otp = await sendOTP(phone);
    // if(response[0] != 201) {
    //   _showToast(context, 'Please Enter Registered Phone Number');
    //   Navigator.pushReplacement(
    //       context, MaterialPageRoute(builder: (context) => const LoginPage()));
    // }
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => ResetPassword(phone, otp)));
  }

  Future<dynamic> sendOTP(String phoneNumber) async {
    Map<String,String> studentData = {
      "phone_number" : phoneNumber,
      "password" : ""
    } ;
    var uri = Uri.parse(baseUrl);
    var response = await client.post(uri, body: studentData);
    if(response.statusCode != 201) {
      _showToast(context, 'Please Enter Registered Phone Number');
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const LoginPage()));
    }
    final json = jsonDecode(response.body);
    String otp = json['otp'];
    return otp;
  }

  void goToForgetPass() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const ForgotPassword()));
  }

  void _showToast(BuildContext context, String msg) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(msg),
        action: SnackBarAction(label: 'Reset Password', onPressed: goToForgetPass),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Your Account';
    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle),
        centerTitle: true,
        backgroundColor: const Color(0xff6633ff),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
           Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextField(
              controller: phoneNum,
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.phone_android_outlined,
                    color: Color(0xff6633ff),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.all(
                        Radius.circular(20.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color(0xff6633ff)),
                    borderRadius: BorderRadius.all(
                        Radius.circular(20.0)),
                  ),
                  hintText: "Enter Phone Number",
                ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextButton(
                  onPressed: onForgotPasswordButtonTap,
                  child: const Text('Search')
              )
          ),
        ],
      ),
    );
  }
}