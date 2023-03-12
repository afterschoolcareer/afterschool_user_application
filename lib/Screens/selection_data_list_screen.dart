import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//TO BE IMPLEMENTED LATER - PLEASE DON'T EDIT
class SelectionDataListScreen extends StatefulWidget {
  final List data;
  const SelectionDataListScreen({Key? key, required this.data}) : super(key: key);

  @override
  State<SelectionDataListScreen> createState() => _SelectionDataListScreenState();
}

class _SelectionDataListScreenState extends State<SelectionDataListScreen> {

  List<SelectionData> populate = [];
  @override
  void initState() {
    List data = widget.data;
    for(int i=0;i<data.length;i++) {
      Map info = data[i];
      populate.add(SelectionData(
          info["id"],
          info["name"],
          info["logo"],
          info["city"],
          info["no_of_selections"],
          info["Top100"],
          info["Top200"],
          info["Top500"],
          info["Top1000"]
      ));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Selection Data"),
      ),
    );
  }
}

class SelectionData {
  final int id;
  final String name;
  final String logo;
  final String location;
  final int total;
  final int top100;
  final int top200;
  final int top500;
  final int top1000;
  SelectionData(this.id, this.name, this.logo, this.location, this.total, this.top100,
      this.top200, this.top500, this.top1000);
}
