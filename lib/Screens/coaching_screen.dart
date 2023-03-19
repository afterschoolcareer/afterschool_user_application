import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CoachingScreen extends StatefulWidget {
  final int id;
  final String coachingName;
  const CoachingScreen({Key? key, required this.id, required this.coachingName}) : super(key: key);

  @override
  State<CoachingScreen> createState() => _CoachingScreenState();
}

class _CoachingScreenState extends State<CoachingScreen> {
  String name = "";
  String location = "";
  String state = "";
  String country = "";
  String zipcode = "";
  String email = "";
  String center = "";
  String logo = "";
  List fees = [];
  List faculty = [];
  List subjects = [];
  List topRankers = [];
  List scholarship = [];
  List selectionData = [];

  List<String> feeTypes = [];
  List feeValues = [];
  Map feeInfo = {};
  List<Faculty> facultyData = [];
  List<Subject> subjectData = [];
  List<Ranker> rankerData = [];
  int top100 = 0;
  int top200 = 0;
  int top500 = 0;
  int top1000 = 0;
  int totalSelections = 0;
  int totalStudents = 0;

  bool isFaculty = true;
  bool isRankers = true;
  bool isScholarship = true;
  bool isTop100 = true;
  bool isTop200 = true;
  bool isTop500 = true;
  bool isTop1000 = true;
  bool isTotalSelection = true;
  bool isTotalNumber = true;

  bool showShortlisted = false;
  bool showLoading = false;

  List<String> feeView = [
    "10th Passout - 2 Years",
    "11th Passout - 1 Year",
    "12th Passout - 1 Year"
  ];
  var currentSelected =  "10th Passout - 2 Years";

  var baseUrl = 'https://afterschoolcareer.com:8080';
  var client = http.Client();

  @override
  void initState() {
    getDetails(widget.id);
    super.initState();
  }

  void setShortlisted() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var idList = sharedPreferences.getStringList('shortlist');
    print(idList);
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

