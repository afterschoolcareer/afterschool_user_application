import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'coaching_screen.dart';

class SessionCard extends StatefulWidget {
  final String phoneNumber;
  final String date;
  final String sessionType;
  final String hour;
  final String minute;
  const SessionCard({Key? key, required this.phoneNumber, required this.date,
    required this.sessionType, required this.hour, required this.minute}) : super(key: key);

  @override
  State<SessionCard> createState() => _SessionCardState();
}

class _SessionCardState extends State<SessionCard> {

  String date = "";

  @override
  void initState() {
    setDate();
    super.initState();
  }

  void setDate() {
    for(int i=0;i<widget.date.length;i++) {
      if(widget.date[i] == ' ') break;
      date+=widget.date[i];
    }
  }

  Future<dynamic> showAlertDialog() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Report an Issue"),
            content: const Text("If you have any issue related to this booked session, tap on Report to connect with us."),
            actions: [
              TextButton(
                  onPressed: () { Navigator.pop(context); },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                        color: Colors.black45
                    ),
                  )),
              TextButton(
                  onPressed: openEmail,
                  child: const Text(
                    "Report",
                    style: TextStyle(
                        color: Color(0xff6633ff)
                    ),
                  ))
            ],
          );
        }
    );
  }

  void openEmail() {
    Uri emailData = Uri.parse('mailto:contact@afterschoolcareer.com?subject=Issue with Session: ${widget.sessionType}, booked on $date, at ${widget.hour}:${widget.minute}');
    launchUrl(emailData);
  }

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
                Text("Booking Information: $date at ${widget.hour}:${widget.minute}"),
                Text("Session Type: ${widget.sessionType} session Booking"),
              ],
            ),
            IconButton(
                onPressed: showAlertDialog,
                icon: const Icon(
                  Icons.error_outline,
                  color: Color(0xffff9900),
                )
            )
          ],
        ),
          const Divider(thickness: 2)
      ]
      ),
    );
  }
}
