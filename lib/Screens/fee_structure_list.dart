import 'dart:convert';

import 'package:afterschool/Screens/fee_structure_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FeeStructureList extends StatefulWidget {
  const FeeStructureList({Key? key}) : super(key: key);

  @override
  State<FeeStructureList> createState() => _FeeStructureListState();
}

class _FeeStructureListState extends State<FeeStructureList> {

  List<FeeStructureData> populate = [];
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
    var course = sharedPreferences.getString('course');
    var uri = Uri.parse('$baseUrl/feeStructureData/?course=$course');
    var response = await client.get(uri);
    Map data;
    data = json.decode(response.body);
    List feeStructureList = data["data"];
    for(int i=0; i<feeStructureList.length; i++) {
      Map info = feeStructureList[i];
      populate.add(FeeStructureData(info["logo"], info["name"], info["city"],
          info["id"], info["feeDetails"]));
      populate[i].getFeeDetails();
    }
    Comparator<FeeStructureData> feeSort = (a,b) => a.sortByFee.compareTo(b.sortByFee);
    populate.sort(feeSort);
    setState(() {
      showLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Filtered by Fees"),
        backgroundColor: const Color(0xff6633ff),
      ),
      body: showLoading? const Center(child: CircularProgressIndicator(
        color: Color(0xff6633ff),
      )) :
          ListView.builder(
          itemCount: populate.length,
          itemBuilder: (BuildContext context, int index) {
            return FeeStructureCard(
                logo: populate[index].logo,
                name: populate[index].name,
                location: populate[index].location,
                id: populate[index].id,
              feeType: populate[index].feeType,
              fees: populate[index].fees,
            );
          }
    ),
    );
  }
}

class FeeStructureData {
  final String logo;
  final String name;
  final String location;
  final int id;
  final List feeDetails;
  Map fee = {};
  List feeType = [];
  List fees = [];
  int sortByFee = 0;
  FeeStructureData(this.logo, this.name, this.location, this.id, this.feeDetails,
      );

  void getFeeDetails() {
    for(int i=0;i<feeDetails.length;i++) {
      fee = feeDetails[i];
      feeType.add(fee["course_type"]);
      fees.add(fee["fee"]);
      if(feeType[i] == "('10th passout - 2 Years', '10th passout')") {
        sortByFee = fees[i];
      }
    }
  }
}