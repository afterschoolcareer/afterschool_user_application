import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../profile.dart';
import 'drawer.dart';
import 'loan_credentials.dart' as loanCredentials;
import 'package:http/http.dart' as http;

class LoanScreen extends StatefulWidget {
  const LoanScreen({Key? key}) : super(key: key);

  @override
  State<LoanScreen> createState() => _LoanScreenState();
}

class _LoanScreenState extends State<LoanScreen> {

  var baseUrl = 'https://staging.propelld.com/v1';
  var client = http.Client();

  /* managing appbar and drawer */
  void onProfileIconTapped() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const ProfilePage()));
  }
  /* to launch a drawer on button tap */
  final GlobalKey<ScaffoldState> _scaffoldDrawer = GlobalKey<ScaffoldState>();

  void tryApi() async {
    String email = "shubhamvats830@gmail.com";
    String mobile = "8375957165";
    int courseId = 1262;
    String firstName = "Shubham";
    String lastName = "Vats";
    int fees = 250000;

    Map<String,dynamic> studentData = {
      "Email" : email,
      "Mobile" : mobile,
      "CourseId" : courseId,
      "FirstName" : firstName,
      "LastName" : lastName,
      "DiscountedCourseFee" : fees
    };


    var uri = Uri.parse('$baseUrl/product/apply/generic');
    var response = await client.post(uri,
    headers: {
      "client-id" : loanCredentials.clientId,
      "client-secret" : loanCredentials.clientSecretId,
      "Content-Type" : "application/json"
    },
    body: json.encode(studentData));

    Map data;
    data = json.decode(response.body);
    print(response.statusCode);
    print(data);
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      key: _scaffoldDrawer,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Avail Loan",

          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w400
          ),
        ),
        leading: Builder(
          builder: (BuildContext) {
            return Transform.scale(
              scale: 1.1,
              child: IconButton(
                  onPressed: () {
                    _scaffoldDrawer.currentState?.openDrawer();
                  },
                  icon: const Icon(
                    Icons.menu,
                    color: Colors.black,
                  )),
            );
          },
        ),
        actions: [
          Row(
            children: [
              InkWell(
                onTap: onProfileIconTapped,
                child: Transform.scale(
                  scale: 1.2,
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        image: const DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage("images/profile_icon.png"))),
                  ),
                ),
              ),
              const SizedBox(width: 25)
            ],
          )
        ],
      ),
      drawer: const AppBarDrawer(),
      backgroundColor: Colors.white,
      body:  Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Propelled Screen"),
              TextButton(
                  onPressed: tryApi,
                  child: Text("FUCK ME"))
            ]
        ),
      ),
    );
  }
}