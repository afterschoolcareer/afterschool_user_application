import 'dart:convert';
import 'dart:developer';
import 'package:afterschool/Models/global_vals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../profile.dart';
import 'drawer.dart';
import 'loan_credentials.dart' as loanCredentials;
import 'package:http/http.dart' as http;

class LoanScreen extends StatefulWidget {
  const LoanScreen({Key? key}) : super(key: key);

  @override
  State<LoanScreen> createState() => _LoanScreenState();
}

class _LoanScreenState extends State<LoanScreen> {
  bool showLoading = false;
  var baseUrlPropelld = 'https://staging.propelld.com/v1';
  var baseUrl = "https://afterschoolcareer.com:8080";
  var client = http.Client();
  bool hasBooked = false;
  bool hasSubmitted = false;

  String studentEmail = GlobalVals.getEmail();
  String studentPhone = GlobalVals.getPhone();
  String studentCourse = "";
  TextEditingController name = TextEditingController();
  TextEditingController institute = TextEditingController();
  TextEditingController location = TextEditingController();

  String submittedInstituteName = "";
  String submittedInstituteLocation = "";
  String submittedPhone = "";
  String submittedName = "";
  String submittedEmail = "";
  String submittedTime = "";
  String submittedCourse = "";

  /* managing appbar and drawer */
  void onProfileIconTapped() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const ProfilePage()));
  }
  /* to launch a drawer on button tap */
  final GlobalKey<ScaffoldState> _scaffoldDrawer = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    getBookingData();
    super.initState();
  }

  void getBookingData() async {
    setState(() {
      showLoading = true;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var number = sharedPreferences.getString('phone_number');
    studentCourse = sharedPreferences.getString('course')!;
    var uri = Uri.parse('$baseUrl/getAllBookings/?phone_number=$number');
    var response = await client.get(uri);
    Map data = json.decode(response.body);
    List allData = data["data"];
    if(allData.isNotEmpty) {
      getSubmissionStatus();
    } else {
      hasBooked = false;
      hasSubmitted = false;
      setState(() {
        showLoading = false;
      });
    }
  }

  void getSubmissionStatus() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var number = sharedPreferences.getString('phone_number');
    var uri = Uri.parse('$baseUrl/getAllqoutesForStudent/?phone_number=$number');
    var response = await client.get(uri);
    Map data;
    data = json.decode(response.body);
    List allData = data["data"];
    if(allData.isEmpty) {
        hasBooked = true;
        hasSubmitted = false;
    }
    else {
      for (int i = 0; i < allData.length; i++) {
        Map info = allData[i];
        submittedCourse = info["course"];
        submittedEmail = info["email"];
        submittedInstituteLocation = info["city"];
        submittedInstituteName = info["instituteName"];
        submittedName = info["name"];
        submittedPhone = info["phone_number"];
        submittedTime = info["date"];
      }
      hasSubmitted = true;
    }
      setState(() {
        showLoading = false;
      });
  }

  void getQuote() async {
    setState(() {
      showLoading = true;
    });
    String studentName = name.text;
    String studentInstitute = institute.text;
    String studentInsLocation = location.text;
    var now = DateTime.now();
    DateTime date = DateTime(now.year,now.month,now.day,now.hour,now.minute,now.second,now.millisecond);
    String dateFormat = date.toString();
    var uri = Uri.parse('$baseUrl/createqoute/?phone_number=$studentPhone&email=$studentEmail&studentName=$studentName&course=$studentCourse&city=$studentInsLocation&date=$dateFormat&instituteName=$studentInstitute');
    var response = await client.get(uri);
    Map data;
    data = json.decode(response.body);
    String status = data["data"];
    setState(() {
      if(status == "created") {
        hasSubmitted = true;
        submittedInstituteName = studentInstitute;
        submittedInstituteLocation = studentInsLocation;
        submittedPhone = studentPhone;
        submittedName = studentName;
        submittedEmail = studentEmail;
        submittedTime = dateFormat;
        submittedCourse = studentCourse;
      }
      showLoading = false;
    });
  }

  void tryApi() async {
    String email = "shubhamvats830@gmail.com";
    String mobile = "8375957165";
    int courseId = 1262;
    String firstName = "Shubham";
    String lastName = "Vats";
    int fees = 250000;

    Map studentData = {
      "Email" : email,
      "Mobile" : mobile,
      "CourseId" : courseId,
      "FirstName" : firstName,
      "LastName" : lastName,
      "DiscountedCourseFee" : fees
    };


    var uri = Uri.parse('$baseUrl/product/apply/generic');
    var response = await client.post(uri,
    headers: {
      "client-id" : loanCredentials.clientId,
      "client-secret" : loanCredentials.clientSecretId,
      "Content-Type" : "application/json"
    },
    body: json.encode(studentData));

    Map data;
    data = json.decode(response.body);
    log(response.statusCode.toString());
    log(data.toString());
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      key: _scaffoldDrawer,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Avail Loan",

          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w400
          ),
        ),
        leading: Builder(
          builder: (BuildContext) {
            return Transform.scale(
              scale: 1.1,
              child: IconButton(
                  onPressed: () {
                    _scaffoldDrawer.currentState?.openDrawer();
                  },
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
              InkWell(
                onTap: onProfileIconTapped,
                child: Transform.scale(
                  scale: 1.2,
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        image: const DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage("images/profile_icon.png"))),
                  ),
                ),
              ),
              const SizedBox(width: 25)
            ],
          )
        ],
      ),
      drawer: const AppBarDrawer(),
      backgroundColor: Colors.white,
      body: showLoading? const Center(child: CircularProgressIndicator(color: Color(0xff6633ff)),) :
      hasSubmitted ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            child: const Text(
                "We have received your request to get the quote for the following detail. We will follow up with you on your contact details soon.",
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 30),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xff6633ff)),
              borderRadius: BorderRadius.circular(10)
            ),
            child: Row(
              children: [
                const Text("Student Name : "),
                Text(submittedName)
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
                border: Border.all(color: const Color(0xff6633ff)),
                borderRadius: BorderRadius.circular(10)
            ),
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                const Text("Student Phone : "),
                Text(submittedPhone)
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
                border: Border.all(color: const Color(0xff6633ff)),
                borderRadius: BorderRadius.circular(10)
            ),
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                const Text("Student Email : "),
                Text(submittedEmail)
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
                border: Border.all(color: const Color(0xff6633ff)),
                borderRadius: BorderRadius.circular(10)
            ),
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                const Text("Requested Course : "),
                Text(submittedCourse)
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
                border: Border.all(color: const Color(0xff6633ff)),
                borderRadius: BorderRadius.circular(10)
            ),
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                const Text("Institute Name : "),
                Text(submittedInstituteName)
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
                border: Border.all(color: const Color(0xff6633ff)),
                borderRadius: BorderRadius.circular(10)
            ),
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                const Text("Institute Location : "),
                Text(submittedInstituteLocation)
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
                border: Border.all(color: const Color(0xff6633ff)),
                borderRadius: BorderRadius.circular(10)
            ),
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                const Text("Request date : "),
                Text(submittedTime)
              ],
            ),
          ),
        ],
      ): hasBooked? ListView(
        children: [
          Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 30, bottom: 30),
                width: MediaQuery.of(context).size.width * 0.9,
                child: const Text(
                  "Fill in the below form. After submission, we will process the information and get back to you via Email or Phone."
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Container(
                        margin: const EdgeInsets.all(5),
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: TextField(
                          readOnly: true,
                          decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.email,
                                color: Color(0xff6633ff),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(20.0)),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.black),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(20.0)),
                              ),
                            hintText: studentEmail,
                            hintStyle: const TextStyle(
                              color: Colors.black
                            )
                          ),
                        )
                    ),
                    const SizedBox(height: 10),
                    Container(
                        margin: const EdgeInsets.all(5),
                        width: MediaQuery.of(context).size.width * 0.8,
                        child:  TextField(
                          readOnly: true,
                          decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.phone,
                                color: Color(0xff6633ff),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(20.0)),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.black),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(20.0)),
                              ),
                              hintText: studentPhone,
                            hintStyle: const TextStyle(
                              color: Colors.black
                            )
                          ),
                        )
                    ),
                    const SizedBox(height: 10),
                    Container(
                        margin: const EdgeInsets.all(5),
                        width: MediaQuery.of(context).size.width * 0.8,
                        child:  TextField(
                          readOnly: true,
                          decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.menu_book_rounded,
                                color: Color(0xff6633ff),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(20.0)),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.black),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(20.0)),
                              ),
                              hintText: "Course : $studentCourse",
                              hintStyle: const TextStyle(
                                  color: Colors.black
                              )
                          ),
                        )
                    ),
                    const SizedBox(height: 10),
                    Container(
                      margin: const EdgeInsets.all(5),
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: TextField(
                        controller: name,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.person,
                            color: Color(0xff6633ff),
                          ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(20.0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.black),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(20.0)),
                            ),
                          hintText: "Enter your Original Full Name"
                        ),
                      )
                    ),
                    const SizedBox(height: 10),
                    Container(
                        margin: const EdgeInsets.all(5),
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: TextField(
                          controller: institute,
                          decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.home_work,
                                color: Color(0xff6633ff),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(20.0)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.black),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(20.0)),
                              ),
                              hintText: "Enter booked Institute Name"
                          ),
                        )
                    ),
                    const SizedBox(height: 10),
                    Container(
                        margin: const EdgeInsets.all(5),
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: TextField(
                          controller: location,
                          decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.location_on_rounded,
                                color: Color(0xff6633ff),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(20.0)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.black),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(20.0)),
                              ),
                              hintText: "Enter booked Institute City"
                          ),
                        )
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                        onPressed: getQuote,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff6633ff)
                        ),
                        child: const Text(
                            "Get Quote",
                          style: TextStyle(
                            color: Colors.white
                          ),
                        )
                    )
                  ],
                ),
              ),

            ],
          )
        ],
      ) :  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('images/loan.jpg'),
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
                border: Border.all(color: const Color(0xff6633ff)),
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xffccccff)
            ),
            child: const Text(
              "AfterSchool helps you to get a student loan to pay your coaching fees at 0% interest. To get this useful facility, you need to book your admission in any Institute that supports online booking and then come back here again.",
              style: TextStyle(
                fontSize: 15,
              ),
              textAlign: TextAlign.justify,
            ),
          ),
        ],

      )
    );
  }
}