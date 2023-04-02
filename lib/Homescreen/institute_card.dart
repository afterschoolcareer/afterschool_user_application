import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Screens/coaching_screen.dart';

class InstituteCard extends StatefulWidget {
  final int id;
  final String logo_url;
  final String name;
  final String location;
  const InstituteCard(this.id, this.logo_url, this.name, this.location, {Key? key}
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
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>  CoachingScreen(id: widget.id, coachingName: widget.name))
    );
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
                blurRadius: 7,
                offset: Offset(0, 0)
          )
          ]
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 15, right: 15),
              height: 100,
              child: Image.asset(widget.logo_url),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.only(left: 15,right: 15),
              child: Text(
                  "${widget.name}, ${widget.location}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
