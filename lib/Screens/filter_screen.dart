import 'dart:convert';

import 'package:afterschool/Screens/multiple_location_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({Key? key}) : super(key: key);

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {

  var baseUrl = 'https://afterschoolcareer.com:8080';
  List populate = [];
  var client = http.Client();
  int selectedValue = 0;
  List<String> selectedItems = [];
  bool showData = false;
  bool showButton = false;

  void locationList() async {
    final List<String> locations = ["Delhi","Kota","Ranchi","Patna"];
    
    final List<String>? results = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return LocationMultiSelect(items: locations);
        });

    if(results != null) {
      setState(() {
        selectedItems = results;
        showData = false;
        showButton = true;
      });
    }
  }

  void onShowData() async {
    if(selectedItems.isEmpty) return;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var course = sharedPreferences.getString('course');
    String locationQuery = "";
    for(int i=0;i<selectedItems.length;i++) {
      locationQuery+="${selectedItems[i]},";
    }
    var uri = Uri.parse('$baseUrl/getInstituteBycities/?city=$locationQuery&course=$course');
    var response = await client.get(uri);
    Map data;
    data = json.decode(response.body);
    List multipleLocationList = data["data"];
    populateData(multipleLocationList);
    setState(() {
      showData = true;
      showButton = false;
    });
  }

  void populateData(List data) {
    populate.clear();
    for(int i=0;i<data.length;i++) {
      Map info = data[i];
      populate.add(MultipleLocationList(info["id"], info["name"], info["city"], info["logo"]));
    }
  }
  
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Preference Filters"),
        backgroundColor: const Color(0xff6633ff),
      ),
      body:
          Container(
            padding: const EdgeInsets.only(top:30),
            child: Column(
              children: [
                    InkWell(
                        onTap: locationList,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          height: 40,
                          width: width/1.5,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                    color: Color(0xff9999ff),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: Offset(0, 0)
                                )
                              ]
                          ),
                          child: const Text(
                              "Set your location Preference",
                            textAlign: TextAlign.center
                          ),
                        )
                    ),
                    const Divider(height: 30),
                    Wrap(
                      spacing: 10,
                      children: selectedItems.map(
                              (e) => Chip(
                                label: Text(e),
                              )
                      ).toList(),
                    ),
                const Divider(height: 30),
                Visibility(
                  visible: showButton,
                  child: InkWell(
                    onTap: onShowData,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: selectedItems.isEmpty
                            ? Colors.grey : const Color(0xff6633ff))
                      ),
                      child: Icon(
                        Icons.keyboard_arrow_right,
                        color: selectedItems.isEmpty
                            ? Colors.grey : const Color(0xff6633ff),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: showData,
                    child:
                          Expanded(
                            child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: populate.length,
                            itemBuilder: (BuildContext context, int index) {
                              return MultipleLocationCard(
                                name: populate[index].name,
                                location: populate[index].location,
                                logo: populate[index].logo,
                                id: populate[index].id,
                              );
                            }
                      ),
                          ),
                    ),
              ],
            ),
          )
    );
  }
}

class LocationMultiSelect extends StatefulWidget {
  final List<String> items;
  const LocationMultiSelect({Key? key, required this.items}) : super(key: key);

  @override
  State<LocationMultiSelect> createState() => _LocationMultiSelectState();
}

class _LocationMultiSelectState extends State<LocationMultiSelect> {

  final List<String> selectedItems = [];

  void itemChange(String itemValue, bool isSelected) {
    setState(() {
      if(isSelected) {
        selectedItems.add(itemValue);
      } else {
        selectedItems.remove(itemValue);
      }
    });
  }

  void cancel() {
    Navigator.pop(context);
  }

  void submit() {
    Navigator.pop(context, selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Select Locations"),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.items
              .map((item) => CheckboxListTile(
              value: selectedItems.contains(item),
              title: Text(item),
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (isChecked) => itemChange(item, isChecked!)
          )).toList(),
        ),
      ),
      actions: [
        TextButton(
            onPressed: cancel,
            child: const Text("Cancel")
        ),
        ElevatedButton(
            onPressed: submit,
            child: const Text("Select")
        )
      ],
    );
  }
}

class MultipleLocationList {
  final int id;
  final String name;
  final String location;
  final String logo;
  MultipleLocationList(this.id, this.name, this.location, this.logo);
}