  void onShortlistTapped() async{
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

  void setDataVisibility() {
    if(facultyData.isEmpty) {
      isFaculty = false;
    }
    if(rankerData.isEmpty) {
      isRankers = false;
    }
    if(scholarship.isEmpty) {
      isScholarship = false;
    }
    if(top100 == 0) {
      isTop100 = false;
    }
    if(top200 == 0) {
      isTop200 = false;
    }
    if(top500 == 0) {
      isTop500 = false;
    }
    if(top1000 == 0) {
      isTop1000 = false;
    }
    if(totalSelections == 0) {
      isTotalSelection = false;
    }
    if(totalStudents == 0) {
      isTotalNumber = false;
    }
  }

  void setFees() {
    for(int i=0;i<fees.length;i++) {
      Map info = fees[i];
      feeTypes.add(info["course_type"]);
      feeValues.add(info["fee"]);
      if(info["course_type"].toString().contains("10th")) {
        feeInfo["10th Passout - 2 Years"] = info["fee"];
      }
      if(info["course_type"].toString().contains("11th")) {
        feeInfo["11th Passout - 1 Year"] = info["fee"];
      }
      if(info["course_type"].toString().contains("12th")) {
        feeInfo["12th Passout - 1 Year"] = info["fee"];
      }
    }
  }

  void setFaculties() {
    for(int i=0;i<faculty.length;i++) {
      Map info = faculty[i];
      facultyData.add(Faculty(
          info["faculty_name"],
          info["image"],
          info["qualification"],
          info["experience"],
          info["subject"]
      ));
    }
  }

  void setSubjects() {
    for(int i=0;i<subjects.length;i++) {
      Map info = subjects[i];
      subjectData.add(Subject(info["subject_name"], info["demoVideos"]));
    }
  }

  void setRankers() {
    for(int i=0;i<topRankers.length;i++) {
      Map info = topRankers[i];
      rankerData.add(Ranker(info["name"], info["rank"], info["image"]));
    }
  }

  void setScholarship() {

  }

  void setSelectionData() {
    if(selectionData.isEmpty) return;
    Map info = selectionData[0];
    top100 = info["Top100"];
    top200 = info["Top200"];
    top500 = info["Top500"];
    top1000 = info["Top1000"];
    totalSelections = info["no_of_selections"];
    totalStudents = info["no_of_students"];
  }

  void getDetails(int id) async {
    setState(() {
      showLoading = true;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var course = sharedPreferences.getString('course');
    var uri = Uri.parse('$baseUrl/instituteDetailsByCourseAndId/?id=${widget.id}&course=$course');
    var response = await client.get(uri);
    Map info;
    info = json.decode(response.body);
    List data = info["data"];
    Map entries = data[0];
    name = entries["name"];
    location = entries["city"];
    state = entries["state"];
    country = entries["country"];
    zipcode = entries["zipcode"];
    email = entries["email"];
    center = entries["center_location"];
    logo = entries["logo"];
    fees = entries["fees"];
    faculty = entries["faculty"];
    subjects = entries["subjects"];
    topRankers = entries["topRankers"];
    scholarship = entries["scholarship"];
    selectionData = entries["selectionData"];
    setShortlisted();
    setFees();
    setFaculties();
    setSubjects();
    setRankers();
    setScholarship();
    setSelectionData();
    setDataVisibility();
    setState(() {
      showLoading = false;
    });
  }

  Future<dynamic> showAlertDialog() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Book Your Seat"),
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("By Booking your seat from AfterSchool, you get advantage of :"),
                  SizedBox(height: 10),
                  Text("1. Full scholarship on complete Fee amount if selected in the competition you are appearing for (IIT/NEET)"),
                  SizedBox(height: 10),
                  Text("2. Education Loan at 0% Interest (T&C applied)"),
                  SizedBox(height: 10),
                  Text("3. Access to our carefully crafted Edge Learning"),
                  SizedBox(height: 10),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () { Navigator.pop(context); },
                  child: const Text(
                    "That's Amazing!!!",
                    style: TextStyle(
                        color: Color(0xff6633ff)
                    ),
                  ))
            ],
          );
        }
    );
  }

  void onBooking() {

  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.coachingName),
        backgroundColor: const Color(0xff6633ff),
        actions: [
          IconButton(
              onPressed: onShortlistTapped,
              icon:  Icon(
                showShortlisted? Icons.star_outlined :
                Icons.star_outline ),
                color: Colors.white,
              )
        ],
      ),
      body: showLoading? const Center(child: CircularProgressIndicator()) :
      ListView(
        children: [
          Container(
            height: height,
            child: DefaultTabController(
                length: 2,
                child: Scaffold(
                  backgroundColor: Colors.white,
                    body: Column(
                      children: [
                        const TabBar(
                            labelColor: Color(0xff6633ff),
                            unselectedLabelColor: Colors.grey,
                            indicatorColor: Color(0xff6633ff),
                            tabs: [
                              Tab(
                                text: "Details",
                              ),
                              Tab(
                                text: "Admission",
                              )
                            ]),
                        Expanded(
                          child: TabBarView(
                            children: [
                              /* details tab */
                              ListView(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 120,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                          child: Image.network(logo),
                                        ),
                                        const SizedBox(height: 20),
                                        Container(
                                          padding: const EdgeInsets.all(20),
                                          decoration:   BoxDecoration(
                                            borderRadius: const BorderRadius.all(Radius.circular(20)),
                                            border: Border.all(color: const Color(0xff6633ff)),
                                            color: const Color(0xffeeeeff),
                                          ),
                                          child: Column(
                                            children: [
                                              const Center(
                                                child: Text(
                                                  "City",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Color(0xff6633ff)
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 3),
                                              Center(
                                                child: Text(
                                                  location,
                                                  style: const TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.black
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              const Center(
                                                child: Text(
                                                  "Center Location",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Color(0xff6633ff)
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 3),
                                              Center(
                                                child: SizedBox(
                                                  width: width*0.7,
                                                  child: Text(
                                                    center,
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.black,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              const Center(
                                                child: Text(
                                                  "State",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Color(0xff6633ff)
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 3),
                                              Center(
                                                child: Text(
                                                  state,
                                                  style: const TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.black
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 40),
                                        if(isFaculty) const Text(
                                              "Faculties",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Color(0xff6633ff)
                                              ),
                                        ),
                                        const SizedBox(height: 10),
                                        ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: facultyData.length,
                                            itemBuilder: (BuildContext context, int index) {
                                              return FacultyView(
                                                  name: facultyData[index].name,
                                                  image: facultyData[index].image,
                                                  subject: facultyData[index].subject,
                                                  qual: facultyData[index].qual,
                                                  exp: facultyData[index].experience
                                              );
                                            }
                                        ),
                                        if(isTotalSelection) const SizedBox(height: 40),
                                        if(isTotalSelection) Center(
                                          child:
                                              Container(
                                                margin: const EdgeInsets.only(left: 15, right: 15),
                                                padding: const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                                                  border: Border.all(color: const Color(0xff6633ff))
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    const Text(
                                                      "Total Selections: ",
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                          color: Color(0xff6633ff)
                                                      ),
                                                    ),
                                                    Text(
                                                      totalSelections.toString(),
                                                      style: const TextStyle(
                                                        fontSize: 20,
                                                        color: Color(0xff6633ff)
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                        ),
                                        if(isTotalSelection) const SizedBox(height: 30),
                                        if(isTop100 || isTop200 || isTop500 || isTop100) Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            if(isTop100) Column(
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.all(18),
                                                  decoration: const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Color(0xff6633ff),
                                                  ),
                                                  child: Text(
                                                    top100.toString(),
                                                    style: const TextStyle(
                                                        color: Colors.white
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                const Text("In Top 100")
                                              ]
                                            ),
                                            if(isTop200) Column(
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets.all(18),
                                                    decoration: const BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Color(0xff6633ff),
                                                    ),
                                                    child: Text(
                                                      top100.toString(),
                                                      style: const TextStyle(
                                                          color: Colors.white
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  const Text("In Top 200")
                                                ]
                                            ),
                                            if(isTop500) Column(
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets.all(18),
                                                    decoration: const BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Color(0xff6633ff),
                                                    ),
                                                    child: Text(
                                                      top100.toString(),
                                                      style: const TextStyle(
                                                          color: Colors.white
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  const Text("In Top 500")
                                                ]
                                            ),
                                            if(isTop1000) Column(
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets.all(18),
                                                    decoration: const BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Color(0xff6633ff),
                                                    ),
                                                    child: Text(
                                                      top100.toString(),
                                                      style: const TextStyle(
                                                          color: Colors.white
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  const Text("In Top 1000")
                                                ]
                                            ),
                                          ],
                                        ),
                                        if(isTotalSelection) const SizedBox(height: 20),
                                        if(isRankers) const Center(
                                          child: Text(
                                            "Rankers Info",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Color(0xff6633ff)
                                            ),
                                          ),
                                        ),
                                        ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount: rankerData.length,
                                                  itemBuilder: (BuildContext context, int index) {
                                                    return RankerView(
                                                        name: rankerData[index].name,
                                                        image: rankerData[index].image,
                                                        rank: rankerData[index].rank
                                                    );
                                                  }
                                                  ),
                                        Text("text after faculty widget"),
                                      ],
                                    ),
                                  ),
                                ]
                              ),


                              /* Admission Tab */
                              ListView(
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(top:20),
                                        padding: const EdgeInsets.all(10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            const Text(
                                                "Fee Structure:",
                                              style: TextStyle(
                                                fontSize: 16
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.all(0),
                                              height: 35,
                                              //margin: const EdgeInsets.all(13),
                                              decoration: const BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                                  color: Color(0xff9999ff)
                                              ),
                                              //padding: const EdgeInsets.all(5),
                                              width: width*0.6,
                                              child: DropdownButtonFormField<String>(
                                                  icon: const Icon(
                                                    Icons.keyboard_arrow_down_outlined,
                                                    color: Colors.white,
                                                  ),
                                                  dropdownColor: const Color(0xff6633ff),
                                                  items: feeView.map((String choice) {
                                                    return DropdownMenuItem<String>(
                                                      value: choice,
                                                      child: Text(choice),
                                                    );
                                                  }).toList(),
                                                  value: currentSelected,
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.white
                                                  ),
                                                  onChanged: (selectedValueNew) {
                                                    setState(()  {
                                                      currentSelected = selectedValueNew as String;
                                                    });
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
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(top:20),
                                        padding: const EdgeInsets.all(30),
                                        width: width*0.8,
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(20)),
                                          color: Color(0xff6633ff),
                                        ),
                                        child: Text(
                                          "Rs. ${feeInfo[currentSelected].toString()}",
                                          style: const TextStyle(
                                            fontSize: 20,
                                            color: Colors.white
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      SizedBox(
                                        width: width*0.95,
                                        child: const Text(
                                          "Fees shown above is subject to vary with respect to marks scored in the Boards or if any scholarship is applicable. Final fees shall be confirmed by institute only.",
                                          style:  TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      const SizedBox(height: 30),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                              "Book Your Seat",
                                            style: TextStyle(
                                              fontSize: 20
                                            ),
                                          ),
                                          IconButton(
                                                onPressed: showAlertDialog,
                                                icon: const Icon(
                                                  Icons.info,
                                                  color: Color(0xffff9900),
                                                )
                                            ),
                                        ],
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(20),
                                        width: width,
                                        decoration: const BoxDecoration(
                                          color: Color(0xff9999ff)
                                        ),
                                        child: Column(
                                          children: const [
                                            Text(
                                                "Rs. 4999/- only",
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold
                                              ),
                                            ),
                                            SizedBox(height: 20),
                                            Text(
                                              "This amount will be adjusted when you pay the fees to the Institute.",
                                              style: TextStyle(
                                                fontSize: 16,
                                              ),
                                              textAlign: TextAlign.center,
                                            )
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      ElevatedButton(
                                          onPressed: onBooking,
                                          style: ButtonStyle(
                                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20),
                                              )
                                            ),
                                            backgroundColor: MaterialStateProperty.all<Color>(const Color(0xffff9900))
                                          ),
                                          child: const Text(
                                            "BOOK NOW",
                                            style: TextStyle(
                                              fontSize: 20
                                            ),
                                          )
                                      )
                                    ],
                                  )
                                ]
                              )
                                      ],
                                    ),)
                                  ],
                                ),
                              ),
                          ),
          ),
                    ],
                  ),
            );
  }
}

