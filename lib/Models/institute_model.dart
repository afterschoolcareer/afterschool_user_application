import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
class InstituteModel {
  static var client = http.Client();
  static var baseUrl = 'https://afterschoolcareer.com:8080';

  static Future<dynamic> getLocationList(String location) async {
    var uri = Uri.parse('$baseUrl/instituteListByLocation/?course=IIT&city=Patna');
    var response = await client.get(uri);
    Map data;
    data = json.decode(response.body);
    List locationList = data["data"];
    debugPrint(locationList.toString());
    return response.statusCode;

  }

  static Future<dynamic> getFeeStructureList(String courseName) async {
    var uri = Uri.parse('$baseUrl/feeStructureData/?course=IIT');
    var response = await client.get(uri);
    if(response.statusCode == 200) {
      print(response.body);
    }
    return response.statusCode;
  }

  static Future<dynamic> getOnlineAdmissionList(String courseName) async {
    var uri = Uri.parse('$baseUrl/onlineAdmissionData/?course=IIT');
    var response = await client.get(uri);
    if(response.statusCode == 200) {
      print(response.body);
    }
    return response.statusCode;
  }

  static Future<dynamic> getSearchResultList(String courseName) async {
    var uri = Uri.parse('$baseUrl/instituteData/?course=NEET');
    var response = await client.get(uri);
    // if(response.statusCode == 200) {
    //
    //   print(response.body);
    // }
    return response;
  }

  static Future<List<dynamic>> getSelectionRatioList(String courseName) async {
    var uri = Uri.parse('$baseUrl/selectionRatioData/?course=IIT');
    var response = await client.get(uri);
    // if(response.statusCode == 200) {
    //   print(response.body);
    // }
    Map data;
    data = json.decode(response.body);
    List locationList = data["data"];
    debugPrint(locationList.toString());
    return locationList;
  }

  static Future<dynamic> getLocationAndFeeStructureList(String courseName) async {
    var uri = Uri.parse('$baseUrl/locationFeeStructureData/?city=Kota&course=IIT');
    var response = await client.get(uri);
    if(response.statusCode == 200) {
      print(response.body);
    }
    return response;
  }

  static Future<dynamic> getLocationFeeOnlineAdmissionList(String courseName) async {
    var uri = Uri.parse('$baseUrl/locationFeeStructureOnlineAdmissionData/?city=Kota&course=IIT');
    var response = await client.get(uri);
    if(response.statusCode == 200) {
      print(response.body);
    }
    return response;
  }

  static Future<dynamic> getAllDataInstitute(String instId, String courseID) async {
    var uri = Uri.parse('$baseUrl/instituteDetailsByCourseAndId/?id=5&course=IIT');
    var response = await client.get(uri);
    if(response.statusCode == 200) {
      print(response.body);
    }
    return response;
  }
}