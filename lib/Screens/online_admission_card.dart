import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'coaching_screen.dart';

class OnlineAdmissionCard extends StatefulWidget {
  final String logo;
  final String name;
  final String location;
  final int id;
  const OnlineAdmissionCard({Key? key, required this.logo, required this.name,
  required this.location, required this.id}) : super(key: key);

  @override
  State<OnlineAdmissionCard> createState() => _OnlineAdmissionCardState();
}

class _OnlineAdmissionCardState extends State<OnlineAdmissionCard> {

  var baseUrl = 'https://afterschoolcareer.com:8080';
  var client = http.Client();

  void onViewDetailsTapped() {
    goToCoachingScreen(widget.id);
  }

  void goToCoachingScreen(int id) {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>  CoachingScreen(id: id, coachingName: widget.name))
    );
  }

  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
      height: 180,
      child: Container(
        padding: const EdgeInsets.only(top:20, left:10, right: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                  color: Color(0xff9999ff),
                  spreadRadius: 3,
                  blurRadius: 10,
                  offset: Offset(0, 0)
              )
            ]
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: width/3,
                  height: 80,
                  child: Image.network(widget.logo)
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      widget.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                      widget.location,
                    style: const TextStyle(
                      fontSize: 16
                    ),
                  ),
                ],
              )
            ],
          ),
            InkWell(
              onTap: onViewDetailsTapped,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  color: Color(0xff6633ff),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                width: width/1.5,
                child: const Text(
                    "View Details",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            )
        ]
        )
      ),
    );
  }
}
