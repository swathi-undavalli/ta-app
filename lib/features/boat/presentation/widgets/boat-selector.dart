import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:temple_adventures/features/boat/models/boats.dart';
import 'package:temple_adventures/features/boat/presentation/widgets/boat-details-bottomSheet.dart';
import 'package:intl/intl.dart';

class BoatSelector extends StatefulWidget {
  const BoatSelector(
      {Key? key,
      required this.boatName,
      required this.selectedDate,
      required this.boatId,
      required this.onChanged})
      : super(key: key);

  final String boatName;
  final String boatId;
  final DateTime selectedDate;
  final Function(List<String> boatDetails) onChanged;
  @override
  State<BoatSelector> createState() => _BoatSelectorState();
}

class _BoatSelectorState extends State<BoatSelector> {
  List<Boat>? allBoats;
  @override
  void initState() {
    initialData();
    super.initState();
  }

  Future<void> initialData() async {
    var d = await FirebaseFirestore.instance
        .collection("dailyBoats")
        .doc(DateFormat("dd-MM-yyyy").format(widget.selectedDate))
        .get();
    Map<String, dynamic>? data = d.data();
    log("data.toString()");
    log(data.toString());
    BoatsModel? boatsModel = BoatsModel.fromJson(data);
    allBoats = boatsModel.boats;
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      child: (widget.boatName == "")
          ? Container(
              height: 31,
              width: 100,
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(20)),
              child: Center(
                child: Text("Select Boat",
                    style: TextStyle(fontSize: 12, color: Colors.white)),
              ),
            )
          : Column(
              children: [
                Text(
                  "Selected Boat :",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    // decoration: TextDecoration.underline
                  ),
                ).paddingAll(5),
                Row(
                  children: [
                    Text(
                      widget.boatName,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        // fontWeight: FontWeight.bold,
                      ),
                    ).paddingAll(5),
                    Text(
                      "Change",
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                          decoration: TextDecoration.underline),
                    ).paddingOnly(left: 5, right: 5),
                    Icon(
                      Icons.edit,
                      size: 12,
                      color: Colors.blue,
                    ),
                  ],
                ),
              ],
            ),
      itemBuilder: (BuildContext context) {
        return [
          if (allBoats != null)
            ...allBoats!.map(
              (e) => PopupMenuItem<String>(
                value: e.name,
                onTap: () {
                  setState(() {
                    widget.onChanged([e.id, e.name]);
                  });
                },
                child: Text(
                  e.name,
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ),
          PopupMenuItem<String>(
            value: "Add custom",
            onTap: () {},
            child: Column(
              children: [
                Divider(
                  color: Colors.black26,
                ),
                SizedBox(height: 5),
                Text(
                  "Add custom",
                  style: TextStyle(fontSize: 12),
                ).paddingOnly(bottom: 2),
              ],
            ),
          ),
        ];
      },
      onSelected: (String value) async {
        if (value == 'Add custom') {
          BoatsModel? boatsModel = await BoatDetailsBottomSheet.show(context,
              date: widget.selectedDate);
          if (boatsModel != null) {
            await FirebaseFirestore.instance
                .collection("dailyBoats")
                .doc(DateFormat("dd-MM-yyyy").format(widget.selectedDate))
                .set(boatsModel.toJson());
            initialData();
          }
        }
      },
    );
  }
}
