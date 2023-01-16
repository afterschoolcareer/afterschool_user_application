import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class homepage extends StatefulWidget {
  const homepage({Key? key}) : super(key: key);

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  void logout() async{
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool('number',false);
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Column(
          children: [
          const Text(
            "this is the homepage"
          ),
            MaterialButton(
                onPressed: logout,
              child: const Text("Logout"),
            )
        ],
        ),

      )
    );
  }
}
