import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'loan_credentials.dart' as loanCredentials;
import 'package:http/http.dart' as http;

class LoanScreen extends StatefulWidget {
  const LoanScreen({Key? key}) : super(key: key);

  @override
  State<LoanScreen> createState() => _LoanScreenState();
}

class _LoanScreenState extends State<LoanScreen> {
  var baseUrl = 'https://live.propelld.com/v1';
  static var client = http.Client();
  String clientId = loanCredentials.clientId;
  String clientSecretId = loanCredentials.clientSecretId;

  void callPropelledApi() async{

    var uri = Uri.parse(baseUrl);
    var response = await client.get(uri, headers: {
      'client-id': clientId,
      'client-secret': clientSecretId
    });
    print(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body:  Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Propelled Screen"),
              TextButton(
                  onPressed: callPropelledApi,
                  child: Text("FUCK ME"))
            ]
        ),
      ),
    );
  }
}