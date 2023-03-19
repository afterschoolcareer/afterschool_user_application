import 'dart:convert';

import 'package:afterschool/Homescreen/PaymentPage.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SessionsBooked extends StatefulWidget {

  const SessionsBooked({Key? key}) : super(key: key);

  @override
  State<SessionsBooked> createState() => _SessionsBookedState();
}

class _SessionsBookedState extends State<SessionsBooked> {
  List<String> phones = [];
  List<String> dates = [];
  List<String> hours = [];
  List<String> minutes = [];
  List<String> ampms = [];
  List<String> sessionTypes = [];
  bool showLoading = false;
  var baseUrl = 'https://afterschoolcareer.com:8080';
  var client = http.Client();
  late SharedPreferences sharedPreferences;

  _SessionsBookedState();
  @override
  void initState() {
    getAllData();
    print("loaded");
    super.initState();
  }

  void getAllData() async {
    setState(() {
      showLoading = true;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var phone_number = sharedPreferences.getString('phone_number');
    print(phone_number);
    var uri = Uri.parse('$baseUrl/getAllTheTopperSessionOfStudent/?phone_number=$phone_number');
    var response = await client.get(uri);
    Map data;
    data = json.decode(response.body);
    List lists = data["data"];
    List<String> phones1 = [];
    List<String> dates1 = [];
    List<String> hours1 = [];
    List<String> minutes1 = [];
    List<String> ampms1 = [];
    List<String> sessionTypes1 = [];
    for(var i=0; i<lists.length; i++){
      Map sess = lists[i];
      var phone_number = sess["phone_number"];

      phones1.add("6387919701");

      var date = sess["date"];
      dates1.add(date);
      var hour = sess["hour"];
      hours1.add(hour);
      var minute = sess["minute"];
      minutes1.add(minute);
      var ampm = sess["ampm"];
      ampms1.add(ampm);
      var sessionType = sess["sessionType"];
      sessionTypes1.add(sessionType);
    }
    setState(() {
      this.phones = phones1;
      this.dates = dates1;
      this.hours = hours1;
      this.minutes = minutes1;
      this.ampms = ampms1;
      this.sessionTypes = sessionTypes1;
      showLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = size.width;
    var height = size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sessions Booked"),
        backgroundColor: const Color(0xff6633ff),
      ),
      body: showLoading? const Center(child: CircularProgressIndicator()) :
      ListView.builder(
          itemCount: dates.length,
          itemBuilder: (BuildContext context, int index) {
            return buildItem(context, index);
          }
      ),
    );
  }

  Widget buildItem(BuildContext context, int index) =>ListTile(
    trailing: Text(
      '$index${sessionTypes[index]}-${phones[index]}-${dates[index]}',
      style: TextStyle(color:Colors.green, fontSize: 10),
    ),
  );

}


