import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShortlistScreen extends StatefulWidget {
  const ShortlistScreen({Key? key}) : super(key: key);

  @override
  State<ShortlistScreen> createState() => _ShortlistScreenState();
}

class _ShortlistScreenState extends State<ShortlistScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Shortlist Screen"),
      ),
    );
  }
}
