import 'package:flutter/material.dart';

import 'home.dart';

class ReferralScreen extends StatefulWidget {
  const ReferralScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ReferralScreenState();

}

class _ReferralScreenState extends State<ReferralScreen> {

  void onReferralButtonTap() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Homescreen()));
  }

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Referral Screen';
    return Scaffold(
        appBar: AppBar(
          title: const Text(appTitle),
          centerTitle: true,
          backgroundColor: const Color(0xff6633ff),
        ),
        body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
        const Padding(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: TextField(
        decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Enter Referral Code',
        ),
        ),
        ),
        Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: TextButton(
        onPressed: onReferralButtonTap,
        child: const Text('Submit')
        )
        ),
    ],
    ),
    );
  }
}