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
    String phoneNumber = phoneNum.text;
    if(phoneNumber.isEmpty || phoneNumber.length != 10) {
      _showToast(context, 'Invalid input. Please check the number.');
      return;
    }
    Map<String,String> studentData = {
      "phone_number" : phoneNumber,
      "password" : ""
    } ;
    showLoadingDialog();
    var uri = Uri.parse(baseUrl);
    var response = await client.post(uri, body: studentData);
    if(response.statusCode != 201) {
      removeLoadingDialog();
      _showToast(context, 'Please Enter Registered Phone Number only.');
      return;
    }
    final json = jsonDecode(response.body);
    String otp = json['otp'];
    removeLoadingDialog();
    goToReset(phoneNumber, otp);
  }

  Future<dynamic> showLoadingDialog() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return  AlertDialog(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  CircularProgressIndicator(
                    color: Color(0xff6633ff),
                  ),
                  Text("Verifying User"),
                ],
              )
          );
        }
    );
  }

  void removeLoadingDialog() {
    Navigator.pop(context);
  }

  void goToReset(String phoneNumber, String otp) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => ResetPassword(phoneNumber, otp)));
  }

  void _showToast(BuildContext context, String msg) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(
            msg,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Forgot Password';
    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle),
        centerTitle: true,
        backgroundColor: const Color(0xff6633ff),
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: ListView(
          children: [
            Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 20),
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: const Text(
                      "Please enter the mobile number which you have used earlier to register with AfterSchool. We will verify the number and send One Time Password (OTP) to the email id registered with your account.",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        color: Color(0xff6633ff),
                        fontSize: 15
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children : [
                  MaterialButton(
                    color: const Color(0xff6633ff),
                    onPressed: onForgotPasswordButtonTap,
                    child: const Text(
                      "Proceed with Reset",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ]
              )
            ],
          ),
        ]
        ),
      ),
    );
  }
}