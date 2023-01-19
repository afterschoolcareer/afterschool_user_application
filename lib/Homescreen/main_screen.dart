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
    //code to execute the search
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
           // padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [

                      /* Search Bar */
                      SizedBox(
                        width: width/1.3,
                        height: 35,
                        child: TextFormField(
                          controller: searchBarController,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.only(left:20, top:0, bottom: 0),
                            hintText: "Search",
                            hintStyle: TextStyle(
                              color: Color(0xff6633ff)
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Color(0xff6633ff)),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(40.0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff6633ff)),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(40.0)),
                            ),
                          )
                        ),
                      ),

                      /* Search Button*/
                      InkWell(
                        onTap: () => onSearchQuery,
                        child: Container(
                          height: 35,
                          padding: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                             shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xff6633ff)
                            )
                              ),
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
                    )
                  ),
                ),
                const SizedBox(height: 20),

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
                      var scale = pageIndex == index ? 1.0 : 0.8;
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
                              advertisementList[index].rating
                          ),
                        );
                    },
                  )
                ),

                /* Indicator container */
                Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ...List.generate(advertisementList.length, (index) => 
                      Indicator(isActive : pageIndex == index ? true : false))
                    ],
                  ),
                )
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
      width: isActive? 22.0 : 8.0,
      height: 8.0,
      decoration: BoxDecoration(
          color: isActive? const Color(0xff6633ff) : const Color(0xffccccff),
          shape: BoxShape.circle
      ),
    );
  }
}



