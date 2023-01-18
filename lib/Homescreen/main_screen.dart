import 'package:afterschool/Homescreen/institute_card.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  TextEditingController searchBarController = TextEditingController();
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
                  padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [

                      /* Search Bar */
                      SizedBox(
                        width: width/1.7,
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
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
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
                const SizedBox(height: 35),
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
                const SizedBox(height: 30),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.zero,
                  child: Row(
                    children: [
                      Transform.scale(
                        scale: 0.90,
                        child: const InstituteCard(),
                      ),
                      Transform.scale(
                        scale: 0.90,
                        child: const InstituteCard(),
                      ),
                      Transform.scale(
                        scale: 0.90,
                        child: const InstituteCard(),
                      ),
                      Transform.scale(
                        scale: 0.90,
                        child: const InstituteCard(),
                      ),
                      Transform.scale(
                        scale: 0.90,
                        child: const InstituteCard(),
                      ),
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


