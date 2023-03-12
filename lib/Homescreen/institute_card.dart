import 'dart:collection';

import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InstituteCard extends StatefulWidget {
  final int id;
  final String logo_url;
  final String name;
  final String location;
  final String fees;
  final String selection_rate;
  final String top_rank;
  final String in_top_100;
  final String rating;
  const InstituteCard(this.id, this.logo_url, this.name, this.location, this.fees,
      this.selection_rate, this.top_rank, this.in_top_100, this.rating, {Key? key}
      ) : super(key: key);

  @override
  State<InstituteCard> createState() => _InstituteCardState();
}

class _InstituteCardState extends State<InstituteCard> {

  bool showShortlisted = false;

  @override
  void initState() {
    setShortlistData();
    super.initState();
  }

  void setShortlistData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var idList = sharedPreferences.getStringList('shortlist');
    if(idList == null) {
      setState(() {
        showShortlisted = false;
      });
    } else {
      if(idList.contains(widget.id.toString())) {
        setState(() {
        showShortlisted = true;
      });
      } else {
        setState(() {
          showShortlisted = false;
        });
      }
    }
  }

  void onViewDetailsTapped() {
    print("view details tapped :${widget.name}");
  }

  void onShortlistButtonTapped() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var list = sharedPreferences.getStringList('shortlist');

    //if no shortlist
    if(list == null) {
      setState(() {
        showShortlisted = true;
      });
      List<String> shortlist = [];
      shortlist.add(widget.id.toString());
      sharedPreferences.setStringList('shortlist', shortlist);
      return;
    }
    if(list.contains(widget.id.toString())) {
      setState(() {
        showShortlisted = false;
      });
      list.remove(widget.id.toString());
      sharedPreferences.setStringList('shortlist', list);
    } else {
      setState(() {
        showShortlisted = true;
      });
      list.add(widget.id.toString());
      sharedPreferences.setStringList('shortlist', list);
    }
    print(list);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width *0.90,
      height: 260,
      child: Container(
        padding: const EdgeInsets.only(top:20, left:10, right: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
            color: Color(0xff9999ff),
                spreadRadius: 3,
                blurRadius: 10,
                offset: Offset(0, 0)
          )
          ]
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                /* logo container */
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      image:  DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(widget.logo_url))),
                ),

                /* Institute name and Location and Fees */
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                      ),
                    ),
                    const SizedBox(height: 5),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text: widget.location,
                            style: const TextStyle(
                              color: Colors.black
                            )
                          ),
                          const TextSpan(
                              text: " • ",
                            style: TextStyle(
                              color: Colors.black
                            )
                          ),
                          TextSpan(
                            text: widget.fees,
                            style: const TextStyle(
                              color: Colors.black
                            )
                          )
                        ],
                      ),
                    )
                  ],
                ),

                /* rating Star */
               Row(
                 children: [
                   const Icon(
                     Icons.star,
                     color: Colors.amber,
                   ),
                   const SizedBox(width: 6),
                   /* Rating Value */
                   Text(
                     widget.rating,
                   )
                 ],
               )
              ],
            ),

            const SizedBox(height: 20),
            /* data metrics */
            Container(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xff6633ff),
                        ),
                        child: Text(
                          widget.selection_rate,
                          style: const TextStyle(
                            color: Colors.white
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "Selection",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      const Text(
                        "Rate",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(width: 10),
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xff6633ff),
                        ),
                        child: Text(
                          widget.top_rank,
                          style: const TextStyle(
                              color: Colors.white
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "Top",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      const Text(
                        "Rank",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(width: 18),
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xff6633ff),
                        ),
                        child: Text(
                          widget.in_top_100,
                          style: const TextStyle(
                              color: Colors.white
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "In Top",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      const Text(
                        "100",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  InkWell(
                    onTap: onViewDetailsTapped,
                    child: Container(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      width: MediaQuery.of(context).size.width / 1.6,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xff6633ff),
                      ),
                      child: const Text(
                        "View Details",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Transform.scale(
                    scale: 1.5,
                    child: IconButton(
                        onPressed: onShortlistButtonTapped,
                        icon: Icon(
                          showShortlisted ?
                          FluentSystemIcons.ic_fluent_star_filled :
                          FluentSystemIcons.ic_fluent_star_regular,
                          // Icons.bookmark_add_outlined,
                          color: showShortlisted?
                          const Color(0xff6633ff) : Colors.black,
                        )),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
