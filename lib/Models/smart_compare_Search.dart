import 'dart:convert';
import 'dart:developer';

import 'package:afterschool/Models/advertisement_list.dart';
import 'package:http/http.dart' as http;

class SmartCompareSearch {
  static var client = http.Client();
  static var baseUrl = 'https://afterschoolcareer.com:8080';
  static List<AdvertisementList> advList = advertisementList;
  static List<String> getMatches = List.filled(advList.length, "", growable: false);

  static List<String> getList() {
    List<String> allResults = List.filled(advList.length, "", growable: false);
    for(int i=0; i<advList.length; i++) {
      allResults[i] = "${advList[i].name}, ${advList[i].location}";
    }
    return allResults;
  }

  static Future<List<String>> getSuggestionsMainScreen(String query) async{
    List<String> matches = [];
    if (query.isEmpty) return matches;

    var uri = Uri.parse('$baseUrl/instituteData/?course=NEET');
    var response = await client.get(uri);
    Map data;
    data = json.decode(response.body);
    List results = data["data"];
    List<String> getMatchesMain = List.filled(results.length, "", growable: false);
      for (int i = 0; i < results.length; i++) {
        Map data = results[i];
        String name = data["name"];
        String city = data["city"];
        getMatchesMain[i] = "$name, $city";
      }
      matches.addAll(getMatchesMain);
      matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));

    return matches;
  }

  static List<String> getSuggestions(String query) {
    List<String> matches = [];
    /* we don't want to clutter the screen when user has not typed anything
    * So, we return an empty list
    *  */
    if (query.isEmpty) return matches;

    for(int i=0; i<advList.length; i++) {
      getMatches[i] = "${advList[i].name}, ${advList[i].location}";
    }
    matches.addAll(getMatches);
    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
}