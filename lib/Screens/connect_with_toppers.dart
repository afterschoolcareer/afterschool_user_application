import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConnectWithAchievers extends StatefulWidget {
  const ConnectWithAchievers({Key? key}) : super(key: key);

  @override
  State<ConnectWithAchievers> createState() => _ConnectWithAchieversState();
}

class _ConnectWithAchieversState extends State<ConnectWithAchievers> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff6633ff),
        title: const Text(
          "Connect with Top Achievers"
        ),
      ),

      /* main body */
      body: const Center(
        child: Text(
          "Connect with Top Achievers"
        ),
      ),
    );
  }
}
