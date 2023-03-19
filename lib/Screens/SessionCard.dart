import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'coaching_screen.dart';

class SessionCard extends StatefulWidget {
  final String phoneNumber;
  final String date;
  final String sessionType;
  final String hour;
  final String minute;
  SessionCard({Key? key, required this.phoneNumber, required this.date,
    required this.sessionType, required this.hour, required this.minute}) : super(key: key);

  @override
  State<SessionCard> createState() => _SessionCardState();
}

class _SessionCardState extends State<SessionCard> {


  var baseUrl = 'https://afterschoolcareer.com:8080';
  var client = http.Client();

  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
      height: 30,
      child: Container(
          padding: const EdgeInsets.only(top:10, left:10, right: 10,bottom: 10),
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
          child: Row(
             children: [
               Container(
                 width: width/5,
                 height: 30,
                 child: Text(
                   widget.phoneNumber,
                   style: TextStyle(color:Colors.green, fontSize: 10),
                 ),
                ),
                   Container(
                     width: width/5,
                     height: 30,
                     child: Text(
                       widget.date,
                       style: TextStyle(color:Colors.green, fontSize: 10),
                     ),
                   ),
               Container(
                 width: width/5,
                 height: 30,
                 child: Text(
                   widget.sessionType,
                   style: TextStyle(color:Colors.green, fontSize: 10),
                 ),
               ),
               Container(
                 width: width/5,
                 height: 30,
                 child: Text(
                   "${widget.hour}:${widget.minute}",
                   style: TextStyle(color:Colors.green, fontSize: 10),
                 ),
               )

             ],
          )


      ),
    );
  }
}
