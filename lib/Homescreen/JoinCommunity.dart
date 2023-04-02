import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../profile.dart';
import 'drawer.dart';


class JoinCommunity extends StatefulWidget {
  const JoinCommunity({Key? key}) : super(key: key);

  @override
  State<JoinCommunity> createState() => _JoinCommunityState();
}

class _JoinCommunityState extends State<JoinCommunity> {
  var telegramLinkIIT = 'https://t.me/+Yn6YYX_c5R9jYmE1';
  var telegramLinkNEET = 'https://t.me/+UgZ9OZpyDdg1MDY1';

  var client = http.Client();
  void launchTelegramGroupIIT() {
    Uri tLink = Uri.parse(telegramLinkIIT);
    launchUrl(tLink,mode:LaunchMode.externalApplication);
  }

  void launchTelegramGroupNEET() {
    Uri tLink = Uri.parse(telegramLinkNEET);
    launchUrl(tLink,mode:LaunchMode.externalApplication);
  }

  /* managing appbar and drawer */
  void onProfileIconTapped() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const ProfilePage()));
  }
  /* to launch a drawer on button tap */
  final GlobalKey<ScaffoldState> _scaffoldDrawer = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = size.width;
    var height = size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldDrawer,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "AfterSchool Community",
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
      body:ListView(
        children: [
          Container(
            width: width*0.8,
            height: height * 0.3,
            margin: const EdgeInsets.only(top: 30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              image: const DecorationImage(
                fit: BoxFit.cover,
                image:AssetImage("images/community.jpg")),
            ),
          ),
          Container(
            height: height/4,
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration:   BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                border: Border.all(color: const Color(0xff6633ff)),
                color: const Color(0xffeeeeff),
              ),
            child: const Center(
                child:Text(
                  "Become part of our community "
                  "We provide a community for students ,top rank achievers, subject experts and"
                      " teachers to connect and get advice on preparation strategy, choosing right career path or institutes.",
                  style: TextStyle(color: Colors.black,fontSize: 18),

                )
            )
          ),
          const SizedBox(height: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              SizedBox(
                height: 40,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xff6633ff)
                  ),
                    onPressed: launchTelegramGroupIIT,
                    child: const Text("Join IIT Community",style: TextStyle(color:Colors.white),)
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 40,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xff6633ff)
                  ),
                    onPressed: launchTelegramGroupNEET,
                    child: const Text("Join NEET Community",style: TextStyle(color: Colors.white),)
                ),
              )

            ]


          ),
          
        ]
      ),

    );
  }
}
