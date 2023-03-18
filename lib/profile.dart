import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Login/loginpage.dart';
import 'Screens/EditProfilePage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {

  void logout() async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    sharedPreferences.setBool('number', false);
    goToLogin();
  }


  void goToLogin() {
    Navigator.of(context, rootNavigator: true).pushReplacement(
        MaterialPageRoute(
            builder: (context) => const LoginPage()
        )
    );
  }
  void getSessionHistory()  {
    print("Session history");
  }


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = size.width;
    var height = size.height;
    return Scaffold(
        appBar: AppBar(
            title: const Text("My Profile"),
            backgroundColor: const Color(0xff6633ff),
            actions:[
              PopupMenuButton<String>(
                onSelected: (String result) {
                  switch (result) {
                    case 'EditProfile':
                      print('Launch Edit Profile Page');
                      Navigator.push(
                          context, MaterialPageRoute(
                          builder: (context) => const EditProfilePage()
                      )
                      );
                      break;
                    case 'ChangePassword':
                      print('option 2 clicked');
                      break;
                    case 'LogOut':
                      print('I want to delete');
                      break;
                    default:
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'EditProfile',
                    child: Text('Edit Profile'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'ChangePassword',
                    child: Text('change Password'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'LogOut',
                    child: Text('LogOut'),
                  ),
                ],
              )
            ]
        ),
        body:   ListView(
          children: [
            Column(
              children: [
                //Basic Details Card
                Container(
                    width:width,
                    height: height/4,
                    padding: const EdgeInsets.only(left:10,top:10,right:10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child:Row(

                      children: [
                        Column(

                          children: [
                            Container(
                              width:100,
                              height:100,
                              child: const Image(
                                  image: AssetImage('images/profile_icon.png')
                              ),
                            ),


                          ],
                        ),
                        const SizedBox(width: 20),
                        Column(

                          children: [
                            Center(
                                child:const Text(
                                  "Shubham Kumar",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18
                                  ),
                                )
                            ),
                            Column(

                                children:
                                [
                                  Row(
                                      children:[

                                        const Icon(
                                          CupertinoIcons.location_circle_fill,
                                          color: Colors.black,
                                          size: 20,
                                        ),
                                        const Text(
                                          "Delhi",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 10,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )

                                      ]
                                  ),
                                  Row(
                                      children:
                                      [
                                        const Icon(
                                          CupertinoIcons.envelope_circle_fill,
                                          color: Colors.black,
                                          size: 20,
                                        ),
                                        const Text(
                                          "sujeetkr.vishwakarma21@gmail.com",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 10,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )
                                      ]
                                  ),
                                  Row(
                                      children:
                                      [
                                        const Icon(
                                          CupertinoIcons.phone_circle_fill,
                                          color: Colors.black,
                                          size: 20,
                                        ),
                                        const Text(
                                          "+916387919701",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 10,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )
                                      ]
                                  )
                                ]
                            ),


                          ],
                        ),

                      ],

                    )
                ),
                Container(
                    width: width,
                    height: height/20,
                    decoration: const BoxDecoration(
                        color: const Color(0xff6633ff)
                    ),
                    child:Center(
                      child:Text(
                        "My Activity",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18
                        ),
                      ),
                    )
                ),
                Container(
                    width:width,
                    height: height/20,
                    padding: const EdgeInsets.only(left:10,top:10,right:10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child:
                    Row(
                      children: [
                        const Icon(
                          CupertinoIcons.book,
                          color: Colors.black,
                          size: 40,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          "Your Admissions",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )

                      ],

                    )
                ),
                const SizedBox(height:20),
                Container(
                    width:width,
                    height: height/20,
                    padding: const EdgeInsets.only(left:10,top:10,right:10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child:
                    Row(
                      children: [
                        const Icon(
                          CupertinoIcons.creditcard,
                          color: Colors.black,
                          size: 40,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          "Payment History",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )

                      ],

                    )
                ),
                const SizedBox(height:20),
                Container(
                    width:width,
                    height: height/20,
                    padding: const EdgeInsets.only(left:10,top:10,right:10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child:
                    Row(
                      children: [
                        const Icon(
                          CupertinoIcons.bitcoin,
                          color: Colors.black,
                          size: 40,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          "Redeem History",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )

                      ],

                    )
                ),

                const SizedBox(height:20),
                Container(
                    width:width,
                    height: height/15,
                    padding: const EdgeInsets.only(left:10,top:10,right:10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child:
                    Row(

                      children: [
                        const Icon(
                          CupertinoIcons.bookmark_fill,
                          color: Colors.black,
                          size: 40,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          "Saved Institutes",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),


                      ],

                    )
                ),
                const SizedBox(height:20),
                Container(
                    width:width,
                    height: height/15,
                    padding: const EdgeInsets.only(left:10,top:10,right:10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child:
                    Row(

                      children: [
                        const Icon(
                          CupertinoIcons.conversation_bubble,
                          color: Colors.black,
                          size: 40,
                        ),
                        const SizedBox(width: 10),
                        TextButton(
                          style: TextButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 20),
                            iconColor: Colors.black,
                          ),
                          onPressed: getSessionHistory,
                          child:  Text(
                            "Consultation History",
                            style: TextStyle(
                              color:Colors.black,
                            ),
                          ),
                        ),


                      ],

                    )
                ),

              ],
            ),

          ],

        )


    );
  }
}
