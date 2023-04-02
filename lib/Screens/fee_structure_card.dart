import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'coaching_screen.dart';

class FeeStructureCard extends StatefulWidget {
  final String logo;
  final String name;
  final String location;
  final int id;
  final List feeType;
  final List fees;
  const FeeStructureCard({Key? key, required this.logo, required this.name,
  required this.location, required this.id,
  required this.feeType, required this.fees}) : super(key: key);

  @override
  State<FeeStructureCard> createState() => _FeeStructureCardState();
}

class _FeeStructureCardState extends State<FeeStructureCard> {

  bool is10thpassout = false;
  int val10thpassout = 0;
  bool is11thpassout = false;
  int val11thpassout = 0;
  bool is12thpassout = false;
  int val12thpassout = 0;

  @override
  void initState() {
    for(int i=0;i<widget.feeType.length;i++) {
      if(widget.feeType[i].contains("10th passout")) {
        is10thpassout = true;
        val10thpassout = widget.fees[i];
      }
      if(widget.feeType[i].contains("11th passout")) {
        is11thpassout = true;
        val11thpassout = widget.fees[i];
      }
      if(widget.feeType[i].contains("12th passout")) {
        is12thpassout = true;
        val12thpassout = widget.fees[i];
      }
    }
    super.initState();
  }

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
      margin: const EdgeInsets.only(left: 30, right: 30, top: 20),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: width * 0.7,
                  child: Text(
                    "${widget.name}, ${widget.location}",
                    style: const TextStyle(
                        fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                        width: width/3,
                        height: 60,
                        child: Image.network(widget.logo)
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Visibility(
                          visible: is10thpassout,
                            child: Text(
                              "10th Passout - $val10thpassout",
                            )
                        ),
                        Visibility(
                            visible: is11thpassout,
                            child: Text(
                                "11th Passout - $val11thpassout"
                            )
                        ),
                        Visibility(
                            visible: is12thpassout,
                            child: Text(
                                "12th Passout - $val12thpassout"
                            )
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
                ),
                const SizedBox(height: 5)
              ]
          )
      ),
    );
  }
}
