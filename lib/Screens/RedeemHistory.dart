import 'dart:convert';

import 'package:afterschool/Homescreen/home.dart';
import 'package:afterschool/Login/signup_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class RedeemHistory extends StatefulWidget {
  const RedeemHistory({Key? key}) : super(key: key);

  @override
  State<RedeemHistory> createState() => _RedeemHistoryState();
}

class _RedeemHistoryState extends State<RedeemHistory> {
  bool obscure = true;
  TextEditingController loginNum = TextEditingController();
  TextEditingController loginPass = TextEditingController();
  static var client = http.Client();
  static String baseUrl = 'https://afterschoolcareer.com:8080/';
  late SharedPreferences sharedPreferences;
  var phone_number;

  void  loadPhoneNumber() async {
    sharedPreferences = await SharedPreferences.getInstance();
    phone_number = sharedPreferences.getString("phone_number");
  }

  void loadNoOftoppertalksCoupon() async {
    loadPhoneNumber();
    int no_of_coupons=0;
    var uri = Uri.parse(
        '$baseUrl/nooftoppertalks/?phone_number=$phone_number');
    showLoadingIndictor();
    var response = await client.get(uri);
    removeLoadingIndicator();
    Map data = json.decode(response.body);
    no_of_coupons = data["data"];
  }

  void loadNoOfCounsellortalksCoupon() async {
    loadPhoneNumber();
    int no_of_coupons=0;
    var uri = Uri.parse(
        '$baseUrl/noofcounsellertalks/?phone_number=$phone_number');
    showLoadingIndictor();
    var response = await client.get(uri);
    removeLoadingIndicator();
    Map data = json.decode(response.body);
    no_of_coupons = data["data"];
  }

  void showLoadingIndictor(){
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const Center(
              child:CircularProgressIndicator(),
            )
        )
    );
  }

  void removeLoadingIndicator(){
    Navigator.pop(context);
  }



  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Edit Profile"),
          backgroundColor: const Color(0xff6633ff),
        ),
        body: ListView(
          children: [

            const SizedBox(height:50),
            const TextField(

              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.person,
                  color: Colors.white,
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
            const SizedBox(height:10),
            const TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.person,
                  color: Colors.white,
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
                hintText: " Enter Email",
              ),
            ),
            const SizedBox(height:10),
            const TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.person,
                  color: Colors.white,
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
                hintText: "Phone number",
              ),
            ),
            const SizedBox(height:10),
            const TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.person,
                  color: Colors.white,
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
                hintText: "Location",
              ),
            ),
          ],
        ));
  }
}
