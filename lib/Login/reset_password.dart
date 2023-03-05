import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'forgot_password.dart';
import 'loginpage.dart';

class ResetPassword extends StatefulWidget {
  final String phoneNum;
  final String otpSent;
  const ResetPassword(this.phoneNum, this.otpSent, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {

  TextEditingController otpEntered = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController passRe = TextEditingController();

  static var client = http.Client();
  static String baseUrl = 'https://afterschoolcareer.com:8080/resetPassword/';

  bool snackbarAction = true;
  bool obscure = true;


  void resetPassword() async {
    if(widget.otpSent != otpEntered.text) {
      _showToast(context, "Wrong OTP entered.");
      return;
    }
    if(pass.text != passRe.text) {
      _showToast(context, "Please retype the same password.");
      return;
    }
    var responseCode = await resetPassAPI(widget.phoneNum, pass.text);
    if(responseCode == 200) {
      snackbarAction = false;
      _showToast(context, "Please login here.");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const LoginPage()));
    }
  }

  void _showToast(BuildContext context, String msg) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(msg),
        action: snackbarAction? SnackBarAction(label: 'Reset Password', onPressed: goToResetPass): SnackBarAction(label: 'Login here', onPressed: goToLogin),
      ),
    );
  }

  void goToResetPass() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => ResetPassword(widget.phoneNum, widget.otpSent)));
  }

  void goToLogin() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  static Future<dynamic> resetPassAPI(String phoneNumber, String password) async {
    Map<String,String> studentData = {
      "phone_number" : phoneNumber,
      "password" : password
    } ;
    var uri = Uri.parse(baseUrl);
    var response = await client.post(uri, body: studentData);
    return response.statusCode;
  }

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Reset Password';
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
              controller: otpEntered,
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
                hintText: "Enter OTP Sent on Email",
              ),
            ),
          ),
            Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextField(
              controller: pass,
              obscureText: obscure,
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.lock,
                  color: Color(0xff6633ff),
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      obscure = !obscure;
                    });
                  },
                  icon: Icon(
                    obscure
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: obscure
                        ? Colors.grey
                        : const Color(0xff6633ff),
                  ),
                ),
                enabledBorder:
                const OutlineInputBorder(
                  borderSide:
                  BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.all(
                      Radius.circular(20.0)),
                ),
                focusedBorder:
                const OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Color(0xff6633ff)),
                  borderRadius: BorderRadius.all(
                      Radius.circular(20.0)),
                ),
                hintText: "Enter your Password",
              ),
            ),
          ),
           Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextField(
              controller: passRe,
              obscureText: obscure,
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.lock,
                  color: Color(0xff6633ff),
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      obscure = !obscure;
                    });
                  },
                  icon: Icon(
                    obscure
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: obscure
                        ? Colors.grey
                        : const Color(0xff6633ff),
                  ),
                ),
                enabledBorder:
                const OutlineInputBorder(
                  borderSide:
                  BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.all(
                      Radius.circular(20.0)),
                ),
                focusedBorder:
                const OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Color(0xff6633ff)),
                  borderRadius: BorderRadius.all(
                      Radius.circular(20.0)),
                ),
                hintText: "Re-enter New Password",
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextButton(
                  onPressed: resetPassword,
                  child: const Text('Reset Password')
              )
          ),
        ],
      ),
    );
  }
}