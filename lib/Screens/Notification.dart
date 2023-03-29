import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:afterschool/Screens/online_admission_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './NotificationCard.dart';

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({Key? key}) : super(key: key);

  @override
  State<NotificationListScreen> createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  List<String> populate = [];
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
    var uri = Uri.parse('$baseUrl/getNotification/?phone_number=$phoneNumber');
    var response = await client.get(uri);
    Map data;
    data = json.decode(response.body);
    List allData = data["data"];
    for(int i=0;i<allData.length;i++) {
      String msg = allData[i];
      List<String> words = msg.split(' ');
      String finalmsg="";
      int j=0;
      for (int i=0;i<words.length;i++){
        finalmsg+=words[i];
        finalmsg+=' ';
        j++;
        if(j%10==0){
          finalmsg+='\n';
        }
      }
      populate.add(finalmsg);
    }
    setState(() {
      showLoading = false;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        backgroundColor: const Color(0xff6633ff),
      ),
      body: showLoading? const Center(child: CircularProgressIndicator(
        color: Color(0xff6633ff),
      )) :
      ListView.builder(
          itemCount: populate.length,
          itemBuilder: (BuildContext context, int index) {
            return NotificationCard(
              messege : populate[index],
            );
          }
      ),
    );
  }
}


