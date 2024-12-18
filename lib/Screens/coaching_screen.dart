import 'dart:convert';

import 'dart:developer';
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../Homescreen/main_screen.dart';

class CoachingScreen extends StatefulWidget {
  final int id;
  final String coachingName;
  const CoachingScreen({Key? key, required this.id, required this.coachingName}) : super(key: key);

  @override
  State<CoachingScreen> createState() => _CoachingScreenState();
}

class _CoachingScreenState extends State<CoachingScreen> {

  int instituteImagesIndex = 0;

  String name = "";
  String location = "";
  String state = "";
  String country = "";
  String zipcode = "";
  String email = "";
  String center = "";
  String logo = "";
  String prospectus = "";
  List fees = [];
  List faculty = [];
  List subjects = [];
  List topRankers = [];
  List scholarship = [];
  List selectionData = [];
  List instituteImages = [];

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
  bool isRegistered = false;
  bool isProspectus = true;
  bool isImages = true;

  bool showShortlisted = false;
  bool showLoading = false;
  bool isBooked = false;
  bool isInterestShown = false;

  double? downloadProgress;

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
    setInterestInfo();
    setBookingInfo();
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
    if(prospectus.isEmpty || prospectus.toLowerCase().contains("none")) {
      isProspectus = false;
    }
    if(instituteImages.isEmpty) {
      isImages = false;
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
    isRegistered = entries["is_registered"];
    prospectus = entries["prospectus"];
    instituteImages = entries["image_link"];
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

  void setInterestInfo() async {
    setState(() {
      showLoading = true;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var number = sharedPreferences.getString('phone_number');
    var uri = Uri.parse('$baseUrl/getAllInterestForStudent/?phone_number=$number');
    var response = await client.get(uri);
    Map data;
    data = json.decode(response.body);
    List allData = data["data"];
    for(int i=0;i<allData.length;i++) {
      Map info = allData[i];
      int id = info["institute_id"];
      if(widget.id == id) {
        setState(() {
          isInterestShown = true;
        });
      }
    }
  }


  void setBookingInfo() async {
    setState(() {
      showLoading= true;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var number = sharedPreferences.getString('phone_number');
    var uri = Uri.parse('$baseUrl/getAllBookings/?phone_number=$number');
    var response = await client.get(uri);
    Map data;
    data = json.decode(response.body);
    List allData = data["data"];
    for(int i=0;i<allData.length;i++) {
      Map info = allData[i];
      int id = info["institute_id"];
      if(widget.id == id) {
          setState(() {
            isBooked = true;
          });
      }
    }
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

  Future<dynamic> bookingDialog() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Book Your Seat"),
            content: Container(
              child: const Text("Are you sure you want to book your seat? Institue will process your data and contact you within 3 working days for further admission process.")
            ),
            actions: [
              TextButton(
                  onPressed: () { Navigator.pop(context); },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                        color: Colors.black45
                    ),
                  )),
              TextButton(
                  onPressed: onBooking,
                  child: const Text("BOOK",
          style: TextStyle(
          color: Color(0xff6633ff),
          )
          ),
              )
            ],
          );
        }
    );
  }

  void onBooking() async {
    Navigator.pop(context);
    setState(() {
      showLoading = true;
    });
    SharedPreferences sharedPreferences = await  SharedPreferences.getInstance();
    var phoneNumber = sharedPreferences.getString('phone_number');
    var uri = Uri.parse('$baseUrl/booknow/?phone_number=$phoneNumber&paid_amount=0&institute_id=${widget.id}');
    var response = await client.get(uri);
    Map data;
    data = json.decode(response.body);
    String status = data["data"];
    setState(() {
      if(status == "success") {
        isBooked = true;
      } else {
        showErrorDialog();
      }
        showLoading = false;
    });
  }

  void onInterest() async {
    Navigator.pop(context);
    setState(() {
      showLoading = true;
    });
    SharedPreferences sharedPreferences = await  SharedPreferences.getInstance();
    var phoneNumber = sharedPreferences.getString('phone_number');
    var course = sharedPreferences.getString('course');
    var now = DateTime.now();
    DateTime date = DateTime(now.year,now.month,now.day);
    String dateFormat = date.toString();
    var uri = Uri.parse('$baseUrl/showinterest/?phone_number=$phoneNumber&id=${widget.id}&course=$course&date=$dateFormat');
    var response = await client.get(uri);
    Map data = json.decode(response.body);
    String status = data["data"];
    setState(() {
      if(status == "success") {
        isInterestShown = true;
      } else {
        showErrorDialog();
      }
      showLoading = false;
    });
  }

