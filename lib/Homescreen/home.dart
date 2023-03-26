import 'dart:ffi';

import 'package:afterschool/Homescreen/enrollment_screen.dart';
import 'package:afterschool/Homescreen/loan_screen.dart';
import 'package:afterschool/Homescreen/main_screen.dart';
import 'package:afterschool/Homescreen/shortlist_screen.dart';
import 'package:afterschool/Homescreen/smart_compare_screen.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Homescreen extends StatefulWidget {
  Homescreen({Key? key}) : super(key: key);

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  int selectedIndex = 0;

  final List<Widget> widgetOptions = [
    const MainScreen(),
    const ShortlistScreen(),
    const LoanScreen(),
    const EnrollmentScreen(),
  ];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widgetOptions[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        elevation: 10,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: const Color(0xff6633ff),
        unselectedItemColor: Colors.black,
        items: const <BottomNavigationBarItem> [
                BottomNavigationBarItem(
                    icon: Icon(FluentSystemIcons.ic_fluent_home_regular),
                    activeIcon: Icon(FluentSystemIcons.ic_fluent_home_filled),
                  label: "Home"
                    ),
                BottomNavigationBarItem(
                    icon: Icon(FluentSystemIcons.ic_fluent_star_regular),
                    activeIcon: Icon(FluentSystemIcons.ic_fluent_star_filled),
                  label: "Shortlist"
                    ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.money_dollar_circle),
                  activeIcon: Icon(CupertinoIcons.money_dollar_circle_fill),
                  label: "Loan Screen"
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                      FluentSystemIcons.ic_fluent_book_formula_database_regular),
                  activeIcon: Icon(
                      FluentSystemIcons.ic_fluent_book_formula_database_filled),
                  label: "Enrollment"
                ),
        ]
      ),
    );
    // return CupertinoTabScaffold(
    //     tabBar: CupertinoTabBar(
    //       iconSize: 25,
    //       backgroundColor: Colors.white,
    //       activeColor: const Color(0xff6633ff),
    //       inactiveColor: Colors.black,
    //       items: const <BottomNavigationBarItem> [
    //         BottomNavigationBarItem(
    //             icon: Icon(FluentSystemIcons.ic_fluent_home_regular),
    //             activeIcon: Icon(FluentSystemIcons.ic_fluent_home_filled),
    //             ),
    //         BottomNavigationBarItem(
    //             icon: Icon(FluentSystemIcons.ic_fluent_star_regular),
    //             activeIcon: Icon(FluentSystemIcons.ic_fluent_star_filled),
    //             ),
    //         BottomNavigationBarItem(
    //           icon: Icon(Icons.compare_rounded),
    //           activeIcon: Icon(Icons.compare_rounded),
    //         ),
    //         BottomNavigationBarItem(
    //           icon: Icon(
    //               FluentSystemIcons.ic_fluent_book_formula_database_regular),
    //           activeIcon: Icon(
    //               FluentSystemIcons.ic_fluent_book_formula_database_filled),
    //         ),
    //       ],
    //     ),
    //     tabBuilder: (context, index) {
    //       switch(index) {
    //         case 0:
    //           return CupertinoTabView(
    //             builder: (context) {
    //               return const CupertinoPageScaffold(
    //                   child: MainScreen()
    //               );
    //             },
    //           );
    //         case 1:
    //           return CupertinoTabView(
    //             builder: (context) {
    //               return const CupertinoPageScaffold(
    //                   child: ShortlistScreen()
    //               );
    //             },
    //           );
    //         case 2:
    //           return CupertinoTabView(
    //             builder: (context) {
    //               return const CupertinoPageScaffold(
    //                   child: SmartCompareScreen()
    //               );
    //             },
    //           );
    //         case 3:
    //           return CupertinoTabView(
    //             builder: (context) {
    //               return const CupertinoPageScaffold(
    //                   child: EnrollmentScreen()
    //               );
    //             },
    //           );
    //         default:
    //           return CupertinoTabView(
    //             builder: (context) {
    //               return const CupertinoPageScaffold(
    //                   child: MainScreen()
    //               );
    //             },
    //           );
    //       }
    //     }
    // );
  }
}
