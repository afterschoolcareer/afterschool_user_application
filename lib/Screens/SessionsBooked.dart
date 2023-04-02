import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'SessionCard.dart';

class SessionsBooked extends StatefulWidget {

  const SessionsBooked({Key? key}) : super(key: key);

  @override
  State<SessionsBooked> createState() => _SessionsBookedState();
}

class _SessionsBookedState extends State<SessionsBooked> {
  bool showText = false;
  bool showLoading = false;
  var baseUrl = 'https://afterschoolcareer.com:8080';
  var client = http.Client();
  late SharedPreferences sharedPreferences;
  List<SessionDetails> populate = [];

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
    var phone_number = sharedPreferences.getString('phone_number');
    var uri = Uri.parse('$baseUrl/getAllTheTopperSessionOfStudent/?phone_number=$phone_number');
    var response = await client.get(uri);
    Map data;
    data = json.decode(response.body);
    List allData = data["data"];
    print(allData.length);
    for(int i=0;i<allData.length;i++) {
      Map info = allData[i];
      populate.add(SessionDetails(
          info["phone_number"],
          info["date"],
          info["hour"],
          info["minute"],
          info["sessionType"]));
    }
    print(populate.length);
    setState(() {
      if(populate.isEmpty) showText = true;
      showLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sessions Booked"),
        backgroundColor: const Color(0xff6633ff),
      ),
      body: showLoading? const Center(child: CircularProgressIndicator(
        color: Color(0xff6633ff),
      )) :
      showText? const Center(
        child: Text(
            "Sessions that you book will appear here"
        ),
      ) : ListView.builder(
          itemCount: populate.length,
          itemBuilder: (BuildContext context, int index) {
            return SessionCard(
              phoneNumber: populate[index].phone,
              date: populate[index].date,
              sessionType: populate[index].sessionType,
              hour: populate[index].hour,
              minute: populate[index].minute,
            );
          }
      )
    );
  }
}

class SessionDetails {
  final String phone;
  final String date;
  final String hour;
  final String minute;
  final String sessionType;

  SessionDetails(this.phone, this.date, this.hour, this.minute, this.sessionType);

}


