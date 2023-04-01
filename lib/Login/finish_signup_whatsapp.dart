import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Homescreen/home.dart';
import '../Models/student_auth.dart';

class FinishSignUpWithWhatsapp extends StatefulWidget {
  final String name;
  final String number;
  const FinishSignUpWithWhatsapp({Key? key, required this.name, required this. number}) : super(key: key);

  @override
  State<FinishSignUpWithWhatsapp> createState() => _FinishSignUpWithWhatsappState();
}

class _FinishSignUpWithWhatsappState extends State<FinishSignUpWithWhatsapp> {

  String phoneNumber = "";

  @override
  void initState() {
    name.text = widget.name;
    for(int i=2;i<widget.number.length;i++) {
      phoneNumber+=widget.number[i];
    }
    super.initState();
  }

  bool obscure = true;

  final int EMPTY_FIELD = 1;
  final int INVALID_NUMBER = 2;
  final int INVALID_PASSWORD = 3;

  int selectedValue = 1;
  bool snackbarAction = true;

  var client = http.Client();
  var baseUrl = 'https://afterschoolcareer.com:8080';

  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController referral = TextEditingController();

  void onCompleteSignup() async {
    final String pass = password.text;
    final String studentName = name.text;
    final String referralCode = referral.text;
    final String emailAddress = email.text;
    if(pass.length <8) {
      showErrorDialog(3);
      return;
    }
    log(phoneNumber);
    showLoadingDialog("Registering User");
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('type', selectedValue.toString());
    var responseStatus = await StudentAuth.post(studentName, phoneNumber,
        pass, emailAddress, selectedValue.toString());
    log(responseStatus.toString());
    if(responseStatus == 201) {
      if(referralCode.isNotEmpty) {
        redeemReferralCode(referralCode);
      }
      sharedPreferences.setBool('number', true);
      sharedPreferences.setString('phone_number', widget.number);
      removeLoadingDialog();
      goToHome();
    } else {
      removeLoadingDialog();
    }

  }

  void redeemReferralCode(String code) async {
    var uri = Uri.parse('$baseUrl/usereferralcode/?phone_number=${widget.number}&referral_code=$code');
    var response = await client.get(uri);
    Map data = json.decode(response.body);
    if(data["data"] == 'failed') {
      _showToast(context, "Invalid Referral Code has been entered");
    }
  }


  void goToHome() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Homescreen()));
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

  void _showToast(BuildContext context, String msg) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        backgroundColor: Colors.grey[300],
        content: Text(
          msg,
          style: const TextStyle(
              color: Colors.black
          ),
        ),
      ),
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

  Future<dynamic> openInfoForName() {
    String msg = "Please use your Original Name here. This will be used to communicate your data with Institutes when needed.";
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return  AlertDialog(
            title: const Text("Important"),
            content: Text(msg),
            actions: [
              TextButton(
                  onPressed: () { Navigator.pop(context); },
                  child: const Text(
                    "OK",
                    style: TextStyle(
                        color: Color(0xff6633ff)
                    ),
                  )),
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff6633ff),
        title: const Text("Sign Up - Student Details"),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextField(
                  controller: name,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.person,
                      color: Color(0xff6633ff),
                    ),
                    suffixIcon: IconButton(
                      onPressed: openInfoForName,
                      icon: const Icon(
                          Icons.info,
                          color: Color(0xff6633ff)
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
                    hintText: "Enter your Full Name",
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: email,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.lock,
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
                    hintText: "Enter your Email",
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: password,
                  obscureText: obscure,
                  decoration:  InputDecoration(
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
                TextField(
                  controller: referral,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.card_membership,
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
                      hintText: "Enter Referral Code if any"
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
          ),
        ],
      ),
    );
  }
}
