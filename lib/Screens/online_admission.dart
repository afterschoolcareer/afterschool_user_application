import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:afterschool/Screens/online_admission_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnlineAdmissionListScreen extends StatefulWidget {
  const OnlineAdmissionListScreen({Key? key}) : super(key: key);

  @override
  State<OnlineAdmissionListScreen> createState() => _OnlineAdmissionListScreenState();
}

class _OnlineAdmissionListScreenState extends State<OnlineAdmissionListScreen> {
  List<OnlineAdmissionData> populate = [];
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
    var uri = Uri.parse('$baseUrl/onlineAdmissionData/?course=$course');
    var response = await client.get(uri);
    Map data;
    data = json.decode(response.body);
    List allData = data["data"];
    for(int i=0;i<allData.length;i++) {
      Map info = allData[i];
      populate.add(OnlineAdmissionData(info["logo"], info["name"],
          info["city"], info["center"], info["id"]));
    }
    setState(() {
      showLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Online Admission Support"),
        backgroundColor: const Color(0xff6633ff),
      ),
      body: showLoading? const Center(child: CircularProgressIndicator()) :
      ListView.builder(
        itemCount: populate.length,
          itemBuilder: (BuildContext context, int index) {
          return OnlineAdmissionCard(
              logo: populate[index].logo,
              name: populate[index].name,
              location: populate[index].location,
              id: populate[index].id);
          }
      ),
    );
  }
}

class OnlineAdmissionData {
  final String logo;
  final String name;
  final String location;
  final String center;
  final int id;
  OnlineAdmissionData(this.logo, this.name, this.location, this.center, this.id);
}
