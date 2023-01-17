import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../home.dart';

class SignupDetails extends StatefulWidget {
  const SignupDetails({Key? key}) : super(key: key);

  @override
  State<SignupDetails> createState() => _SignupDetailsState();
}

class _SignupDetailsState extends State<SignupDetails> {
  int selectedValue = 0;
  var course_choices = ['IIT-JEE','NEET','Others'];
  var currentSelected = 'IIT-JEE';
  bool isSelected = false;
  void onCompleteSignup() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const HomeScreen()));
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    return Scaffold(
        backgroundColor: const Color(0xff6633ff),
        body: ListView(children: [
          Container(
            padding: EdgeInsets.only(
                top: height / 15, left: width / 10, right: width / 10),
            child: Column(
              children: const [
                Text(
                  "Please enter the following additional details so that we can know more about you.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
            height: 660,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Column(
              children: [
                const TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.email,
                      color: Color(0xff6633ff),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.all(
                          Radius.circular(20.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color(0xff6633ff)),
                      borderRadius: BorderRadius.all(
                          Radius.circular(20.0)),
                    ),
                    hintText: "Enter your Email Address",
                  ),
                ),
                const SizedBox(height: 40),
                const Text(
                  "I'm a :",
                  style: TextStyle(
                    color: Color(0xff6633ff),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.only(left: width/10),
                  child: Column(
                    children: [
                      RadioListTile(
                        activeColor: const Color(0xff6633ff),
                        value: 1,
                        groupValue: selectedValue,
                        title: const Text('10th Passout'),
                        onChanged: (value) => setState(() => selectedValue = 1),
                      ),
                      RadioListTile(
                        activeColor: const Color(0xff6633ff),
                        value: 2,
                        groupValue: selectedValue,
                        title: const Text('11th Passout'),
                        onChanged: (value) => setState(() => selectedValue = 2),
                      ),
                      RadioListTile(
                        activeColor: const Color(0xff6633ff),
                        value: 3,
                        groupValue: selectedValue,
                        title: const Text('12th Passout'),
                        onChanged: (value) => setState(() => selectedValue = 3),
                      ),
                      RadioListTile(
                        activeColor: const Color(0xff6633ff),
                        value: 4,
                        groupValue: selectedValue,
                        title: const Text('12th Passout'),
                        subtitle: const Text('Drop Out - Repeating'),
                        onChanged: (value) => setState(() => selectedValue = 4),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                const Text(
                  "I'm looking for :",
                  style: TextStyle(
                    color: Color(0xff6633ff),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  icon: const Icon(
                    Icons.arrow_drop_down_circle,
                    color: Color(0xff6633ff),
                  ),
                    dropdownColor: Colors.white,
                    items: course_choices.map((String choice) {
                      return DropdownMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                      );
                    }).toList(),
                    value: currentSelected,
                    onChanged: (selectedValueNew) {
                      setState(() => currentSelected = selectedValueNew as String);
                    },
                  decoration: const InputDecoration(
                    labelText: "Select Course",
                    labelStyle: TextStyle(
                      color: Color(0xff6633ff),
                    ),
                    prefixIcon: Icon(
                      Icons.book,
                      color: Color(0xff6633ff),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.all(
                          Radius.circular(20.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color(0xff6633ff)),
                      borderRadius: BorderRadius.all(
                          Radius.circular(20.0)),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                InkWell(
                  onTap: onCompleteSignup,
                  child: Container(
                    height: 50,
                    width: 150,
                    decoration: BoxDecoration(
                        color: const Color(0xff6633ff),
                        borderRadius:
                        BorderRadius.circular(20)),
                    child: const Icon(
                      Icons.arrow_forward_outlined,
                      color: Colors.white,
                    ),
                  ),
                ),

              ],
            ),
          )

        ]));
  }
}
