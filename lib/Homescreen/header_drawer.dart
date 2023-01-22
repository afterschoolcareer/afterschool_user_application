import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Login/loginpage.dart';

class MyHeaderDrawer extends StatefulWidget {
  const MyHeaderDrawer({Key? key}) : super(key: key);

  @override
  State<MyHeaderDrawer> createState() => MyHeaderDrawerState();
}

class MyHeaderDrawerState extends State<MyHeaderDrawer> {
  static ValueNotifier<String> courseValue = ValueNotifier('');
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff6633ff),
        padding: const EdgeInsets.only(top: 60, left: 30, right: 30, bottom: 40),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:  [
                    const Text(
                      "Shubham Vats",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 5),
                    ValueListenableBuilder(
                        valueListenable: courseValue,
                        builder: (BuildContext context, String newValue, Widget? child) {
                          return Text(
                            newValue,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          );
                        },
                    )
                  ],
                ),
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      image: const DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage("images/logo_img.png"))),
                )
              ],
            ),
          ],
        ));
  }
}
