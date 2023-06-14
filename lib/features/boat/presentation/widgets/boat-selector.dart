import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:temple_adventures/features/boat/models/boat-model.dart';
import 'package:temple_adventures/features/boat/presentation/widgets/boat-details-bottomSheet.dart';
import 'package:temple_adventures/features/conditions/controller/conditions-controller.dart';

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
  List<BoatsModel> allBoats = [
    BoatsModel(
      id: "1",
      boatName: "Tucy",
      captainId: "Das",
      capacity: 30,
    ),
    BoatsModel(
      id: "2",
      boatName: "Ranga",
      captainId: "Das",
      capacity: 30,
    ),
    BoatsModel(
      id: "3",
      boatName: "BatMan",
      captainId: "Das",
      capacity: 30,
    ),
    BoatsModel(
      id: "4",
      boatName: "007",
      captainId: "Das",
      capacity: 30,
    ),
    BoatsModel(
      id: "5",
      boatName: "ClassRoom",
      captainId: "Das",
      capacity: 30,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      child: (widget.boatName == "")
          ? Column(
              children: [
                Container(
                  height: 31,
                  width: 100,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20)),
                  child: Center(
                    child: Text("Select Boat",
                        style: TextStyle(fontSize: 12, color: Colors.white)),
                  ),
                ),
              ],
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
                    ).paddingOnly(left: 10, right: 7),
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
          ...allBoats.map(
            (e) => PopupMenuItem<String>(
              value: e.boatName,
              onTap: () {
                setState(() {
                  widget.onChanged([e.id!, e.boatName!]);
                });
              },
              child: Text(
                e.boatName!,
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
      onSelected: (String value) {
        if (value == 'Add custom') {
          BoatDetailsBottomSheet.show(context, date: widget.selectedDate);
        }
      },
    );
  }
}
