import 'dart:convert';

import 'package:afterschool/Homescreen/main_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:afterschool/Homescreen/PaymentPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Screens/RedeemCoins.dart';
import 'package:http/http.dart' as http;


class ConnectWithCounsellor extends StatefulWidget {
  const ConnectWithCounsellor({Key? key}) : super(key: key);

  @override
  State<ConnectWithCounsellor> createState() => _ConnectWithCounsellorState();
}

class _ConnectWithCounsellorState extends State<ConnectWithCounsellor> {

  void sendEmail() {
    Uri emailData = Uri.parse('mailto:contact@afterschoolcareer.com?subject=Career Counselling');
    launchUrl(emailData);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = size.width;
    var height = size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff6633ff),
        title: const Text(
            "Connect with Counsellors"
        ),
      ),

      /* main body */
      body: ListView(
        children: [
          Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('images/confused.jpg'),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.only(top: 20),
              width: width * 0.9,
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xff6633ff)),
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xffccccff)
              ),
              child: const Text(
                "We understand that making decisions at this point of career can be tough. To ease out, and help yourself make the correct decision - you can connect with our Career Counsellor. Please send the below button to send us an email. Please explain what problems you are facing and what guidance you are seeking. Our counsellors will connect with you shortly after the email has been sent.",
                style: TextStyle(
                  fontSize: 15,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff6633ff)
              ),
                onPressed: sendEmail, child: const Text(
                "Send Email for Appointment",
              style: TextStyle(
                color: Colors.white
              ),
            )
            )
          ],
        ),
      ]
      ),
    );


  }
}