  Future<dynamic> showErrorDialog() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return  AlertDialog(
            title: const Text("Error"),
            content: const Text("There was a technical error. Please try again after some time."),
            actions: [
              TextButton(
                  onPressed: () { Navigator.pop(context); },
                  child: const Text(
                    "OK",
                    style: TextStyle(
                        color: Color(0xff6633ff)
                    ),
                  ))
            ],
          );
        }
    );
  }

  Future<dynamic> interestDialog() {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return  AlertDialog(
            title: const Text("Show Interest?"),
            content: Text("If you click on OK, we will notify ${widget.coachingName} of your interest. They may contact you for further details but it is not guaranteed."),
            actions: [
              TextButton(
                  onPressed:  onInterest,
                  child: const Text(
                    "OK",
                    style: TextStyle(
                        color: Color(0xff6633ff)
                    ),
                  ))
            ],
          );
        }
    );
  }

  void downloadProspectus() {
    var uri = Uri.parse(prospectus);
    launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return DefaultTabController(
                length: 2,
                child: Scaffold(
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
                    bottom: const TabBar(
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: Colors.white,
                        tabs: [
                          Tab(
                            text: "Details",
                          ),
                          Tab(
                            text: "Admission",
                          )
                        ]),
                  ),
                  backgroundColor: Colors.white,
                  body: showLoading? const Center(child: CircularProgressIndicator(
                    color: Color(0xff6633ff),
                  )) : TabBarView(
                      children: [
                        /* details tab */
                        SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Container(
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
                                if(isImages) const SizedBox(height: 30,),
                                if(isImages) Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        showDialog(context: context, builder: (_) =>
                                        InsImages(url: instituteImages[instituteImagesIndex]));
                                      } ,
                                      child: Container(
                                        width: width,
                                        height: 300,
                                        // child: PhotoViewGallery.builder(
                                        //   scrollPhysics: const BouncingScrollPhysics(),
                                        //   builder: (BuildContext context, int index) {
                                        //     return PhotoViewGalleryPageOptions(
                                        //         imageProvider: NetworkImage(
                                        //           instituteImages[index],
                                        //         ),
                                        //       initialScale: PhotoViewComputedScale.contained,
                                        //     );
                                        //   },
                                        //   itemCount: instituteImages.length,
                                        //   loadingBuilder: (context, event) => Center(
                                        //     child: Container(
                                        //       width: 20,
                                        //       height: 20,
                                        //       child: CircularProgressIndicator(
                                        //         value: event == null
                                        //             ? 0
                                        //             : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
                                        //       ),
                                        //     ),
                                        //   ),
                                        //   backgroundDecoration: const BoxDecoration(
                                        //     color: Colors.white,
                                        //   ),
                                        //   onPageChanged: (int index) {
                                        //     setState(() {
                                        //       instituteImagesIndex =  index;
                                        //     });
                                        //   },
                                        // ),
                                        child: PageView.builder(
                                          onPageChanged: (int index) {
                                            setState(() {
                                              instituteImagesIndex = index;
                                            });
                                          },
                                          itemCount: instituteImages.length,
                                          itemBuilder: (context, index) {
                                            return Image.network(
                                                instituteImages[index],
                                              loadingBuilder: (BuildContext context, Widget child,
                                                  ImageChunkEvent? loadingProgress) {
                                                if (loadingProgress == null) return child;
                                                return Center(
                                                  child: CircularProgressIndicator(
                                                    color: const Color(0xff6633ff),
                                                    value: loadingProgress.expectedTotalBytes != null
                                                        ? loadingProgress.cumulativeBytesLoaded /
                                                        loadingProgress.expectedTotalBytes!
                                                        : null,
                                                  ),
                                                );
                                              },
                                              errorBuilder: (context, exception, stackTrace) {
                                                return const Text("Error Loading Image");
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        ...List.generate(
                                            instituteImages.length,
                                                (index) => Indicator(
                                                isActive: instituteImagesIndex == index ? true : false))
                                      ],
                                    ),
                                  ],
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
                                              top200.toString(),
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
                                              top500.toString(),
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
                                              top1000.toString(),
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
                                if(isRankers) const SizedBox(height: 20),
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
                                const SizedBox(height: 30),
                                if(isProspectus) Container(
                                  padding: const EdgeInsets.all(8),
                                  width: width*0.6,
                                  child: ElevatedButton(
                                      onPressed: downloadProspectus,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xff6633ff)
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          const Text("Download Prospects", style: TextStyle(color: Colors.white),),
                                          downloadProgress == null ? const Icon(Icons.download, color: Colors.white,) :
                                              const CircularProgressIndicator(color: Colors.white,)
                                        ],
                                      )
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),


                        /* Admission Tab */
                        ListView(
                          children: [
                            Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top:20),
                                  padding: const EdgeInsets.only(top:20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const Text(
                                          "Fee Structure:",
                                        style: TextStyle(
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(0),
                                        width: width*0.6,
                                        height: 35,
                                        //margin: const EdgeInsets.all(13),
                                        decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                            color: Color(0xff9999ff)
                                        ),
                                        //padding: const EdgeInsets.all(5),
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
                                    children:  [
                                      const Text(
                                          "BOOK FOR FREE !!",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Text(
                                        "You can secure your admission in ${widget.coachingName} by booking your seat from below. Click on the information icon above to know the benefits of booking from AfterSchool",
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                        textAlign: TextAlign.center,
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Visibility(
                                  visible: !isRegistered,
                                  child: Container(
                                    width: width * 0.95,
                                    margin: const EdgeInsets.only(bottom: 20),
                                    child: Text("This institute does not support Online Admission. You can show your interest in this institute and we will forward your data to check for availability."),
                                  ),
                                ),
                                Visibility(
                                  visible: !isRegistered &&!isInterestShown,
                                  child: ElevatedButton(
                                      onPressed: interestDialog,
                                      style: ButtonStyle(
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20),
                                              )
                                          ),
                                          backgroundColor: MaterialStateProperty.all<Color>(const Color(0xffff9900))
                                      ),
                                      child: const Text(
                                        "SHOW INTEREST",
                                        style:  TextStyle(
                                            fontSize: 20
                                        ),
                                      )
                                  ),
                                ),
                                Visibility(
                                  visible: !isRegistered && isInterestShown,
                                  child: ElevatedButton(
                                      onPressed: () {},
                                      style: ButtonStyle(
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20),
                                              )
                                          ),
                                          backgroundColor: MaterialStateProperty.all<Color>(const Color(0xffff9900))
                                      ),
                                      child: const Text(
                                        "INTEREST SENT TO INSTITUTE",
                                        style:  TextStyle(
                                            fontSize: 20
                                        ),
                                      )
                                  ),
                                ),
                                Visibility(
                                  visible: isRegistered && !isBooked,
                                  child: ElevatedButton(
                                      onPressed: bookingDialog,
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
                                        style:  TextStyle(
                                          fontSize: 20
                                        ),
                                      )
                                  ),
                                ),
                                Visibility(
                                  visible: isBooked,
                                  child: ElevatedButton(
                                      onPressed: () {},
                                      style: ButtonStyle(
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20),
                                              )
                                          ),
                                          backgroundColor: MaterialStateProperty.all<Color>(const Color(0xffff9900))
                                      ),
                                      child: const Text(
                                        "BOOKING SUCCESSFUL",
                                        style:  TextStyle(
                                            fontSize: 20
                                        ),
                                      )
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Visibility(
                                  visible: isBooked,
                                  child: Text(
                                    "You have successfully booked your seat in ${widget.coachingName}. The coaching will contact you within 3 working days. If you receive no communication, please contact us.",
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              ],
                            )
                          ]
                        )
                                ],
                              ),
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

class InsImages extends StatelessWidget {
  final String url;
  const InsImages({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white.withOpacity(0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: PhotoView(
          backgroundDecoration: BoxDecoration(
            color: Colors.white.withOpacity(0)
          ),
          imageProvider: NetworkImage(
            url,
          ),
        ),
      ),
    );
  }
}


