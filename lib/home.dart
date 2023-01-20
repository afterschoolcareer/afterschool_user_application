import 'package:afterschool/Homescreen/enrollment_screen.dart';
import 'package:afterschool/Homescreen/main_screen.dart';
import 'package:afterschool/Homescreen/shortlist_screen.dart';
import 'package:afterschool/Homescreen/smart_compare_screen.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Homescreen/header_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Homepage(),
    );
  }
}

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  void logout() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool('number', false);
  }

  /* items to navigate through bottom navigation bar */
  int _selectedIndex = 0;
  static final List<Widget> _bottomOptions = <Widget>[
    const MainScreen(),
    const EnrollmentScreen(),
    const SmartCompareScreen(),
    const ShortlistScreen()
  ];

  /* when a bottom navigation item is tapped */
  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  /* to launch a drawer on button tap */
  final GlobalKey<ScaffoldState> _scaffoldDrawer = GlobalKey<ScaffoldState>();

  var course_choices = ['IIT-JEE','NEET','Others'];
  var currentSelected = 'IIT-JEE';

  Widget MyDrawerList() {
    return Container();
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
                  onPressed: () => _scaffoldDrawer.currentState?.openDrawer(),
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
                    dropdownColor: Color(0xff6633ff),
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
                      setState(() => currentSelected = selectedValueNew as String);
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
              const SizedBox(width: 120),
              InkWell(
                onTap: () => print("Profile icon tapped"),
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      image: const DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage("images/smicon22.png"))),
                ),
              ),
              const SizedBox(width: 25)
            ],
          )
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.black,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const MyHeaderDrawer(),
              MyDrawerList(),
            ],
          ),
        ),
      ),
      body: Center(
        child: _bottomOptions[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: onItemTapped,
        elevation: 10,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: const Color(0xff6633ff),
        unselectedItemColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(FluentSystemIcons.ic_fluent_home_regular),
              activeIcon: Icon(FluentSystemIcons.ic_fluent_home_filled),
              label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(
                  FluentSystemIcons.ic_fluent_book_formula_database_regular),
              activeIcon: Icon(
                  FluentSystemIcons.ic_fluent_book_formula_database_filled),
              label: "Enrollments"),
          BottomNavigationBarItem(
              icon: Icon(Icons.compare_rounded),
              activeIcon: Icon(Icons.compare_rounded),
              label: "Compare"),
          BottomNavigationBarItem(
              icon: Icon(FluentSystemIcons.ic_fluent_star_regular),
              activeIcon: Icon(FluentSystemIcons.ic_fluent_star_filled),
              label: "Shortlist"),
        ],
      ),
    );
  }
}
