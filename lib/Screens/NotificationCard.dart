import 'dart:convert';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'coaching_screen.dart';

class NotificationCard extends StatefulWidget {
  final String messege;


  const NotificationCard({Key? key, required this.messege}) : super(key: key);

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {



  @override
  void initState() {

    super.initState();
  }





  // void openEmail() {
  //   Uri emailData = Uri.parse('mailto:contact@afterschoolcareer.com?subject=Issue with Session: ${widget.sessionType}, booked on $date, at ${widget.hour}:${widget.minute}');
  //   launchUrl(emailData);
  // }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width * 0.95,
      child: Column(
          children: [ Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Notification"),
                  FittedBox(
                  child:Text("${widget.messege}"),
                  )
                ],
              ),

            ],
          ),
            const Divider(thickness: 2)
          ]
      ),
    );
  }
}
