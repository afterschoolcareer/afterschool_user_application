import 'package:afterschool/Homescreen/PaymentPage.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';



class ReferAndEarn extends StatefulWidget {
  final bool selected;
  final int available_coins;
  const ReferAndEarn(this.selected ,this.available_coins, {Key? key}) : super(key: key);

  @override
  State<ReferAndEarn> createState() => _ReferAndEarn(this.selected,this.available_coins);
}

class _ReferAndEarn extends State<ReferAndEarn> {
  bool selected;
  int available_coins;
  _ReferAndEarn(this.selected,this.available_coins);
  void onViewDetailsTapped_500() {
    var coins = 500;
    //get this value from the rest api;
    //change the value of coins available using post api
  }
  void onViewDetailsTapped_50(){
    var coins = 50;
    setState(() {
      if(selected) {
        available_coins = available_coins + coins;
      }else{
        available_coins =available_coins - coins;
      }
      if(selected){

      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("You can now consult with career expert "),
        ));
      }
      selected = !selected;
    });
    Navigator.of(context, rootNavigator: true).pushReplacement(
        MaterialPageRoute(
            builder: (context) => PaymentPage()
        )

    );
  }

  void launchWhatsapp() {
    Share.share('check out my website https://example.com');
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
        body: ListView(
          children: [
            Column(
              children: [
                const SizedBox(width: 10,height: 10,),
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
                                "200",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18
                                ),
                              ),
                              const SizedBox(width:150),
                              InkWell(
                                onTap: onViewDetailsTapped_50,
                                child: Container(
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
                const SizedBox(width: 10,height: 10,),
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
                    ) ,
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
                                onTap: launchWhatsapp,
                                child: Container(
                                  padding: const EdgeInsets.only(top: 10, bottom: 10,),
                                  width: MediaQuery.of(context).size.width / 4,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: const Color(0xff9999ff) ,
                                  ),
                                  child: const Text(
                                    "Share",
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
                const SizedBox(width: 10,height: 10,),
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
                                "2000",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18
                                ),
                              ),
                              const SizedBox(width:150),
                              InkWell(
                                onTap: onViewDetailsTapped_50,
                                child: Container(
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
                              image:AssetImage("images/scholarship.png"), ),
                          ),
                        ),
                      ],

                    )),
                const SizedBox(width: 10,height: 10,),
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
                                onTap: onViewDetailsTapped_50,
                                child: Container(
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
