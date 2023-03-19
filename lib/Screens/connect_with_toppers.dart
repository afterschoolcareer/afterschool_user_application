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
  Future<dynamic> Confirm(){

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Congrats'),
        content: const Text('Congratulations!! You can consult with toppers and solve your doubts'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Ok'),
          ),
        ],


      ),
    );

  }
  Future<dynamic> SessionBookedPopUp(BuildContext context){
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
  Future<dynamic> SessionBookedFailed(BuildContext context){

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
    }else{
      SessionBookedFailed(context);
    }
  }
  Future<dynamic> IsConfirm  (BuildContext context) async {

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var phone_number = sharedPreferences.getString('phone_number');
    if(phone_number == null){
      phone_number = "100";
    }
    var coins = sharedPreferences.getInt('coins');
    if(coins! >= 5 ){
      coins -= 5;
      sharedPreferences.setInt("coins",coins);
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
        content: const Text('200 coins will be deducted from your coin store'),
        actions: <Widget>[
          TextButton(

            onPressed: () async
            {
              await IsConfirm(context);
            },
            child: const Text('Confirm'),
          ),
          TextButton(

            onPressed: () => Navigator.of(context).pop()
            ,
            child: const Text('Cancel'),
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
              children: [

                Container(
                    width:width,
                    height: height/4,
                    padding: const EdgeInsets.only(left:10,top:10,right:10),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [ BoxShadow(
                            color: Color(0xff9999ff),
                            spreadRadius: 3,
                            blurRadius: 10,
                            offset: Offset(0, 0)
                        ),]
                    ),

                    child:Row(

                      children: [
                        Column(

                          children: [
                            Container(
                              width:100,
                              height:100,
                              child: const Image(
                                  image: AssetImage('images/profile_icon.png')
                              ),
                            ),


                          ],
                        ),
                        const SizedBox(width: 20),
                        Column(

                          children: [
                            Center(
                                child:const Text(
                                  "Sujeet Kumar",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18
                                  ),
                                )
                            ),
                            Column(

                                children:
                                [
                                  Row(
                                      children:[

                                        const Icon(
                                          CupertinoIcons.location_circle_fill,
                                          color: Colors.black,
                                          size: 20,
                                        ),
                                        const Text(
                                          "IIT Delhi",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 10,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )

                                      ]
                                  ),
                                  Row(
                                      children:
                                      [
                                        const Icon(
                                          CupertinoIcons.envelope_circle_fill,
                                          color: Colors.black,
                                          size: 20,
                                        ),
                                        const Text(
                                          "sujeetkr.vishwakarma21@gmail.com",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 10,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )
                                      ]
                                  ),
                                  Row(
                                      children:
                                      [
                                        const Icon(
                                          CupertinoIcons.phone_circle_fill,
                                          color: Colors.black,
                                          size: 20,
                                        ),
                                        const Text(
                                          "+916387919701",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 10,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )
                                      ]
                                  )
                                ]
                            ),


                          ],
                        ),

                      ],

                    )
                ),
                const SizedBox(width: 20),
                Container(
                    width:width,
                    height: height/4,
                    padding: const EdgeInsets.only(left:10,top:10,right:10),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [ BoxShadow(
                            color: Color(0xff9999ff),
                            spreadRadius: 3,
                            blurRadius: 10,
                            offset: Offset(0, 0)
                        ),]
                    ),

                    child:Row(

                      children: [
                        Column(

                          children: [
                            Container(
                              width:100,
                              height:100,
                              child: const Image(
                                  image: AssetImage('images/profile_icon.png')
                              ),
                            ),


                          ],
                        ),
                        const SizedBox(width: 20),
                        Column(
                          children: [
                            Center(
                                child:const Text(
                                  "Shubham Kumar",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18
                                  ),
                                )
                            ),
                            Column(

                                children:
                                [
                                  Row(
                                      children:[

                                        const Icon(
                                          CupertinoIcons.location_circle_fill,
                                          color: Colors.black,
                                          size: 20,
                                        ),
                                        const Text(
                                          "IIT Delhi",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 10,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )

                                      ]
                                  ),
                                  Row(
                                      children:
                                      [
                                        const Icon(
                                          CupertinoIcons.envelope_circle_fill,
                                          color: Colors.black,
                                          size: 20,
                                        ),
                                        const Text(
                                          "sujeetkr.vishwakarma21@gmail.com",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 10,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )
                                      ]
                                  ),
                                  Row(
                                      children:
                                      [
                                        const Icon(
                                          CupertinoIcons.phone_circle_fill,
                                          color: Colors.black,
                                          size: 20,
                                        ),
                                        const Text(
                                          "+916387919701",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 10,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )
                                      ]
                                  )
                                ]
                            ),


                          ],
                        ),

                      ],

                    )
                ),



              ],

            )
          ],
        ),
        bottomNavigationBar: ElevatedButton(
          onPressed: ()=>Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context1) => AlertDialog(
              title: const Text('Pay or Redeem'),
              content: const Text('Pay or Redeem'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context1).push(
                      MaterialPageRoute(builder: (context1) =>PaymentPage())
                  ),
                  child: const Text('Pay'),
                ),
                TextButton(
                  onPressed: () async
                  {
                    await ConfirmRedeemPopUp(context1);
                  },
                  child: const Text('Redeem'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context1).pop()
                  ,
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ),
        ),
          child: const Text('Request Session'),
          style: ElevatedButton.styleFrom(
              primary: const Color(0xff6633ff),
              side: BorderSide(width:8, color: const Color(0xff6633ff))
          ),
        ),
    );


  }
}