class Faculty {
  final String name;
  final String image;
  final String qual;
  final int experience;
  final String subject;
  Faculty(this.name, this.image, this.qual, this.experience, this.subject);
}

class Subject {
  final String sub;
  final List demoVideos;
  Subject(this.sub, this.demoVideos);
}

class Ranker {
  final String name;
  final int rank;
  final String image;
  Ranker(this.name, this.rank, this.image);
}

class FacultyView extends StatefulWidget {
  final String name;
  final String image;
  final String subject;
  final String qual;
  final int exp;
  const FacultyView({Key? key, required this.name, required this.image,
  required this.subject, required this.qual, required this.exp}) : super(key: key);

  @override
  State<FacultyView> createState() => _FacultyViewState();
}

class _FacultyViewState extends State<FacultyView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children:[
          CircleAvatar(
            backgroundImage: NetworkImage(widget.image),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${widget.name} (${widget.qual})",
                style: const TextStyle(
                  fontSize: 18
                ),
              ),
              Text("Subject: ${widget.subject} (Exp: ${widget.exp} years)")
            ]
        ),]
      ),
    );
  }
}

class RankerView extends StatefulWidget {
  final String name;
  final String image;
  final int rank;
  const RankerView({Key? key, required this.name, required this.image,
  required this.rank}) : super(key: key);

  @override
  State<RankerView> createState() => _RankerViewState();
}

class _RankerViewState extends State<RankerView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children:[
            CircleAvatar(
              backgroundImage: NetworkImage(widget.image),
            ),
            const SizedBox(width: 20),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: const TextStyle(
                        fontSize: 18
                    ),
                  ),
                  Text("AIR: ${widget.rank}")
                ]
            ),]
      ),
    );
  }
}

