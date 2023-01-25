import 'package:afterschool/Models/advertisement_list.dart';

class SmartCompareSearch {
  static List<AdvertisementList> advList = advertisementList;
  static List<String> getMatches = List.filled(advList.length, "", growable: false);

  static List<String> getList() {
    List<String> allResults = List.filled(advList.length, "", growable: false);
    for(int i=0; i<advList.length; i++) {
      allResults[i] = "${advList[i].name} , ${advList[i].location}";
    }
    return allResults;
  }

  static List<String> getSuggestions(String query) {
    List<String> matches = [];
    /* we don't want to clutter the screen when user has not typed anything
    * So, we return an empty list
    *  */
    if (query.isEmpty) return matches;

    for(int i=0; i<advList.length; i++) {
      getMatches[i] = "${advList[i].name} , ${advList[i].location}";
    }
    matches.addAll(getMatches);
    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
}