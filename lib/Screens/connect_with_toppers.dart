import 'dart:convert';

import 'package:afterschool/Homescreen/main_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:afterschool/Homescreen/PaymentPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Screens/RedeemCoins.dart';
import 'package:http/http.dart' as http;


class ConnectWithAchievers extends StatefulWidget {
  const ConnectWithAchievers({Key? key}) : super(key: key);

  @override
  State<ConnectWithAchievers> createState() => _ConnectWithAchieversState();
}

class _ConnectWithAchieversState extends State<ConnectWithAchievers> {

  bool selected = false;
  static var client = http.Client();
  static String baseUrl = 'https://afterschoolcareer.com:8080/';

  void onViewDetailsTapped_50(){
  }

  void showLoadingIndictor(){
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const Center(
              child:CircularProgressIndicator(),
            )
        )
    );
  }

  void removeLoadingIndicator(){
    Navigator.pop(context);
  }

  Future<dynamic> showOptions() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Redeem Coins to book'),
            content: const Text('You can redeem your coins which you have earned by refering AfterSchool. Each redeem will cost you 50 coins'),
            actions: <Widget>[
              // TextButton(
              //   onPressed: () => Navigator.of(context).push(
              //       MaterialPageRoute(builder: (context1) =>PaymentPage())
              //   ),
              //   child: const Text('Pay'),
              // ),
              TextButton(
                onPressed: () async
                {
                  await ConfirmRedeemPopUp(context);
                },
                child: const Text('Redeem', style: TextStyle(color: Color(0xff6633ff))),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop()
                ,
                child: const Text('Cancel', style: TextStyle(color: Colors.black45)),
              ),
            ],
          );
        }
    );
  }

  Future<dynamic> Confirm() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Congrats'),
          content: const Text('Congratulations!! You can consult with toppers and solve your doubts'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> SessionBookedPopUp(BuildContext context) {
    Navigator.of(context).pop();
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Topper Session Booked'),
        content: const Text('Congrats!! Your session is booked with our toppers. You will be called with in today and you can ask your doubts'),
        actions: <Widget>[
          TextButton(

            onPressed: () => Navigator.of(context).pop()
            ,
            child: const Text('ok'),
          ),
        ],
      ),
    );
  }

  Future<dynamic> SessionBookedFailed(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Topper Session Booking Failed'),
        content: const Text('Oops!! Not enough coins . Please refer your friends and earn more coins'),
        actions: <Widget>[
          TextButton(

            onPressed: () => Navigator.of(context).pop(),
            child: const Text('ok'),
          ),
        ],
      ),
    );
  }

  Future<dynamic> CreateTopperSession(BuildContext context, String phone_number,String date,String hour,String minute,String AMPM) async {
    showLoadingIndictor();
    var uri = Uri.parse('$baseUrl/createTopperSession/?phone_number=$phone_number&date=$date&hour=$hour&minute=$minute&AMPM=$AMPM');
    var response = await client.get(uri);
    Map data = json.decode(response.body);
    print(data);
    removeLoadingIndicator();
    if(data["data"]== "success"){
      Navigator.of(context).pop();
      return showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Topper Session Booked'),
          content: const Text('Congrats!! Your session is booked with our toppers. Your session will be scheduled within 1 day and you will be notified via email.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop()
              ,
              child: const Text('OK', style: TextStyle(color: Color(0xff6633ff))),
            ),
          ],
        ),
      );
    }else{
      SessionBookedFailed(context);
    }
  }
  Future<dynamic> IsConfirm(BuildContext context) async {

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var phone_number = sharedPreferences.getString('phone_number');
    if(phone_number == null){
      phone_number = "100";
    }
    var coins = sharedPreferences.getInt('coins');
    if(coins! >= 50 ){
      coins -= 50;
      sharedPreferences.setInt("coins",coins);
      var uri = Uri.parse('$baseUrl/use50coins/?phone_number=$phone_number');
      client.get(uri);
      //create topper session
      DateTime now = new DateTime.now();
      DateTime date = new DateTime(now.year,now.month,now.day);
      String dateFormat = date.toString();
      String hour = now.hour.toString();
      String minute = now.minute.toString();
      String AMPM = now.timeZoneName.toString();
      CreateTopperSession(context, phone_number, dateFormat, hour, minute, AMPM);

    }else{
      SessionBookedFailed(context);
    }
  }
  Future<dynamic> ConfirmRedeemPopUp(BuildContext context){
    Navigator.of(context).pop();
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Redeem'),
        content: const Text('50 coins will be deducted from your coin store'),
        actions: <Widget>[
          TextButton(

            onPressed: () async
            {
              await IsConfirm(context);
            },
            child: const Text('Confirm',style: TextStyle(color: Color(0xff6633ff))),
          ),
          TextButton(

            onPressed: () => Navigator.of(context).pop()
            ,
            child: const Text('Cancel',style: TextStyle(color: Colors.black45)),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = size.width;
    var height = size.height;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff6633ff),
          title: const Text(
              "Connect with Top Achievers"
          ),
        ),

        /* main body */
        body:ListView(
          children: [
            Column(
              children: const [
                ToppersList(logoUrl: "images/profile_icon.png",
                    name: "Shubham Vats", collegeName: "IIT Bidholi"),
                Divider(thickness: 3),
                ToppersList(logoUrl: "images/profile_icon.png",
                    name: "Sujeet Vishwakarma", collegeName: "IIT BHU"),
                Divider(thickness: 3),
                ToppersList(logoUrl: "images/profile_icon.png",
                    name: "Ankur Kumar", collegeName: "IIT BHU"),
                Divider(thickness: 3),
                ToppersList(logoUrl: "images/profile_icon.png",
                    name: "Harshit Kumar", collegeName: "IIT UMU"),
                Divider(thickness: 3),
                ToppersList(logoUrl: "images/profile_icon.png",
                    name: "Akshay Kumar", collegeName: "IIT UMU"),
                Divider(thickness: 3),
                ToppersList(logoUrl: "images/profile_icon.png",
                    name: "Random Topper", collegeName: "IIT Roorkee"),
              ],
            )
          ],
        ),
        bottomNavigationBar: ElevatedButton(
          onPressed: showOptions,
          style: ElevatedButton.styleFrom(
              primary: const Color(0xff6633ff),
              side: const BorderSide(width:8, color: Color(0xff6633ff))
          ),
          child: const Text('Request Session'),
        ),
    );


  }
}

class ToppersList extends StatelessWidget {

  final String logoUrl;
  final String name;
  final String collegeName;

  const ToppersList({Key? key, required this.logoUrl, required this.name,
  required this.collegeName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 130,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(logoUrl),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold),),
              Text(collegeName),
            ],
          )
        ],
      ),
    );
  }
}

