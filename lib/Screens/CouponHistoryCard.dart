import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'coaching_screen.dart';

class CouponHistoryCard extends StatefulWidget {


  final String couponType;
  final String date;

  const CouponHistoryCard({Key? key,
    required this.couponType ,required this.date}) : super(key: key);

  @override
  State<CouponHistoryCard> createState() => _CouponHistoryCardState();
}

class _CouponHistoryCardState extends State<CouponHistoryCard> {
  String date = "";
  @override
  void initState() {
    setDate();
    super.initState();
  }

  void setDate() {
    String tempdate = widget.date.toString();

    List<String> ldates = tempdate.split(' ');
    int n = ldates.length;
print(ldates);
    date +=ldates[0];
    date += " ";
    date +=ldates[n-1];
  }





  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width * 0.95,
      child: Column(
          children: [ Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Redeem Information"),
                  Text("Coupon Type: ${widget.couponType}"),
                  Text("Redeemed at : ${date}"),
                ],
              )
            ],
          ),
            const Divider(thickness: 2)
          ]
      ),
    );
  }
}
