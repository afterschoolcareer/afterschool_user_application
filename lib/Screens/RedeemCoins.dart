import 'dart:convert';

import 'package:afterschool/Homescreen/PaymentPage.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class RedeemCoins extends StatefulWidget {

  const RedeemCoins({Key? key}) : super(key: key);

  @override
  State<RedeemCoins> createState() => _RedeemCoins();
}

class _RedeemCoins extends State<RedeemCoins> {
  bool selected = false;
  int available_coins = 0;
  static var client = http.Client();
  static String baseUrl = 'https://afterschoolcareer.com:8080/';
  bool showLoading = false;

  late SharedPreferences sharedPreferences;

  void onViewDetailsTapped_500() {
    var coins = 500;
    //get this value from the rest api;
    //change the value of coins available using post api
  }

  void loadSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    // TODO: implement initState
    setStateCoins();
    loadSharedPreferences();
    super.initState();
  }

  void setStateCoins() async {
    setState(() {
      showLoading = true;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var phone_number = sharedPreferences.getString('phone_number');
    if (sharedPreferences.containsKey("coins")) {
      var coins = sharedPreferences.getInt("coins");
      if (coins != null) {
        selected = false;
        available_coins = coins;
      } else {
        int coins = 0;
        var uri = Uri.parse(
            '$baseUrl/getavailablecoins/?phone_number=$phone_number');
        var response = await client.get(uri);
        Map data = json.decode(response.body);
        coins = data["data"];
        available_coins = coins;
        sharedPreferences.setInt('coins', coins);
        selected = false;
      }
    } else {
      int coins = 0;
      var uri = Uri.parse(
          '$baseUrl/getavailablecoins/?phone_number=$phone_number');
      var response = await client.get(uri);
      Map data = json.decode(response.body);
      coins = data["data"];
      available_coins = coins;
      selected = false;
      sharedPreferences.setInt('coins', coins);
    }
    setState(() {
      showLoading = false;
    });
  }

  void redeemed(context){
    Navigator.of(context).pop();
    setState(() {
      available_coins = available_coins-50;
      sharedPreferences?.setInt("coins", available_coins);
    });

  }
  void onViewDetailsTapped_counsellor(){
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Redeem '),
        content: const Text('Congratulations!! You can talk to our best career counsellers after Redeem'),
        actions: <Widget>[
          TextButton(
            onPressed: () => redeemed(context),
            child: const Text('Redeem'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('cancel'),
          ),
        ],
      ),
    );
  }

  void onViewDetailsTapped_topper(){
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Redeem '),
        content: const Text('Congratulations!! You can also know how toppers acheived . Redeem!'),
        actions: <Widget>[
          TextButton(
            onPressed: () => redeemed(context),
            child: const Text('Redeem'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('cancel'),
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
              "Redeem Coins"
          ),
          actions: [
            Container(
              width: width/3,
              padding: const EdgeInsets.only(left: 20),
              decoration: const BoxDecoration(
                  color: Color(0xff6633ff)
              ),
              child: Row(
                children: [
                  // TextField(
                  //   controller:textController,
                  //   maxLines:null,
                  // ),
                  Icon(
                    Icons.monetization_on,
                    color: Colors.yellow[800],
                    size: 30,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    available_coins.toString(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18
                    ),
                  )
                ],
              ),
            )
          ],
        ),

        /* main body */
        body: showLoading? const Center(child: CircularProgressIndicator(
          color: Color(0xff6633ff),
        )) : ListView(
          children: [
            Column(
              children: [
                const SizedBox(width: 10,height: 10,),
                Container(
                    width:width/1.07,
                    height: height/4,
                    margin: const EdgeInsets.only(top:20),
                    padding: const EdgeInsets.only(left:10,top:10,right:10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                              color: Color(0xff9999ff),
                              spreadRadius: 3,
                              blurRadius: 10,
                              offset: Offset(0, 0)
                          ),]
                    ),
                    child:Column(
                      children: [
                        Container(
                          child: Row(
                            children:[
                              Icon(
                                Icons.monetization_on,
                                color: Colors.yellow[800],
                                size: 30,
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                "200",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18
                                ),
                              ),
                              const SizedBox(width:150),
                              InkWell(
                                onTap: onViewDetailsTapped_counsellor,
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  padding: const EdgeInsets.only(top: 10, bottom: 10,),
                                  width: MediaQuery.of(context).size.width / 4,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: selected?Colors.white:const Color(0xff9999ff) ,
                                  ),
                                  child: Text(
                                    "Redeem",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: selected?Colors.white:Colors.black,
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Container(
                          height: height/6,
                          width: width/1.06,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            image: const DecorationImage(
                              fit: BoxFit.cover,
                              image:AssetImage("images/careercounselling.png"), ),
                          ),
                        ),
                      ],

                    )),
                const SizedBox(width: 10,height: 30),
                Container(
                    width:width/1.07,
                    height: height/4,

                    padding: const EdgeInsets.only(left:10,top:10,right:10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                              color: Color(0xff9999ff),
                              spreadRadius: 3,
                              blurRadius: 10,
                              offset: Offset(0, 0)
                          ),]
                    ),
                    child:Column(
                      children: [
                        Container(
                          child: Row(
                            children:[
                              Icon(
                                Icons.monetization_on,
                                color: Colors.yellow[800],
                                size: 30,
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                "500",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18
                                ),
                              ),
                              const SizedBox(width:150),
                              InkWell(
                                onTap: onViewDetailsTapped_topper,
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  padding: const EdgeInsets.only(top: 10, bottom: 10,),
                                  width: MediaQuery.of(context).size.width / 4,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: const Color(0xff9999ff) ,
                                  ),
                                  child: const Text(
                                    "Redeem",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Container(
                          height: height/6,
                          width: width/1.06,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            image: const DecorationImage(
                              fit: BoxFit.cover,
                              image:AssetImage("images/talktoppers.png"), ),
                          ),
                        ),
                      ],

                    )),

              ],
            )
          ],
        )
    );
  }
}
