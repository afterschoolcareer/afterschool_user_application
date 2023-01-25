import 'package:afterschool/Models/advertisement_list.dart';
import 'package:afterschool/Models/smart_compare_Search.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../profile.dart';
import 'drawer.dart';

class SmartCompareScreen extends StatefulWidget {
  const SmartCompareScreen({Key? key}) : super(key: key);

  @override
  State<SmartCompareScreen> createState() => _SmartCompareScreenState();
}

class _SmartCompareScreenState extends State<SmartCompareScreen> {

  /* managing appbar and drawer */
  void onProfileIconTapped() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const ProfilePage()));
  }
  /* to launch a drawer on button tap */
  final GlobalKey<ScaffoldState> _scaffoldDrawer = GlobalKey<ScaffoldState>();
  var courseChoices = ['IIT-JEE','NEET','Others'];
  var currentSelected = 'IIT-JEE';


  TextEditingController query1 = TextEditingController();
  TextEditingController query2 = TextEditingController();
  bool showCompareData = false;
  bool isSameEntry = false;
  bool inValidData = false;

  String firstCoachingName="";
  String secondCoachingName="";
  String firstCoachingLocation="";
  String secondCoachingLocation="";
  String firstCoachingLogo="";
  String secondCoachingLogo="";
  String firstCoachingSelectionPercentage="";
  int firstCoachingSelection=0;
  String secondCoachingSelectionPercentage="";
  int secondCoachingSelection=0;
  String firstCoachingTopRank="";
  int firstCoachingTopRankInt=0;
  String secondCoachingTopRank="";
  int secondCoachingTopRankInt=0;
  String firstCoachingFees="";
  int firstCoachingFeesInt=0;
  String secondCoachingFees="";
  int secondCoachingFeesInt=0;
  String firstCoachingInTop100="";
  int firstCoachingTop100Int=0;
  String secondCoachingInTop100="";
  int secondCoachingTop100Int=0;


  void onComparing() {
    String firstQuery = query1.text;
    String secondQuery = query2.text;
    setState(() {
      showCompareData = firstQuery.isNotEmpty && secondQuery.isNotEmpty &&
                        firstQuery != secondQuery;
      isSameEntry = firstQuery.isNotEmpty && secondQuery.isNotEmpty && firstQuery == secondQuery;
      inValidData = false;
    });
    int index1, index2;
    index1 = index2 = -1;
    if(showCompareData) {
      List<String> allSearchResults = SmartCompareSearch.getList();
      for(int i=0; i<allSearchResults.length; i++) {
        if(allSearchResults[i] == firstQuery) index1 = i;
        if(allSearchResults[i] == secondQuery) index2 = i;
      }
    } else {
      return;
    }

    //if the search query is random and not present in our list we don't show the data
    if(index1 == -1 || index2 == -1) {
      setState(() {
        showCompareData = false;
        inValidData = true;
      });
    }

    if(inValidData) return;

    List<AdvertisementList> coachingInfo = advertisementList;
    AdvertisementList coaching1 = coachingInfo[index1];
    AdvertisementList coaching2 = coachingInfo[index2];

    firstCoachingName = coaching1.name;
    firstCoachingLocation = coaching1.location;
    firstCoachingLogo = coaching1.logo_url;
    firstCoachingSelectionPercentage = coaching1.selection_rate;
    firstCoachingSelection = int.parse(firstCoachingSelectionPercentage.replaceAll
      (RegExp(r'[^0-9]'),''));
    firstCoachingFees = coaching1.fees;
    firstCoachingFeesInt = int.parse(firstCoachingFees.replaceAll
      (RegExp(r'[^0-9]'),''));
    firstCoachingInTop100 = coaching1.in_top_100;
    firstCoachingTop100Int = int.parse(firstCoachingInTop100.replaceAll
      (RegExp(r'[^0-9]'),''));
    firstCoachingTopRank = coaching1.top_rank;
    firstCoachingTopRankInt = int.parse(firstCoachingTopRank.replaceAll
      (RegExp(r'[^0-9]'),''));
    secondCoachingName =  coaching2.name;
    secondCoachingLocation = coaching2.location;
    secondCoachingLogo = coaching2.logo_url;
    secondCoachingSelectionPercentage = coaching2.selection_rate;
    secondCoachingSelection = int.parse(secondCoachingSelectionPercentage.replaceAll
      (RegExp(r'[^0-9]'),''));
    secondCoachingFees = coaching2.fees;
    secondCoachingFeesInt = int.parse(secondCoachingFees.replaceAll
      (RegExp(r'[^0-9]'),''));
    secondCoachingInTop100 = coaching2.in_top_100;
    secondCoachingTop100Int = int.parse(secondCoachingInTop100.replaceAll
      (RegExp(r'[^0-9]'),''));
    secondCoachingTopRank = coaching2.top_rank;
    secondCoachingTopRankInt = int.parse(secondCoachingTopRank.replaceAll
      (RegExp(r'[^0-9]'),''));
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    return Scaffold(
      key: _scaffoldDrawer,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Smart Compare",
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

      /* Main Body */
      body: ListView(
        children: [
          Column(
            children: [
              const SizedBox(height: 30),

              /* first search bar */
              Container(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: TypeAheadField(
                  suggestionsBoxDecoration: const SuggestionsBoxDecoration(
                    color: Colors.white,
                    elevation: 1.0,
                    borderRadius: BorderRadius.all(Radius.circular(15))
                  ),
                  debounceDuration: const Duration(milliseconds: 300),
                  textFieldConfiguration: TextFieldConfiguration(
                    controller: query1,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color(0xff6633ff),
                      ),
                        suffixIcon: IconButton(
                            onPressed: () => setState(() {
                              query1.clear();
                            }),
                            icon: Icon(
                                Icons.close,
                              color: query1.text.isEmpty ? Colors.grey :
                              const Color(0xff6633ff),
                            ),
                        ),
                        enabledBorder: const OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(20.0)),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xff6633ff)),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(20.0)),
                              ),
                      hintText: "Search for first institute"
                    )
                  ),
                  noItemsFoundBuilder: (context) => const SizedBox(
                    height: 50,
                    child: Center(
                      child: Text('No Matching Results found'),
                    ),
                  ),
                  suggestionsCallback: (value) {
                    return SmartCompareSearch.getSuggestions(value);
                  },
                  itemBuilder: (context, String suggestion) {
                    return Row(
                      children: [
                        const SizedBox(width: 20),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: Text(
                              suggestion,
                              maxLines: 1,
                              style: const TextStyle(
                                fontSize: 16
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                  },
                  onSuggestionSelected: (String suggestion) {
                    setState(() {
                      query1.text = suggestion;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),

              /* second search bar */
              Container(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: TypeAheadField(
                  suggestionsBoxDecoration: const SuggestionsBoxDecoration(
                      color: Colors.white,
                      elevation: 1.0,
                      borderRadius: BorderRadius.all(Radius.circular(15))
                  ),
                  debounceDuration: const Duration(milliseconds: 300),
                  textFieldConfiguration: TextFieldConfiguration(
                      controller: query2,
                      decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Color(0xff6633ff),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () => setState(() {
                              query2.clear();
                            }),
                            icon: Icon(
                              Icons.close,
                              color: query2.text.isEmpty ? Colors.grey :
                              const Color(0xff6633ff),
                            ),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.all(
                                Radius.circular(20.0)),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xff6633ff)),
                            borderRadius: BorderRadius.all(
                                Radius.circular(20.0)),
                          ),
                          hintText: "Search for second institute"
                      )
                  ),
                  noItemsFoundBuilder: (context) => const SizedBox(
                    height: 50,
                    child: Center(
                      child: Text('No Matching Results found'),
                    ),
                  ),
                  suggestionsCallback: (value) {
                    return SmartCompareSearch.getSuggestions(value);
                  },
                  itemBuilder: (context, String suggestion) {
                    return Row(
                      children: [
                        const SizedBox(width: 20),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: Text(
                              suggestion,
                              maxLines: 1,
                              style: const TextStyle(
                                  fontSize: 16
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                  },
                  onSuggestionSelected: (String suggestion) {
                    setState(() {
                      query2.text = suggestion;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),

              /* compare button */
              InkWell(
                onTap: onComparing,
                child: Container(
                  padding: const EdgeInsets.only(top:10, bottom: 10, left: 30, right: 30),
                  decoration: const BoxDecoration(
                    color: Color(0xff6633ff),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: const Text(
                    "Compare",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 40),

          Visibility(
            visible: showCompareData,
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [

                    //first row with institute detail
                    Row(
                      children: [
                        const SizedBox(width: 100),
                        Column(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: AssetImage(firstCoachingLogo)
                                )
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              firstCoachingName,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              firstCoachingLocation
                            )
                          ],
                        ),
                        const SizedBox(width: 30),

                        Column(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: AssetImage(secondCoachingLogo)
                                  )
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              secondCoachingName,
                            ),
                            const SizedBox(height: 5),
                            Text(
                                secondCoachingLocation
                            )
                          ],
                        )
                      ],
                    ),

                    DividerLine(),

                    //Selection Percentage Row
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Selection",
                              style: TextStyle(
                                fontSize: 15
                              ),
                            ),
                            Text(
                                "Percentage",
                              style: TextStyle(
                                fontSize: 15
                              ),
                            )
                          ],
                        ),
                        const SizedBox(width: 45),
                        Text(
                          firstCoachingSelectionPercentage,
                          style: TextStyle(
                            fontSize: 25,
                            color: firstCoachingSelection > secondCoachingSelection ? Colors.green : Colors.black
                          ),
                        ),
                        const SizedBox(width: 70),
                        Text(
                          secondCoachingSelectionPercentage,
                          style: TextStyle(
                            fontSize: 25,
                            color: secondCoachingSelection > firstCoachingSelection ? Colors.green : Colors.black
                          ),
                        )
                      ],
                    ),
                    DividerLine(),

                    //Rankers in Top 100 row
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Rankers in",
                              style: TextStyle(
                                  fontSize: 15
                              ),
                            ),
                            Text(
                              "Top 100",
                              style: TextStyle(
                                  fontSize: 15
                              ),
                            )
                          ],
                        ),
                        const SizedBox(width: 60),
                        Text(
                          firstCoachingInTop100,
                          style: TextStyle(
                              fontSize: 25,
                              color: firstCoachingTop100Int > secondCoachingTop100Int ? Colors.green : Colors.black
                          ),
                        ),
                        const SizedBox(width: 85),
                        Text(
                          secondCoachingInTop100,
                          style: TextStyle(
                              fontSize: 25,
                              color: secondCoachingTop100Int > firstCoachingTop100Int ? Colors.green : Colors.black
                          ),
                        )
                      ],
                    ),
                    DividerLine(),

                    //fees row
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Fee",
                              style: TextStyle(
                                  fontSize: 15
                              ),
                            ),
                            Text(
                              "Structure",
                              style: TextStyle(
                                  fontSize: 15
                              ),
                            )
                          ],
                        ),
                        const SizedBox(width: 40),
                        Text(
                          firstCoachingFees,
                          style: TextStyle(
                              fontSize: 20,
                              color: firstCoachingFeesInt < secondCoachingFeesInt ? Colors.green : Colors.black
                          ),
                        ),
                        const SizedBox(width: 35),
                        Text(
                          secondCoachingFees,
                          style: TextStyle(
                              fontSize: 20,
                              color: firstCoachingFeesInt > secondCoachingFeesInt ? Colors.green : Colors.black
                          ),
                        )
                      ],
                    ),
                    DividerLine(),

                    //top ranker row
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Top Rank",
                              style: TextStyle(
                                  fontSize: 15
                              ),
                            ),
                            Text(
                              "Achieved",
                              style: TextStyle(
                                  fontSize: 15
                              ),
                            )
                          ],
                        ),
                        const SizedBox(width: 50),
                        Text(
                          firstCoachingTopRank,
                          style: TextStyle(
                              fontSize: 25,
                              color: firstCoachingTopRankInt < secondCoachingTopRankInt ? Colors.green : Colors.black
                          ),
                        ),
                        const SizedBox(width: 60),
                        Text(
                          secondCoachingTopRank,
                          style: TextStyle(
                              fontSize: 25,
                              color: firstCoachingTopRankInt > secondCoachingTopRankInt ? Colors.green : Colors.black
                          ),
                        )
                      ],
                    ),
                    DividerLine(),
                    const SizedBox(height: 20),

                    const Text(
                      "Above shown data is of last year (2022)",
                      style: TextStyle(
                        color: Color(0xff6633ff),
                        fontSize: 15
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 50)
                  ],
                ),
              )
          ),

          Visibility(
            visible: isSameEntry,
              child: const Text(
                  "Same insitutes entered in both fields. Please select a different institute to compare.",
                style: TextStyle(
                  color: Color(0xff6633ff),
                  fontSize: 18
                ),
                textAlign: TextAlign.center,
              )
          ),

          Visibility(
              visible: inValidData,
              child: const Text(
                "Invalid Query. Please select a valid Institute.",
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 18
                ),
                textAlign: TextAlign.center,
              )
          )
        ],
      )
    );
  }
}

Widget DividerLine() {
  return const Divider(
    height: 40,
    color: Colors.black,
    thickness: 1,
    endIndent: 10,
  );
}
