import 'package:afterschool/Homescreen/enrollment_screen.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../profile.dart';
import 'home.dart';

class AppBarDrawer extends StatefulWidget {
  const AppBarDrawer({Key? key}) : super(key: key);

  @override
  State<AppBarDrawer> createState() => _AppBarDrawerState();
}

class _AppBarDrawerState extends State<AppBarDrawer> {

  void onMenuItemTapped(String menuName) {

    if(menuName == "Home") {
      Navigator.of(context, rootNavigator: true).pushReplacement(
          MaterialPageRoute(
              builder: (context) => const Homescreen()
          )
      );
    }

    if(menuName == "Explore") {

    }

    if(menuName == "Notifications") {

    }

    if(menuName == "Career Counselling") {

    }

    if(menuName == "Talk to Toppers") {

    }

    if(menuName == "Contact Us") {

    }

    if(menuName == "Privacy Policy") {

    }
  }

  Widget MyDrawerList() {
    return Container(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          menuItems("Home", Icons.home_filled),
          const SizedBox(height: 10),
          menuItems("Explore", Icons.search),
          const SizedBox(height: 10),
          menuItems("Notifications", Icons.notifications),
          const SizedBox(height: 10),
          menuItems("Career Counselling", Icons.wifi_calling_3),
          const SizedBox(height: 10),
          menuItems("Talk to Toppers", FluentSystemIcons.ic_fluent_trophy_filled),
          const SizedBox(height: 10),
          menuItems("Contact Us", Icons.email_rounded),
          const SizedBox(height: 10),
          menuItems("Privacy Policy", Icons.privacy_tip_outlined),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget menuItems(String menuName, IconData iconData) {
    return Material(
      color: Colors.grey[300],
      child: InkWell(
        onTap: () => onMenuItemTapped(menuName),
        child: Padding(
          padding: const EdgeInsets.only(top: 15, left: 30),
          child: Row(
            children:  [
              Icon(
                  iconData,
                  color: Colors.black,
                  size: 30,
                ),
                const SizedBox(width: 20),
                Text(
                  menuName,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30)
        )
      ),
      backgroundColor: Colors.grey[300],
        child: SingleChildScrollView(
          child: Column(
            children: [
              const MyHeaderDrawer(),
              MyDrawerList(),
            ],
          ),
        ),
    );
  }
}

class MyHeaderDrawer extends StatefulWidget {
  const MyHeaderDrawer({Key? key}) : super(key: key);

  @override
  State<MyHeaderDrawer> createState() => MyHeaderDrawerState();
}

class MyHeaderDrawerState extends State<MyHeaderDrawer> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Container(
        color: Colors.grey[300],
        padding: const EdgeInsets.only(top: 60, left: 30, right: 30, bottom: 30),
        child: Column(
          children: [
            Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children:  [
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => const ProfilePage()));
                  },
                  child: Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        image: const DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage("images/profile_icon.png"))),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Shubham Vats",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 5)
              ],
            ),
          ],
        ));
  }
}
