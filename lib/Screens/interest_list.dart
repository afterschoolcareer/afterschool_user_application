import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'enrollment_list_card.dart';

class InterestScreen extends StatefulWidget {
  const InterestScreen({Key? key}) : super(key: key);

  @override
  State<InterestScreen> createState() => _InterestScreenState();
}

class _InterestScreenState extends State<InterestScreen> {
  bool showLoading = false;
  bool noData = false;
  var baseUrl = 'https://afterschoolcareer.com:8080';
  var client = http.Client();
  String query = "";
  List<InstituteData> populate = [];

  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() async {
    setState(() {
      showLoading = true;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var number = sharedPreferences.getString('phone_number');
    var course = sharedPreferences.getString('course');
    var uri = Uri.parse('$baseUrl/getAllInterestForStudent/?phone_number=$number');
    var response = await client.get(uri);
    Map data = json.decode(response.body);
    List allData = data["data"];
    if(allData.isEmpty) {
      noData = true;
      setState(() {
        showLoading = false;
      });
      return;
    }
    for(int i=0;i<allData.length;i++) {
      Map info = allData[i];
      if(i != allData.length - 1) {
        query+="${info["institute_id"].toString()},";
      } else {
        query+=info["institute_id"].toString();
      }
    }
    getInstitutes(query, course!);
  }

  void getInstitutes(String query, String course) async {
    var uri = Uri.parse('$baseUrl/getInstituteDetailsByCourseAndMultipleIds/?id=$query&course=$course');
    var response = await client.get(uri);
    Map data;
    data = json.decode(response.body);
    List allData = data["data"];
    for(int i=0;i<allData.length;i++) {
      Map info = allData[i];
      populate.add(InstituteData(
          info["id"],
          info["logo"],
          info["name"],
          info["location"]));
    }
    setState(() {
      showLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("My Interests"),
          backgroundColor: const Color(0xff6633ff),
        ),
        body: showLoading? const Center(child: CircularProgressIndicator(color: Color(0xff6633ff))) :
        noData? const Center(child: Text("Your booked admissions will appear here.")) :
        ListView.builder(
            itemCount: populate.length,
            itemBuilder: (BuildContext context, int index) {
              return EnrollmentCard(
                  name: populate[index].name,
                  location: populate[index].location,
                  id: int.parse(populate[index].id),
                  logo: populate[index].logo
              );
            }
        )
    );
  }
}

class InstituteData {
  final String id;
  final String logo;
  final String name;
  final String location;

  InstituteData(this.id, this.logo, this.name, this.location);
}

