import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Login/loginpage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {

  void logout() async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    sharedPreferences.setBool('number', false);
    goToLogin();
  }

  void goToLogin() {
    Navigator.of(context, rootNavigator: true).pushReplacement(
      MaterialPageRoute(
          builder: (context) => const LoginPage()
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
      ),
      body:  Center(
        child: Column(
          children: [
            const Text(
            "Profile Page"
          ),
            /* Logout Button */
            MaterialButton(
              onPressed: logout,
              color: Colors.white,
              child: const Text(
                "Logout",
                style: TextStyle(
                    color: Color(0xff6633ff)
                ),
              ),
            )
        ]
        ),
      ),
    );
  }
}
