import 'dart:collection';
import 'dart:convert';
import 'dart:ffi';

import 'package:afterschool/Homescreen/drawer.dart';
import 'package:afterschool/Homescreen/institute_card.dart';
import 'package:afterschool/Screens/city_list_screen.dart';
import 'package:afterschool/Screens/coaching_screen.dart';
import 'package:afterschool/Screens/connect_with_toppers.dart';
import 'package:afterschool/Screens/fee_structure_list.dart';
import 'package:afterschool/Screens/filter_screen.dart';
import 'package:afterschool/Screens/online_admission.dart';
import 'package:afterschool/Screens/selection_data_list_screen.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import '../Models/advertisement_list.dart';
import '../Models/institute_model.dart';
import '../profile.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  List<String> getMatchesMain = [];
  late var map;
  bool showLoading = false;
  int searchResultId = -1;
  HashSet shortlists = HashSet();

  @override
  void initState() {
    setCurrentSelected();
    setSearchResults();
    super.initState();
  }

  void setCurrentSelected() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var course = sharedPreferences.getString('course');
    setState(() {
      if(course!=null) {
        currentSelected = course;
      } else {
        currentSelected = 'IIT';
      }
    });
  }

  void setSearchResults() async {
    setState(() {
      showLoading = true;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var course = sharedPreferences.getString('course');
    if (course == null) {
      sharedPreferences.setString('course', 'IIT');
      course = 'IIT';
    }
    var uri = Uri.parse('$baseUrl/instituteData/?course=$course');
    var response = await client.get(uri);
    Map data;
    data = json.decode(response.body);
    List results = data["data"];
    getMatchesMain = List.filled(results.length, "", growable: false);
    map = {};
    for (int i = 0; i < results.length; i++) {
      Map data = results[i];
      String name = data["name"];
      String city = data["city"];
      getMatchesMain[i] = "$name, $city";
      map[getMatchesMain[i]] = data["id"];
    }
    setState(() {
      showLoading = false;
    });
  }

  List<String> getSearchResultForSearchBar(String query) {
    List<String> matches = [];
    if(query.isEmpty) {
      return matches;
    }
      matches.addAll(getMatchesMain);
      matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
      return matches;
    }

  /* managing appbar and drawer */
  void onProfileIconTapped() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const ProfilePage()));
  }

  /* to launch a drawer on button tap */
  final GlobalKey<ScaffoldState> _scaffoldDrawer = GlobalKey<ScaffoldState>();

  var course_choices = ['IIT','NEET'];
  var currentSelected = 'IIT';

  var client = http.Client();
  var baseUrl = 'https://afterschoolcareer.com:8080';

  TextEditingController searchBarController = TextEditingController();
  int pageIndex = 0;
  int featuresPageIndex = 0;
  Uri phoneNumber = Uri.parse('tel:+918375957165');
  Uri emailData = Uri.parse('mailto:contact@afterschoolcareer.com?subject=Admission Counselling');

  List<String> featuresImageLinks = [
    'images/features_1.png',
    'images/features_2.png',
    'images/features_3.png'
  ];

  Future<dynamic> showAlertDialog() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Important"),
            content: const Text("The course that you select here will be used to filter the data of Institutes across the platform. So, please select preferred course only."),
            actions: [
              TextButton(
                  onPressed: () { Navigator.pop(context); },
                  child: const Text(
                      "Understood!",
                    style: TextStyle(
                      color: Color(0xff6633ff)
                    ),
                  ))
            ],
          );
        }
    );
  }

  void setCourse() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('course', currentSelected);
    setSearchResults();
    print(sharedPreferences.getString('course'));
  }

  void showLoadingIndicator() {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Opacity(
          opacity: 0.5,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ))
    );
  }
  void removeLoadingIndicator() {
    Navigator.pop(context);
  }
  /* when the search button is clicked */
  void onSearchQuery() {
    if(searchResultId != -1) {
      String query = searchBarController.text;
      String name = "";
      for(int i=0;i<query.length;i++) {
        if(query[i] == ',') break;
        name+=query[i];
      }
      goToCoachingScreen(searchResultId, name);
    }
  }

  void goToCoachingScreen(int id, String name) {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>  CoachingScreen(id: searchResultId, coachingName: name))
    );
  }

  void onFilterButtonTapped() {
    Navigator.push(
        context, 
        MaterialPageRoute(builder: (context) => const FilterScreen()));
  }

  void onSelectionRatioTapped() async{
    // showLoadingIndicator();
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // var course = sharedPreferences.getString('course');
    // var uri = Uri.parse('$baseUrl/selectionRatioData/?course=$course');
    // var response = await client.get(uri);
    // Map data;
    // data = json.decode(response.body);
    // List selectionList = data["data"];
    // goToSelectionDataListScreen(selectionList);
  }

  void goToSelectionDataListScreen(List data) {
    // removeLoadingIndicator();
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => SelectionDataListScreen(data: data))
    // );
  }

  void onFeeStructureTapped() async{
    goToFeeStructureListScreen();
  }

  void goToFeeStructureListScreen() {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FeeStructureList())
    );
  }

  void onOnlineAdmissionTapped() async{
    goToOnlineAdmissionListScreen();
  }

  void goToOnlineAdmissionListScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OnlineAdmissionListScreen())
    );
    // Navigator.of(context).push(
    //   PageRouteBuilder(
    //     opaque: false,
    //       pageBuilder: (_,__,___) => const OnlineAdmissionListScreen()
    //   )
    // );
  }

  void onExpertPhoneTapped() {
    launchUrl(phoneNumber);
  }


  void onExpertEmailTapped() {
    launchUrl(emailData);
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
              Container(
                padding: const EdgeInsets.all(0),
                height: 35,
                //margin: const EdgeInsets.all(13),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    color: Color(0xff9999ff)
                ),
                //padding: const EdgeInsets.all(5),
                width: width/3,
                child: Transform.scale(
                  scale: 1,
                  child: DropdownButtonFormField<String>(
                    icon: const Icon(
                      Icons.keyboard_arrow_down_outlined,
                      color: Colors.white,
                    ),
                    dropdownColor: const Color(0xff6633ff),
                    items: course_choices.map((String choice) {
                      return DropdownMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList(),
                    value: currentSelected,
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white
                    ),
                    onChanged: (selectedValueNew) {
                      setState(()  {
                        currentSelected = selectedValueNew as String;
                        setCourse();
                      });
                    },
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(left: 20, right: 20),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Color(0xff9999ff)),
                        borderRadius: BorderRadius.all(
                            Radius.circular(30.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color(0xff9999ff)),
                        borderRadius: BorderRadius.all(
                            Radius.circular(30.0)),
                      ),
                    ),
                  ),
                ),
              ),
              Transform.scale(
                scale: 0.8,
                child: IconButton(
                    onPressed: showAlertDialog,
                    icon: const Icon(
                      Icons.info,
                      color: Color(0xff9999ff),
                    )
                ),
              ),
              const SizedBox(width: 80),
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


      /* main body of the page */
      body: showLoading? const Center(child: CircularProgressIndicator(
        color: Color(0xff6633ff),
      )) :
      GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: ListView(
          children: [
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 30, left: 20, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      /* Search Bar */
                      SizedBox(
                        width: width / 1.3,
                        height: 40,
                        child: TypeAheadField(
                          suggestionsBoxDecoration: const SuggestionsBoxDecoration(
                              color: Colors.white,
                              elevation: 1.0,
                              borderRadius: BorderRadius.all(Radius.circular(15))
                          ),
                          debounceDuration: const Duration(milliseconds: 300),
                          textFieldConfiguration: TextFieldConfiguration(
                              controller: searchBarController,
                              decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    onPressed: () => setState(() {
                                      searchBarController.clear();
                                      searchResultId = -1;
                                    }),
                                    icon: Icon(
                                      Icons.close,
                                      color: searchBarController.text.isEmpty ? Colors.grey :
                                      const Color(0xff6633ff),
                                    ),
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Color(0xff6633ff)),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20.0)),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color(0xff6633ff)),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20.0)),
                                  ),
                                  hintText: "Search for an institute",
                                hintStyle: const TextStyle(
                                  color: Color(0xff6633ff)
                                ),
                              ),
                            textAlignVertical: TextAlignVertical.bottom,
                            textAlign: TextAlign.start
                          ),
                          noItemsFoundBuilder: (context) => const SizedBox(
                            height: 50,
                            child: Center(
                              child: Text('No Matching Results found'),
                            ),
                          ),
                          suggestionsCallback: (value) {
                            return getSearchResultForSearchBar(value);
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
                              searchBarController.text = suggestion;
                              searchResultId = map[suggestion];
                            });
                          },
                        ),
                      ),

                      /* Search Button*/
                      InkWell(
                        onTap: onSearchQuery,
                        child: Container(
                          height: 40,
                          padding: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: const Color(0xff6633ff))),
                          child: const Icon(
                            FluentSystemIcons.ic_fluent_search_filled,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                      text: "Handpicked for You",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      )),
                ),
                const SizedBox(height: 10),

                /* Institute Card container */
                SizedBox(
                    height: 260,
                    child: PageView.builder(
                      onPageChanged: (int index) {
                        setState(() {
                          pageIndex = index;
                        });
                      },
                      itemCount: advertisementList.length,
                      itemBuilder: (context, index) {
                        return Transform.scale(
                          scale: 0.85,
                          child: InstituteCard(
                            advertisementList[index].id,
                              advertisementList[index].logo_url,
                              advertisementList[index].name,
                              advertisementList[index].location,
                              advertisementList[index].fees,
                              advertisementList[index].selection_rate,
                              advertisementList[index].top_rank,
                              advertisementList[index].in_top_100,
                              advertisementList[index].rating),
                        );
                      },
                    )),

                /* Indicator container */
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ...List.generate(
                        advertisementList.length,
                        (index) => Indicator(
                            isActive: pageIndex == index ? true : false))
                  ],
                ),
                const SizedBox(height: 40),

                /* City List Container */
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children:  [
                      const Icon(
                        Icons.keyboard_double_arrow_left,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: width * 0.8,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children:  [
                              const CityView(image_url: "images/delhi.jpg", name: "Delhi"),
                              SizedBox(width: width * 0.05),
                              const CityView(image_url: "images/hyderabad.jpg", name: "Hyderabad"),
                              SizedBox(width: width * 0.05),
                              const CityView(image_url: "images/kota.png", name: "Kota"),
                              SizedBox(width: width * 0.05),
                              const CityView(image_url: "images/kolkata.jpg", name: "Kolkata"),
                              SizedBox(width: width * 0.05),
                              const CityView(image_url: "images/mumbai.jpg", name: "Mumbai"),
                              SizedBox(width: width * 0.05),
                              const CityView(image_url: "images/patna.jpeg", name: "Patna")
                            ],
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.keyboard_double_arrow_right,
                        color: Colors.black,
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 35),

                /* Search By Preference Section */
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Search",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 30
                          ),
                        ),
                        Text(
                          "By",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 30
                          ),
                        ),
                        Text(
                          "Preference",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 30
                          ),
                        )
                      ],
                    ),
                    InkWell(
                      onTap: onFilterButtonTapped,
                      child: Container(
                        width: 40,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                            BoxShadow(
                                color: Color(0xff9999ff),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 0)
                            )
                            ]
                        ),
                        child: Container(
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("images/filter_icon.png")
                              )
                            ),
                          )
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 40),

                /* Search By Preference Shortcuts */
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Column(
                    //   children: [
                    //     InkWell(
                    //       onTap: onSelectionRatioTapped,
                    //       child: Transform.scale(
                    //         scale: 1.8,
                    //         child: Container(
                    //           decoration: const BoxDecoration(
                    //             color: Colors.white,
                    //             borderRadius: BorderRadius.all(Radius.circular(20.0))
                    //           ),
                    //           child: const Icon(
                    //             Icons.area_chart,
                    //             color: Color(0xff6633ff),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //     const SizedBox(height: 10),
                    //     Column(
                    //       children: const [
                    //         Text(
                    //           "Selection"
                    //         ),
                    //         Text(
                    //           "Ratio"
                    //         )
                    //       ],
                    //     )
                    //   ],
                    // ),
                    Column(
                      children: [
                        InkWell(
                          onTap: onFeeStructureTapped,
                          child: Transform.scale(
                            scale: 1.8,
                            child: Container(
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(20.0))
                              ),
                              child: const Icon(
                                Icons.account_balance_wallet_rounded,
                                color: Color(0xff6633ff),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Column(
                          children: const [
                            Text(
                                "Fee"
                            ),
                            Text(
                                "Structure"
                            )
                          ],
                        )
                      ],
                    ),
                    Column(
                      children: [
                        InkWell(
                          onTap: onOnlineAdmissionTapped,
                          child: Transform.scale(
                            scale: 1.8,
                            child: Container(
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(20.0))
                              ),
                              child: const Icon(
                                FluentSystemIcons.ic_fluent_globe_search_filled,
                                color: Color(0xff6633ff),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Column(
                          children: const [
                            Text(
                                "Online"
                            ),
                            Text(
                                "Admission"
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                /* Features List */
                SizedBox(
                  height: 250,
                  child: PageView.builder(
                    onPageChanged: (int index) {
                      setState(() {
                        featuresPageIndex = index;
                      });
                    },
                    itemCount: featuresImageLinks.length,
                    itemBuilder: (context, index) {
                      return Transform.scale(
                        scale: 1,
                        child: FeaturesList(
                            image_url: featuresImageLinks[index]),
                      );
                    },
                  ),
                  ),

                /* Indicator container */
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ...List.generate(
                        featuresImageLinks.length,
                            (index) => Indicator(
                            isActive: featuresPageIndex == index ? true : false))
                  ],
                ),
                const SizedBox(height: 50),
                RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                      text: "Still confused regarding what to choose?",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w500
                      )),
                ),
                const SizedBox(height: 40),
                Container(
                  width: width,
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Color(0xff6633ff),
                  ),
                  child: Column(
                    children: [
                      RichText(
                        text: const TextSpan(
                          text: "Connect with",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25
                          )
                        )
                      ),
                      RichText(
                          text: const TextSpan(
                              text: "our Counsellors",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25
                              )
                          )
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  padding: EdgeInsets.only(left: width/3, right: width/3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: onExpertPhoneTapped,
                        child: Transform.scale(
                          scale: 1.2,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration:  BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.black)
                            ),
                            child: const Icon(
                              FluentSystemIcons.ic_fluent_phone_filled,
                              color: Color(0xff6633ff),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      InkWell(
                        onTap: onExpertEmailTapped,
                        child: Transform.scale(
                          scale: 1.2,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration:  BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.black)
                            ),
                            child: const Icon(
                              FluentSystemIcons.ic_fluent_mail_filled,
                              color: Color(0xff6633ff),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  "OR",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.w500
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  width: width,
                  padding: const EdgeInsets.all((20)),
                  decoration: const BoxDecoration(
                    color: Color(0xff6633ff)
                  ),
                  child: Column(
                    children: [
                      RichText(
                          text: const TextSpan(
                              text: "Connect with",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25
                              )
                          )
                      ),
                      RichText(
                          text: const TextSpan(
                              text: "Top Achievers",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25
                              )
                          )
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  currentSelected,
                  style: const TextStyle(
                    color: Color(0xffff9900),
                    fontSize: 20,
                    fontWeight: FontWeight.w500
                  ),
                ),
                const SizedBox(height: 20),

                /* AchieversList */
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children:  [
                      const Icon(
                        Icons.keyboard_double_arrow_left,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: width * 0.8,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: const [
                              AchieversList(logoUrl: "images/profile_icon.png",
                                  name: "Shubham Vats", collegeName: "IIT Bidholi"),
                              SizedBox(width: 15),
                              AchieversList(logoUrl: "images/profile_icon.png",
                                  name: "Sujeet Vishwakarma", collegeName: "IIT BHU"),
                              SizedBox(width: 15),
                              AchieversList(logoUrl: "images/profile_icon.png",
                                  name: "Ankur Kumar", collegeName: "IIT BHU"),
                              SizedBox(width: 15),
                              AchieversList(logoUrl: "images/profile_icon.png",
                                  name: "Harshit Kumar", collegeName: "IIT UMU"),
                              SizedBox(width: 15),
                              AchieversList(logoUrl: "images/profile_icon.png",
                                  name: "Akshay Kumar", collegeName: "IIT UMU"),
                              SizedBox(width: 15),
                              AchieversList(logoUrl: "images/profile_icon.png",
                                  name: "Random Topper", collegeName: "IIT Roorkee"),
                            ],
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.keyboard_double_arrow_right,
                        color: Colors.black,
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                /* Request a Call Section Button */
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (
                        context) => const ConnectWithAchievers()
                    ));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    height: 40,
                    width: width/2,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Color(0xff9999ff),
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset: Offset(0, 0)
                          )
                        ]
                    ),
                    child: const Text(
                      "Request a Session",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xff6633ff)
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50)
              ],
            )
          ],
        ),
      ),
    );
  }
}

