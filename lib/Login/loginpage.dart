import 'dart:convert';

import 'package:afterschool/Homescreen/home.dart';
import 'package:afterschool/Login/signup_details.dart';
import 'package:afterschool/Models/student_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool obscure = true;
  TextEditingController loginNum = TextEditingController();
  TextEditingController loginPass = TextEditingController();

  TextEditingController signupName = TextEditingController();
  TextEditingController signupNum = TextEditingController();
  TextEditingController signupPass = TextEditingController();

  void onLoginTap() async {
    String num = loginNum.text;
    String pass = loginPass.text;

    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var responseStatus = await StudentAuth.get(num,pass);
    if(responseStatus == 200) {
      sharedPreferences.setBool('number', true);
      goToHome();
    } else {
      _showToast(context, "Invalid Details. Check your credentials or Sign Up.");
    }
  }

  void _showToast(BuildContext context, String msg) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(msg),
        action: SnackBarAction(label: 'Login Here', onPressed: goToLogin),
      ),
    );
  }

  void goToHome() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Homescreen()));
  }

  void goToLogin() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  void onSignupTapped() {
    String phoneNumber = signupNum.text;
    String name = signupName.text;
    String pass = signupPass.text;
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => SignupDetails(name, phoneNumber, pass)));
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    return Scaffold(
        backgroundColor: const Color(0xff6633ff),
        body: ListView(
          children: [
            Container(
                padding: EdgeInsets.only(
                    left: width / 10, right: width / 10, top: height / 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Welcome To",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "AfterSchool",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              image: const DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage("images/logo_img.png"))),
                        )
                      ],
                    )
                  ],
                )),
            SizedBox(height: height / 15),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              height: 560,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: DefaultTabController(
                length: 2,
                child: Scaffold(
                    backgroundColor: Colors.white,
                    body: Column(
                      children: [
                        const TabBar(
                            labelColor: Color(0xff6633ff),
                            unselectedLabelColor: Colors.grey,
                            indicatorColor: Color(0xff6633ff),
                            tabs: [
                              Tab(
                                text: "Login",
                              ),
                              Tab(
                                text: "Sign Up",
                              )
                            ]),
                        Expanded(
                          child: TabBarView(
                            children: [
                              /* login tab*/
                              Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 70, horizontal: 30),
                                  child: Column(
                                    children: [
                                      TextField(
                                        controller: loginNum,
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
                                          hintText: "Enter your Phone Number",
                                        ),
                                      ),
                                      const SizedBox(height: 30),
                                      TextField(
                                        controller: loginPass,
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
                                      const SizedBox(height: 15),
                                      Container(
                                        margin:
                                            EdgeInsets.only(left: width / 3),
                                        child: RichText(
                                          text: TextSpan(children: [
                                            const TextSpan(
                                              text: "Forgot Password?",
                                              style: TextStyle(
                                                color: Color(0xff6633ff),
                                              ),
                                            ),
                                            TextSpan(
                                                text: " Tap Here.",
                                                style: const TextStyle(
                                                  color: Color(0xff6633ff),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () {
                                                        print(
                                                            "forgot password clicked");
                                                      }),
                                          ]),
                                        ),
                                      ),
                                      const SizedBox(height: 30),
                                      InkWell(
                                        onTap: onLoginTap,
                                        child: Container(
                                          height: 50,
                                          width: 150,
                                          decoration: BoxDecoration(
                                              color: const Color(0xff6633ff),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Colors.black45,
                                                  spreadRadius: 3,
                                                  blurRadius: 10,
                                                  offset: Offset(0, 6),
                                                )
                                              ]),
                                          child: const Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 30),
                                      RichText(
                                        text: TextSpan(children: [
                                          const TextSpan(
                                            text:
                                                "By Logging In or Signing Up, you agree to our ",
                                            style: TextStyle(
                                              color: Color(0xff6633ff),
                                            ),
                                          ),
                                          TextSpan(
                                              text: "privacy policy.",
                                              style: const TextStyle(
                                                color: Color(0xff6633ff),
                                                fontWeight: FontWeight.bold,
                                              ),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  print(
                                                      "privacy policy clicked");
                                                }),
                                        ]),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  )),
                              /* Sign Up tab*/
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 30, horizontal: 30),
                                child: Column(
                                  children: [
                                     TextField(
                                      controller: signupName,
                                      decoration: const InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.person,
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
                                        hintText: "Enter your Name",
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    TextField(
                                      controller: signupNum,
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
                                    const SizedBox(height: 10),
                                     TextField(
                                       controller: signupPass,
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
                                        enabledBorder: const OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.grey),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20.0)),
                                        ),
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xff6633ff)),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20.0)),
                                        ),
                                        hintText: "Enter your Password",
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Column(
                                      children: [
                                        InkWell(
                                          onTap: onSignupTapped,
                                          child: Container(
                                            height: 50,
                                            width: 150,
                                            decoration: BoxDecoration(
                                                color: const Color(0xff6633ff),
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: const Icon(
                                              Icons.arrow_forward_outlined,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        const Text(
                                          "OR Signup with",
                                          style: TextStyle(
                                            color: Color(0xff6633ff),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        InkWell(
                                          child: Container(
                                            height: 50,
                                            width: 150,
                                            decoration: BoxDecoration(
                                                color: Colors.green,
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: const [
                                                Icon(
                                                  Icons.whatsapp,
                                                  color: Colors.white,
                                                ),
                                                SizedBox(width: 5),
                                                Text(
                                                  "Whatsapp",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          onTap: () {
                                            print("whatsapp button tapped");
                                          },
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
              ),
            ),
          ],
        ));
  }
}
