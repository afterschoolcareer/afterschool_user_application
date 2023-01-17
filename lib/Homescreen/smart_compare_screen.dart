import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SmartCompareScreen extends StatefulWidget {
  const SmartCompareScreen({Key? key}) : super(key: key);

  @override
  State<SmartCompareScreen> createState() => _SmartCompareScreenState();
}

class _SmartCompareScreenState extends State<SmartCompareScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Smart Compare"),
      ),
    );;
  }
}
