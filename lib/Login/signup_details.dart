import 'dart:convert';

import 'package:afterschool/Homescreen/home.dart';
import 'package:afterschool/Login/loginpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../Models/global_vals.dart';
import '../Models/student_auth.dart';


class SignupDetails extends StatefulWidget {
  final String name;
  final String number;
  final String pass;
  final String referralCode;
  const  SignupDetails(this.name, this.number, this.pass, this.referralCode, {Key? key}) : super(key: key);

  @override
  State<SignupDetails> createState() => _SignupDetailsState();
}

class _SignupDetailsState extends State<SignupDetails> {

  TextEditingController emailAddress = TextEditingController();
  int selectedValue = 1;
  var course_choices = ['IIT-JEE','NEET','Others'];
  var currentSelected = 'IIT-JEE';
  bool isSelected = false;
  bool snackbarAction = true;
  var client = http.Client();
  var baseUrl = 'https://afterschoolcareer.com:8080';

  void onCompleteSignup() async {
    final String email = emailAddress.text;
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('type', selectedValue.toString());
    var responseStatus = await StudentAuth.post(widget.name, widget.number,
        widget.pass, email, selectedValue.toString());
    if(responseStatus == 201) {
      sharedPreferences.setBool('number', true);
      sharedPreferences.setString('phone_number', widget.number);
      goToHome();
    } else if(responseStatus == 200) {
      _showToast(context, 'Phone number already exists. Please login to continue');
    } else {
      snackbarAction = false;
      _showToast(context, 'Invalid email entered');
    }
  }

  void _showToast(BuildContext context, String msg) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(msg),
        action: snackbarAction ? SnackBarAction(label: 'Login Here', onPressed: goToLogin) : null,
      ),
    );
  }

  void goToHome() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Homescreen()));
  }

  void goToLogin() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    return Scaffold(
        backgroundColor: const Color(0xff6633ff),
        body: ListView(children: [
          Container(
            padding: EdgeInsets.only(
                top: height / 15, left: width / 10, right: width / 10),
            child: Column(
              children: const [
                Text(
                  "Please enter the following additional details so that we can know more about you.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
            height: 660,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Column(
              children: [
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
                const Text(
                  "I'm a :",
                  style: TextStyle(
                    color: Color(0xff6633ff),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.only(left: width/10),
                  child: Column(
                    children: [
                      RadioListTile(
                        activeColor: const Color(0xff6633ff),
                        value: 1,
                        groupValue: selectedValue,
                        title: const Text('10th Passout'),
                        onChanged: (value) => setState(() => selectedValue = 1),
                      ),
                      RadioListTile(
                        activeColor: const Color(0xff6633ff),
                        value: 2,
                        groupValue: selectedValue,
                        title: const Text('11th Passout'),
                        onChanged: (value) => setState(() => selectedValue = 2),
                      ),
                      RadioListTile(
                        activeColor: const Color(0xff6633ff),
                        value: 3,
                        groupValue: selectedValue,
                        title: const Text('12th Passout'),
                        onChanged: (value) => setState(() => selectedValue = 3),
                      ),
                      RadioListTile(
                        activeColor: const Color(0xff6633ff),
                        value: 4,
                        groupValue: selectedValue,
                        title: const Text('12th Passout'),
                        subtitle: const Text('Drop Out - Repeating'),
                        onChanged: (value) => setState(() => selectedValue = 4),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                const Text(
                  "I'm looking for :",
                  style: TextStyle(
                    color: Color(0xff6633ff),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  icon: const Icon(
                    Icons.arrow_drop_down_circle,
                    color: Color(0xff6633ff),
                  ),
                    dropdownColor: Colors.white,
                    items: course_choices.map((String choice) {
                      return DropdownMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                      );
                    }).toList(),
                    value: currentSelected,
                    onChanged: (selectedValueNew) {
                      setState(() => currentSelected = selectedValueNew as String);
                    },
                  decoration: const InputDecoration(
                    labelText: "Select Course",
                    labelStyle: TextStyle(
                      color: Color(0xff6633ff),
                    ),
                    prefixIcon: Icon(
                      Icons.book,
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
                  ),
                ),
                const SizedBox(height: 30),
                InkWell(
                  onTap: onCompleteSignup,
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

              ],
            ),
          )

        ]));
  }
}
