import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';


class JoinCommunity extends StatefulWidget {
  const JoinCommunity({Key? key}) : super(key: key);

  @override
  State<JoinCommunity> createState() => _JoinCommunityState();
}

class _JoinCommunityState extends State<JoinCommunity> {
  var telegramlink = 'https://t.me/+Yn6YYX_c5R9jYmE1';

  var client = http.Client();
  void launchTelegramGroup() async {
    Uri tLink = Uri.parse(telegramlink);
    launchUrl(tLink,mode:LaunchMode.externalApplication);
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = size.width;
    var height = size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text(" AfterSchool Community"),
        backgroundColor: const Color(0xff6633ff),
      ),
      body:ListView(
        children: [

          Container(
            height: height/6,
            width: width/10,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              image: const DecorationImage(
                fit: BoxFit.cover,
                image:AssetImage("images/cmp.png"), ),
            ),
          ),
          Container(
            height: height/4,
              padding: const EdgeInsets.all(20),
              decoration:   BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                border: Border.all(color: const Color(0xff6633ff)),
                color: const Color(0xffeeeeff),
              ),
            child:Center(
                child:InkWell(
              child: Text(
                "Become part of our community "
                "We provide a community for students ,top rank achievers, subject experts and"
                    " teachers to connect and get advice on preparation strategy, choosing right career path or institutes.",
                style: TextStyle(color: Colors.black,fontSize: 18),

              ),
            )
            )
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children:[
              Container(
                height: 40,

                child: TextButton(
                    onPressed: launchTelegramGroup,
                    child:Text("Join IIT Community",style: TextStyle(color:const Color(0xff6633ff)),)
                ),
              ),
              const SizedBox(width: 20,),
              Container(
                height: 40,

                child: TextButton(
                    onPressed: launchTelegramGroup,
                    child:Text("Join NEET Community",style: TextStyle(color:const Color(0xff6633ff)),)
                ),
              )

            ]


          ),
          
        ]
      ),

    );
  }
}
