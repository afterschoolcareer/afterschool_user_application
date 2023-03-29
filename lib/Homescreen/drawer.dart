import 'dart:convert';

import 'package:afterschool/Homescreen/enrollment_screen.dart';
import 'package:afterschool/Models/global_vals.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Screens/connect_with_toppers.dart';
import '../Screens/careerCounselling.dart';
import '../Screens/RedeemCoins.dart';
import '../Screens/Notification.dart';
import '../Screens/ReferAndEarn.dart';
import '../profile.dart';
import 'home.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
class AppBarDrawer extends StatefulWidget {
  const AppBarDrawer({Key? key}) : super(key: key);

  @override
  State<AppBarDrawer> createState() => _AppBarDrawerState();
}

class _AppBarDrawerState extends State<AppBarDrawer> {

  static var client = http.Client();
  static String baseUrl = 'https://afterschoolcareer.com:8080/';
  bool showLoading = false;

  void onMenuItemTapped(String menuName) {

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
    void share() async {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      var phone_number = sharedPreferences.getString('phone_number');
      var uri = Uri.parse('$baseUrl/getreferralcode/?phone_number=$phone_number');
      var response = await client.get(uri);
      Map data = json.decode(response.body);
      String code = data["data"];
      Share.share("use my afterschool coupon code $code to get 50 coins ");
    }

    void redeemPage() {
      Navigator.push(
          context, MaterialPageRoute(
          builder: (context) => RedeemCoins()
      )
      );
      // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      // var phone_number = sharedPreferences.getString('phone_number');
      // if(sharedPreferences.containsKey("coins")){
      //   var coins = sharedPreferences.getInt("coins");
      //   if(coins != null) {
      //     Navigator.push(
      //         context, MaterialPageRoute(
      //         builder: (context) => RedeemCoins(false, coins)
      //     )
      //     );
      //   }else{
      //     int coins =0;
      //     var uri = Uri.parse('$baseUrl/getavailablecoins/?phone_number=$phone_number');
      //     showLoadingIndictor();
      //     var response = await client.get(uri);
      //     removeLoadingIndicator();
      //     Map data = json.decode(response.body);
      //     coins = data["data"];
      //     sharedPreferences.setInt('coins',coins);
      //     Navigator.push(
      //         context, MaterialPageRoute(
      //         builder: (context) => RedeemCoins(false, coins)
      //     ));
      //   }
      // }else {
      //   int coins=0;
      //   var uri = Uri.parse('$baseUrl/getavailablecoins/?phone_number=$phone_number');
      //   showLoadingIndictor();
      //   var response = await client.get(uri);
      //   removeLoadingIndicator();
      //   Map data = json.decode(response.body);
      //   coins = data["data"];
      //   Navigator.push(
      //       context, MaterialPageRoute(
      //       builder: (context) => RedeemCoins(false, coins)
      //   ));
      //
      //   sharedPreferences.setInt('coins',coins);
      // }

    }

    if(menuName == "Notifications") {
      Navigator.push(
          context, MaterialPageRoute(
          builder: (context) => const NotificationListScreen()
      )
      );
    }

    if(menuName == "Career Counselling") {

      Navigator.push(
          context, MaterialPageRoute(
          builder: (context) => const ConnectWithCounsellor()
      )
      );
    }

    if(menuName == "Talk to Toppers") {
      Navigator.push(
          context, MaterialPageRoute(
          builder: (context) => const ConnectWithAchievers()
      )
      );
    }

    if(menuName == "Redeem Coins") {
      redeemPage();
    }

    if(menuName == "Refer and Earn") {
      share();
    }

    if(menuName == "Contact Us") {

    }

    if(menuName == "Privacy Policy") {

    }
  }

  Widget MyDrawerList() {
    return Container(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          menuItems("Notifications", Icons.notifications),
          const SizedBox(height: 10),
          menuItems("Career Counselling", Icons.wifi_calling_3),
          const SizedBox(height: 10),
          menuItems("Talk to Toppers", FluentSystemIcons.ic_fluent_trophy_filled),
          const SizedBox(height: 10),
          menuItems("Redeem Coins", Icons.currency_exchange_rounded),
          const SizedBox(height: 10),
          menuItems("Refer and Earn", Icons.currency_bitcoin),
          const SizedBox(height: 10),
          menuItems("Contact Us", Icons.email_rounded),
          const SizedBox(height: 10),
          menuItems("Privacy Policy", Icons.privacy_tip_outlined),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget menuItems(String menuName, IconData iconData) {
    return Material(
      color: Colors.grey[200],
      child: InkWell(
        onTap: () => onMenuItemTapped(menuName),
        child: Padding(
          padding: const EdgeInsets.only(top: 15, left: 30),
          child: Row(
            children:  [
              Icon(
                iconData,
                color: Colors.black,
                size: 30,
              ),
              const SizedBox(width: 20),
              Text(
                menuName,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30),
              bottomRight: Radius.circular(30)
          )
      ),
      backgroundColor: Colors.grey[200],
      child: SingleChildScrollView(
        child: Column(
          children: [
            const MyHeaderDrawer(),
            MyDrawerList(),
          ],
        ),
      ),
    );
  }
}

class MyHeaderDrawer extends StatefulWidget {
  const MyHeaderDrawer({Key? key}) : super(key: key);

  @override
  State<MyHeaderDrawer> createState() => MyHeaderDrawerState();
}

class MyHeaderDrawerState extends State<MyHeaderDrawer> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Container(
        color: Colors.grey[200],
        padding: const EdgeInsets.only(top: 60, left: 30, right: 30, bottom: 30),
        child: Column(
          children: [
            Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children:  [
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => const ProfilePage()));
                  },
                  child: Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        image: const DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage("images/profile_icon.png"))),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  GlobalVals.getName(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 5)
              ],
            ),
          ],
        ));
  }
}
