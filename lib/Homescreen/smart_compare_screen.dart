import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../profile.dart';
import 'drawer.dart';

class SmartCompareScreen extends StatefulWidget {
  const SmartCompareScreen({Key? key}) : super(key: key);

  @override
  State<SmartCompareScreen> createState() => _SmartCompareScreenState();
}

class _SmartCompareScreenState extends State<SmartCompareScreen> {

  /* managing appbar and drawer */
  void onProfileIconTapped() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const ProfilePage()));
  }

  /* to launch a drawer on button tap */
  final GlobalKey<ScaffoldState> _scaffoldDrawer = GlobalKey<ScaffoldState>();

  var course_choices = ['IIT-JEE','NEET','Others'];
  var currentSelected = 'IIT-JEE';
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    return Scaffold(
      key: _scaffoldDrawer,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Smart Compare",
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
      backgroundColor: Colors.white,

      /* Main Body */
      body: const Center(
        child: Text("Smart Compare"),
      ),
    );
  }
}
