import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'coaching_screen.dart';

class MultipleLocationCard extends StatefulWidget {

  final String name;
  final String location;
  final String logo;
  final int id;
  const MultipleLocationCard({Key? key, required this.name, required this.location,
  required this.logo, required this.id}) : super(key: key);

  @override
  State<MultipleLocationCard> createState() => _MultipleLocationCardState();
}

class _MultipleLocationCardState extends State<MultipleLocationCard> {

  void onViewDetailsTapped() {
    goToCoachingScreen(widget.id);
  }

  void goToCoachingScreen(int id) {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>  CoachingScreen(id: id, coachingName: widget.name))
    );
  }

  @override
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
                    SizedBox(
                        width: width/3,
                        height: 80,
                        child: Image.network(widget.logo)
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: width * 0.4,
                          child: Text(
                            widget.name,
                            style: const TextStyle(
                                fontSize: 18
                            ),
                            textAlign: TextAlign.center,
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
