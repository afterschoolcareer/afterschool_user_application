import 'dart:convert';

import 'package:afterschool/Screens/online_admission_card.dart';
import 'package:afterschool/Screens/shortlist_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../profile.dart';
import 'drawer.dart';

class ShortlistScreen extends StatefulWidget {
  const ShortlistScreen({Key? key}) : super(key: key);

  @override
  State<ShortlistScreen> createState() => _ShortlistScreenState();
}

class _ShortlistScreenState extends State<ShortlistScreen> {

  List<SavedInstitute> populate = [];

  @override
  void initState() {
    getShortlistedData();
    super.initState();
  }
  bool showData = false;
  bool showText = false;
  bool showLoading = false;
  List shortlists = [];
  String query = "";

  var client = http.Client();
  var baseUrl = 'https://afterschoolcareer.com:8080';

  void getShortlistedData() async{
    setState(() {
      showLoading = true;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var ids  = sharedPreferences.getStringList('shortlist');
    var course = sharedPreferences.getString('course');
    if(ids == null || ids.isEmpty) {
        showData = false;
    } else {
      showData = true;
      shortlists = ids;
      for(int i=0;i<shortlists.length;i++) {
        if(i == shortlists.length - 1) {
          query+=shortlists[i];
        } else {
          query+="${shortlists[i]},";
        }
      }
      print(query);
      //api calling
      var uri = Uri.parse('$baseUrl/getInstituteDetailsByCourseAndMultipleIds/?id=$query&course=$course');
      var response = await client.get(uri);
      Map data;
      data = json.decode(response.body);
      List shortlistedInstitutes = data["data"];
      for(int i=0;i<shortlistedInstitutes.length;i++) {
        Map info = shortlistedInstitutes[i];
        populate.add(SavedInstitute(
            info["id"],
            info["name"],
            info["location"],
            info["logo"]
        ));
      }
    }
    setState(() {
      showLoading = false;
    });
    if(populate.isEmpty) {
      setState(() {
        showText = true;
      });
    }
  }

  /* managing appbar and drawer */
  void onProfileIconTapped() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const ProfilePage()));
  }
  /* to launch a drawer on button tap */
  final GlobalKey<ScaffoldState> _scaffoldDrawer = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldDrawer,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "My Shortlists",
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w400
          ),
        ),
        leading: Builder(
          builder: (BuildContext) {
            return Transform.scale(
              scale: 1.1,
              child: IconButton(
                  onPressed: () {
                    _scaffoldDrawer.currentState?.openDrawer();
                  },
                  icon: const Icon(
                    Icons.menu,
                    color: Colors.black,
                  )),
            );
          },
        ),
        actions: [
          Row(
            children: [
              InkWell(
                onTap: onProfileIconTapped,
                child: Transform.scale(
                  scale: 1.2,
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        image: const DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage("images/profile_icon.png"))),
                  ),
                ),
              ),
              const SizedBox(width: 25)
            ],
          )
        ],
      ),
      drawer: const AppBarDrawer(),
      backgroundColor: Colors.white,
      body: showLoading? const Center(child: CircularProgressIndicator(
        color: Color(0xff6633ff),
      )) :
          showText? const Center(child: Text("Institutes that you shortlist will appear here.")) :
      ListView.builder(
        itemCount: populate.length,
          itemBuilder: (BuildContext context, int index) {
          return ShortlistCard(
              name: populate[index].name,
              location: populate[index].location,
              id: int.parse(populate[index].id),
            logo: populate[index].logo
          );
          }
      )
    );
  }
}

class SavedInstitute {
  final String id;
  final String name;
  final String location;
  final String logo;
  SavedInstitute(this.id, this.name, this.location, this.logo);
}
