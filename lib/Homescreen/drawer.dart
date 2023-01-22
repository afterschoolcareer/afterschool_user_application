import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'header_drawer.dart';

class AppBarDrawer extends StatelessWidget {
  const AppBarDrawer({Key? key}) : super(key: key);

  Widget MyDrawerList() {
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const MyHeaderDrawer(),
              MyDrawerList(),
            ],
          ),
        ),
    );
  }
}
