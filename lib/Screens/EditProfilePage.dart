import 'package:afterschool/Homescreen/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool obscure = true;
  TextEditingController loginNum = TextEditingController();
  TextEditingController loginPass = TextEditingController();

  Future<void> onLoginTap() async {
    String num = loginNum.text;
    String pass = loginPass.text;
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    sharedPreferences.setBool('number', true);
    sharedPreferences.setString('phone_number', num);
    goToHome();
  }

  void goToHome() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Homescreen()));
  }



  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: const Color(0xff6633ff),
      ),
      body: ListView(
        children: [

          const SizedBox(height:50),
          const TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.person,
                color: Colors.white,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide:
                BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.all(
                    Radius.circular(20.0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Color(0xff6633ff)),
                borderRadius: BorderRadius.all(
                    Radius.circular(20.0)),
              ),
              hintText: "Enter your Name",
            ),
          ),
          const SizedBox(height:10),
          const TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.person,
                color: Colors.white,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide:
                BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.all(
                    Radius.circular(20.0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Color(0xff6633ff)),
                borderRadius: BorderRadius.all(
                    Radius.circular(20.0)),
              ),
              hintText: " Enter Email",
            ),
          ),
          const SizedBox(height:10),
          const TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.person,
                color: Colors.white,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide:
                BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.all(
                    Radius.circular(20.0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Color(0xff6633ff)),
                borderRadius: BorderRadius.all(
                    Radius.circular(20.0)),
              ),
              hintText: "Phone number",
            ),
          ),
          const SizedBox(height:10),
          const TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.person,
                color: Colors.white,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide:
                BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.all(
                    Radius.circular(20.0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Color(0xff6633ff)),
                borderRadius: BorderRadius.all(
                    Radius.circular(20.0)),
              ),
              hintText: "Location",
            ),
          ),
          const SizedBox(height:10),

        ],

      ),
      floatingActionButton:FloatingActionButton.extended(
        onPressed: () {},
        icon: Icon(Icons.thumb_up),
        label: Text("Edit"),
        backgroundColor:const Color(0xff6633ff) ,
      ),
    );
  }
}
