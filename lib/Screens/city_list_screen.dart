import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:afterschool/Screens/city_list_card.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CityListScreen extends StatefulWidget {
  final String name;
  const CityListScreen({Key? key, required this.name}) : super(key: key);

  @override
  State<CityListScreen> createState() => _CityListScreenState();
}

class _CityListScreenState extends State<CityListScreen> {

  List<CityList> populate = [];
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
    var uri = Uri.parse('$baseUrl/instituteListByLocation/?course=$course&city=${widget.name}');
    var response = await client.get(uri);
    Map info;
    info = json.decode(response.body);
    List data = info["data"];
    for(int i=0;i<data.length;i++) {
      Map info = data[i];
      populate.add(CityList(info["id"], info["name"], info["logo"], info["city"]));
    }
    setState(() {
      showLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Location: ${widget.name}"),
        backgroundColor: const Color(0xff6633ff),
      ),
      body: showLoading? const Center(child: CircularProgressIndicator()) :
      ListView.builder(
        itemCount: populate.length,
        itemBuilder: (BuildContext context, int index) {
          return CityListCard(
              id: populate[index].id,
              name: populate[index].name,
              logo: populate[index].logo,
              location: populate[index].location);
        }
    ),
    );
  }
}


class CityList {
  final int id;
  final String name;
  final String logo;
  final String location;
  CityList(this.id, this.name, this.logo, this.location);
}