import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:afterschool/Screens/online_admission_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:afterschool/Screens/CouponHistoryCard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RedeemHistory extends StatefulWidget {
  const RedeemHistory({Key? key}) : super(key: key);

  @override
  State<RedeemHistory> createState() => _RedeemHistoryState();
}

class _RedeemHistoryState extends State<RedeemHistory> {
  List<CouponHistoryData> populate = [];
  bool showLoading = false;
  var baseUrl = 'https://afterschoolcareer.com:8080';
  var client = http.Client();

  @override
  void initState() {
    getAllData();
    super.initState();
  }

  void getAllData() async {
    setState(() {
      showLoading = true;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var phoneNumber = sharedPreferences.getString('phone_number');
    var uri = Uri.parse('$baseUrl/getCouponHistory/?phone_number=$phoneNumber');
    var response = await client.get(uri);
    Map data;
    data = json.decode(response.body);
    List allData = data["data"];
    for(int i=0;i<allData.length;i++) {
      Map info = allData[i];
      populate.add(CouponHistoryData(  info["couponType"],info["date"],));
    }
    setState(() {
      showLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Redeem History"),
        backgroundColor: const Color(0xff6633ff),
      ),
      body: showLoading? const Center(child: CircularProgressIndicator(
        color: Color(0xff6633ff),
      )) :
      ListView.builder(
          itemCount: populate.length,
          itemBuilder: (BuildContext context, int index) {
            return CouponHistoryCard(
                couponType: populate[index].couponType,
                date: populate[index].date,
               );
          }
      ),
    );
  }
}

class CouponHistoryData {
  final String couponType;
  final String date;

  CouponHistoryData(this.couponType, this.date);
}