class Indicator extends StatelessWidget {
  final bool isActive;

  const Indicator({Key? key, required this.isActive}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: isActive ? 22.0 : 8.0,
      height: 8.0,
      decoration: BoxDecoration(
          color: isActive ? const Color(0xff6633ff) : const Color(0xffccccff),
          shape: BoxShape.circle),
    );
  }
}

class CityView extends StatefulWidget {
  final String image_url;
  final String name;

  const CityView({Key? key, required this.image_url, required this.name}) : super(key: key);

  @override
  State<CityView> createState() => _CityViewState();
}

class _CityViewState extends State<CityView> {

  void CityViewTapped() {
    goToCityListScreen();
  }

  void goToCityListScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CityListScreen(name: widget.name))
    );
  }

  void showLoadingIndicator() {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ))
    );
  }

  void removeLoadingIndicator() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          InkWell(
            onTap: CityViewTapped,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: AssetImage(widget.image_url))
              ),
            ),
          ),
           const SizedBox(height: 8),
           Text(
              widget.name
          )
        ]
    );
  }
}

class FeaturesList extends StatelessWidget {
  final String image_url;
  const FeaturesList({Key? key, required this.image_url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(image_url)
        )
      ),
    );
  }
}

class AchieversList extends StatelessWidget {
  final String logoUrl;
  final String name;
  final String collegeName;
  const AchieversList({Key? key, required this.logoUrl, required this.name,
    required this.collegeName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
          image: AssetImage(logoUrl))
    ),
          ),
        const SizedBox(height: 10),
        Text(
          name,
        ),
        const SizedBox(height: 5),
        Text(
          collegeName
        )
      ],
    );
  }
}



