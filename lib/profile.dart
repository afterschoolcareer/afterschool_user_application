import 'package:afterschool/Models/global_vals.dart';
import 'package:afterschool/Screens/RedeemHistory.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Login/loginpage.dart';
import 'Screens/SessionsBooked.dart';
import 'Screens/enrollment_list_screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {

  var studentType = "";

  @override
  void initState() {
    var type = GlobalVals.getType();
    if(type == "1") {
      studentType = "10th Passout";
    } else if(type == "2") {
      studentType = "11th Passout";
    } else {
      studentType = "12th Passout";
    }
    super.initState();
  }

  void logout() async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    sharedPreferences.setBool('number', false);
    goToLogin();
  }


  void goToLogin() {
    // Navigator.of(context, rootNavigator: true).pushReplacement(
    //     MaterialPageRoute(
    //         builder: (context) => const LoginPage()
    //     )
    // );
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext) => const LoginPage()),
            (route) => false);
  }
  void getSessionHistory()  {
    Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => const SessionsBooked()
        )
    );
  }
  void getCouponHistory()  {
    Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => const RedeemHistory()
        )
    );
  }

  void openEnrollments() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (BuildContext context) => const EnrollmentListScreen())
    );
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
                    case 'Log Out':
                      logout();
                      break;
                    default:
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'Log Out',
                    child: Text('Log Out'),
                  ),
                ],
              )
            ]
        ),
        body: ListView(
          children: [
            Column(
              children: [
                //Basic Details Card
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(
                      width:150,
                      height:150,
                      child: Image(
                          image: AssetImage('images/profile_icon.png')
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Text(
                            GlobalVals.getName(),
                          style: const TextStyle(
                            fontSize: 20
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.black)
                              ),
                              child: const Icon(
                                Icons.call,
                                color: Color(0xff6633ff),
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(GlobalVals.getPhone())
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.black)
                              ),
                              child: const Icon(
                                Icons.email,
                                color: Color(0xff6633ff),
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(GlobalVals.getEmail())
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.black)
                              ),
                              child: const Icon(
                                Icons.person,
                                color: Color(0xff6633ff),
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(studentType)
                          ],
                        ),
                      ],
                    )
                  ],

                ),
                Container(
                    width: width,
                    margin: const EdgeInsets.only(top: 20, bottom: 20),
                    height: height/20,
                    decoration: const BoxDecoration(
                        color: Color(0xff6633ff)
                    ),
                    child: const Center(
                      child:Text(
                        "My Activity",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18
                        ),
                      ),
                    )
                ),
                InkWell(
                  onTap: openEnrollments,
                  child: Container(
                    padding: const EdgeInsets.only(left: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Icon(
                          CupertinoIcons.book,
                          color: Colors.black,
                          size: 30,
                        ),
                        SizedBox(width: 20),
                        Text(
                            "My Enrollments",
                          style: TextStyle(
                            fontSize: 18
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height:20),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.only(left: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Icon(
                          CupertinoIcons.creditcard,
                          color: Colors.black,
                          size: 30,
                        ),
                        SizedBox(width: 20),
                        Text(
                          "Payment History",
                          style: TextStyle(
                              fontSize: 18
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height:20),
                InkWell(
                  onTap: getCouponHistory,
                  child: Container(
                    padding: const EdgeInsets.only(left: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Icon(
                          CupertinoIcons.bitcoin,
                          color: Colors.black,
                          size: 30,
                        ),
                        SizedBox(width: 20),
                        Text(
                          "Redeem History",
                          style: TextStyle(
                              fontSize: 18
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height:20),
                InkWell(
                  onTap: getSessionHistory,
                  child: Container(
                    padding: const EdgeInsets.only(left: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Icon(
                          CupertinoIcons.chat_bubble_text,
                          color: Colors.black,
                          size: 30,
                        ),
                        SizedBox(width: 20),
                        Text(
                          "My Sessions",
                          style: TextStyle(
                              fontSize: 18
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

          ],

        )


    );
  }
}
