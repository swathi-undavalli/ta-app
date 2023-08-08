import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:temple_adventures/features/boat/models/boats.dart';
import 'package:temple_adventures/features/boat/presentation/widgets/boat-details-bottomSheet.dart';
import 'package:intl/intl.dart';

class BoatSelector extends StatefulWidget {
  const BoatSelector(
      {Key? key,
      required this.selectedDate,
      required this.selectedBoatId,
      required this.onChanged})
      : super(key: key);

  final String selectedBoatId;
  final DateTime selectedDate;
  final Function(Boat? boatDetails) onChanged;

  @override
  State<BoatSelector> createState() => _BoatSelectorState();
}

class _BoatSelectorState extends State<BoatSelector> {
  List<Boat> allBoats = [];
  Boat? selectedBoat;

  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init() async {
    var d = await FirebaseFirestore.instance
        .collection("dailyBoats")
        .doc(DateFormat("dd-MM-yyyy").format(widget.selectedDate))
        .get();
    Map<String, dynamic>? data = d.data();
    BoatsModel? boatsModel = BoatsModel.fromMap(data);
    allBoats = boatsModel.boats ?? [];
    allBoats.forEach((boat) {
      if (boat.id == widget.selectedBoatId) {
        selectedBoat = boat;
      }
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Boat>(
      child: (selectedBoat == null)
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Selected Boat :",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        // decoration: TextDecoration.underline
                      ),
                    ).paddingAll(5),
                    Text(
                      "Change",
                      style: TextStyle(
                          fontSize: 10,
                          color: Colors.blue,
                          decoration: TextDecoration.underline),
                    ).paddingOnly(left: 5, right: 5),
                    Icon(
                      Icons.edit,
                      size: 10,
                      color: Colors.blue,
                    ),
                  ],
                ),
                Text(
                  "${selectedBoat?.name} @ ${selectedBoat?.time}",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                    // fontWeight: FontWeight.bold,
                  ),
                ).paddingAll(5),
              ],
            ),
      itemBuilder: (BuildContext context) {
        return [
          ...allBoats.map(
            (Boat boat) => PopupMenuItem<Boat>(
              value: boat,
              onTap: () {
                setState(() {
                  widget.onChanged(boat);
                });
              },
              child: Text(
                "${boat.name} @ ${boat.time}",
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
          if (selectedBoat != null)
            PopupMenuItem<Boat>(
              value: Boat(
                id: "Un-assign",
                captains: [],
                name: '',
                surfaceSupport: [],
                notes: '',
                nitrox: 0,
                air: 0,
                time: '',
                diveSite: '',
                dsdInstructors: [],
                photographer: [],
                boatStatus: 0,
                internPhotographer: [],
                internSurfaceSupport: [],
                showBoat: null,
              ),
              onTap: () {},
              child: Column(
                children: [
                  Divider(
                    color: Colors.black26,
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Un-Assign Boat",
                    style: TextStyle(fontSize: 12),
                  ).paddingOnly(bottom: 2),
                ],
              ),
            ),
          PopupMenuItem<Boat>(
            value: Boat(
              id: "Add new",
              captains: [],
              name: '',
              surfaceSupport: [],
              notes: '',
              nitrox: 0,
              air: 0,
              time: '',
              diveSite: '',
              dsdInstructors: [],
              photographer: [],
              boatStatus: 0,
              internPhotographer: [],
              internSurfaceSupport: [],
              showBoat: true,
            ),
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
      onSelected: (Boat value) async {
        if (value.id == "Add new") {
          BoatsModel? boatsModel = await BoatDetailsBottomSheet.show(context,
              date: widget.selectedDate, isBoatEdit: false);

          if (boatsModel != null) {
            await FirebaseFirestore.instance
                .collection("dailyBoats")
                .doc(DateFormat("dd-MM-yyyy").format(widget.selectedDate))
                .set(boatsModel.toMap());
            init();
          }
        } else if (value.id == "Un-assign") {
          setState(() {
            widget.onChanged(null);
          });
        }
      },
    );
  }
}
