import 'dart:convert';
import 'dart:developer';
import 'package:afterschool/Login/signup_details_manual.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'loginpage.dart';

class EmailVerificationScreen extends StatefulWidget {
  const  EmailVerificationScreen({Key? key}) : super(key: key);

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool showSendButton = true;
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController emailAddress = TextEditingController();

  var client = http.Client();
  var baseUrl = 'https://afterschoolcareer.com:8080';

  final int EMPTY_FIELD = 1;
  final int INVALID_NUMBER = 2;
  final int INVALID_PASSWORD = 3;

  String otp = "";

  TextEditingController d1 = TextEditingController();
  TextEditingController d2 = TextEditingController();
  TextEditingController d3 = TextEditingController();
  TextEditingController d4 = TextEditingController();

  void sendOtp()  {
    if(phoneNumber.text == "0000") goToSignUpDetails();
    verifyPhone();
  }

  void verifyPhone() async {
    String email = emailAddress.text;
    String number = phoneNumber.text;
    if(number.isEmpty || email.isEmpty) {
      showErrorDialog(1);
      return;
    }
    if(number.length!=10 || int.tryParse(number) == null) {
      showErrorDialog(2);
      return;
    }
    showLoadingDialog("Verifying Number");
    var uri = Uri.parse('$baseUrl/is_registered/?phone_number=$number');
    var response = await client.get(uri);
    Map data = json.decode(response.body);
    String status = data["data"];
    if(status == 'yes') {
      removeLoadingDialog();
      showNumberError("This number is already registered with AfterSchool. Please login to continue");
      return;
    } else {
      removeLoadingDialog();
      sendOtpOnEmail();
    }
  }

  void sendOtpOnEmail() async {
    showLoadingDialog("Sending OTP");
    String email = emailAddress.text;
    var uri = Uri.parse('$baseUrl/verifyOtp/?email=$email');
    var response = await client.get(uri);
    if(response.statusCode != 200) {
      removeLoadingDialog();
      showNumberError("The Email you have entered is invalid");
      return;
    }
    removeLoadingDialog();
    Map data = json.decode(response.body);
    setState(() {
      showSendButton = false;
      otp = data["data"];
      log(otp);
    });
  }

  void confirmOtp() {
    String userOtp = "${d1.text}${d2.text}${d3.text}${d4.text}";
    log(userOtp);
    if(userOtp == otp) {
      goToSignUpDetails();
    } else {
      showWrongOtp();
    }
  }

  void goToSignUpDetails() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) =>
            SignupDetailsManual(number: phoneNumber.text, email: emailAddress.text))
    );
  }

  Future<dynamic> showLoadingDialog(String msg) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return  AlertDialog(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:  [
                  const CircularProgressIndicator(
                    color: Color(0xff6633ff),
                  ),
                  Text(msg),
                ],
              )
          );
        }
    );
  }

  void removeLoadingDialog() {
    Navigator.pop(context);
  }

  void goToLogin() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  Future<dynamic> showNumberError(String msg) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return  AlertDialog(
            title: const Text("Error"),
            content: Text(msg),
            actions: [
              TextButton(
                  onPressed: goToLogin,
                  child: const Text(
                    "Go To Login",
                    style: TextStyle(
                      color: Color(0xff6633ff),
                    ),
                  )
              )
            ],
          );
        }
    );
  }

  Future<dynamic> showWrongOtp() {
    String msg = "The OTP that you have entered is not correct. Please check your email.";
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return  AlertDialog(
            title: const Text("Incorrect"),
            content: Text(msg),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "OK",
                    style: TextStyle(
                      color: Color(0xff6633ff),
                    ),
                  )
              )
            ],
          );
        }
    );
  }

  Future<dynamic> showErrorDialog(int i) {
    String msg = "";
    if(i == EMPTY_FIELD) {
      msg = "One or more fields are left blank. Please fill in the correct credentials.";
    }
    if(i == INVALID_NUMBER) {
      msg = "You are trying to enter an invalid number. Please check your number and try again.";
    }
    if(i == INVALID_PASSWORD) {
      msg = "Your password should be atleast 8 characters.";
    }
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return  AlertDialog(
            title: const Text("Invalid Credentials"),
            content: Text(msg),
            actions: [
              TextButton(
                  onPressed: () { Navigator.pop(context); },
                  child: const Text(
                    "OK",
                    style: TextStyle(
                        color: Color(0xff6633ff)
                    ),
                  ))
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff6633ff),
        title: const Text("Verify your Email"),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.only(left:30, right: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: phoneNumber,
              decoration: const InputDecoration(
                prefixIcon: Icon(
                  Icons.phone_android_rounded,
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
                hintText: "Enter your Phone Number",
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: emailAddress,
              decoration: const InputDecoration(
                prefixIcon: Icon(
                  Icons.email,
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
                hintText: "Enter your Email Address",
              ),
            ),
            const SizedBox(height: 40),
            if(showSendButton) ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        )
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(const Color(0xff6633ff))
                ),
                onPressed: sendOtp,
                child: const Text("Send OTP",
                style: TextStyle(
                  color: Colors.white
                ),)
            ) else Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("Enter the OTP received on your Email :",
                style: TextStyle(
                  color: Color(0xff6633ff),
                  fontSize: 15
                ),),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 68,
                    width: 64,
                    child: TextFormField(
                      controller: d1,
                      cursorColor: const Color(0xff6633ff),
                      decoration: const InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(color: Color(0xff6633ff))
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(color: Colors.grey)
                        )
                      ),
                      onChanged: (value) {
                        if(value.length == 1) {
                          FocusScope.of(context).nextFocus();
                        }
                      },
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 68,
                    width: 64,
                    child: TextFormField(
                      cursorColor: const Color(0xff6633ff),
                      decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(color: Color(0xff6633ff))
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(color: Colors.grey)
                          )
                      ),
                      onChanged: (value) {
                        if(value.length == 1) {
                          FocusScope.of(context).nextFocus();
                        }
                      },
                      controller: d2,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 68,
                    width: 64,
                    child: TextFormField(
                      cursorColor: const Color(0xff6633ff),
                      decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(color: Color(0xff6633ff))
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(color: Colors.grey)
                          )
                      ),
                      onChanged: (value) {
                        if(value.length == 1) {
                          FocusScope.of(context).nextFocus();
                        }
                      },
                      controller: d3,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 68,
                    width: 64,
                    child: TextFormField(
                      cursorColor: const Color(0xff6633ff),
                      decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(color: Color(0xff6633ff))
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(color: Colors.grey)
                          )
                      ),
                      onChanged: (value) {
                        if(value.length == 1) {
                          FocusScope.of(context).nextFocus();
                        }
                      },
                     controller: d4,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly
                      ],
                    ),
                  )
                ],
              ),
                const SizedBox(height: 20),
                ElevatedButton(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            )
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(const Color(0xff6633ff))
                    ),
                    onPressed: confirmOtp,
                    child: const Text("Confirm",
                      style: TextStyle(
                          color: Colors.white
                      ),)
                )
    ]
            )
          ],
        ),
      ),
    );
  }
}
