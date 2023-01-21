import 'package:afterschool/Homescreen/institute_card.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Models/advertisement_list.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  TextEditingController searchBarController = TextEditingController();
  int pageIndex = 0;

  /* when the search button is clicked */
  void onSearchQuery() {
    String searchQuery = searchBarController.text;
    print("Search Button tapped");
    //code to execute the search
  }

  void onFilterButtonTapped() {
    print("Filter Button tapped");
  }

  void onSelectionRatioTapped() {
    print("Selection Ratio tapped");
  }

  void onFeeStructureTapped() {
    print("Fee Structure tapped");
  }

  void onOnlineAdmissionTapped() {
    print("Online Admission tapped");
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Container(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 30, left: 20, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      /* Search Bar */
                      SizedBox(
                        width: width / 1.3,
                        height: 35,
                        child: TextFormField(
                            controller: searchBarController,
                            decoration: const InputDecoration(
                              contentPadding:
                                  EdgeInsets.only(left: 20, top: 0, bottom: 0),
                              hintText: "Search",
                              hintStyle: TextStyle(color: Color(0xff6633ff)),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xff6633ff)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40.0)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xff6633ff)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40.0)),
                              ),
                            )),
                      ),

                      /* Search Button*/
                      InkWell(
                        onTap: onSearchQuery,
                        child: Container(
                          height: 35,
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
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    children:  [
                      const Icon(
                        Icons.keyboard_double_arrow_left,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width /1.3,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: const [
                              CityView(image_url: "images/delhi.jpg", name: "Delhi-NCR"),
                              SizedBox(width: 15),
                              CityView(image_url: "images/hyderabad.jpg", name: "Hyderabad"),
                              SizedBox(width: 15),
                              CityView(image_url: "images/kota.png", name: "Kota"),
                              SizedBox(width: 15),
                              CityView(image_url: "images/kolkata.jpg", name: "Kolkata"),
                              SizedBox(width: 15),
                              CityView(image_url: "images/mumbai.jpg", name: "Mumbai"),
                              SizedBox(width: 15),
                              CityView(image_url: "images/patna.jpeg", name: "Patna")
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
                    Column(
                      children: [
                        InkWell(
                          onTap: onSelectionRatioTapped,
                          child: Transform.scale(
                            scale: 1.8,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(20.0))
                              ),
                              child: const Icon(
                                Icons.area_chart,
                                color: Color(0xff6633ff),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Column(
                          children: const [
                            Text(
                              "Selection"
                            ),
                            Text(
                              "Ratio"
                            )
                          ],
                        )
                      ],
                    ),
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
                const SizedBox(height: 40)
              ],
            ),
          )
        ],
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

class CityView extends StatelessWidget {
  final String image_url;
  final String name;
  const CityView({Key? key, required this.image_url, required this.name}) : super(key: key);

  void CityViewTapped() {
    print("City View Tapped :$name");
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
                    image: AssetImage(image_url))
              ),
            ),
          ),
           const SizedBox(height: 8),
           Text(
              name
          )
        ]
    );
  }
}

