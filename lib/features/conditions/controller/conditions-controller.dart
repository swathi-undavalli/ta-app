import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/features/conditions/repositories/conditions-repository.dart';

import '../../bookings/presentation/widgets/app-text-fields.dart';
import '../models/conditions-model.dart';
import '../screens/add-conditions-screen.dart';

class ConditionsLogic {
  ConditionsController controller = Get.put(ConditionsController());
  ConditionsRepository conditionsRepo = ConditionsRepository();

  Future<void> init() async {
    controller.showLoading = true;
    controller.selectedDate = DateTime.now();
    await getLatestConditions();
    controller.showLoading = false;
  }

  getLatestConditions() async {
    controller.conditions =
        await conditionsRepo.getConditions(controller.selectedDate);
    // if (controller.conditions != null) {
    //   log(controller.conditions!.toMap().toString());
    // }
    // }
  }

  void onFloatingActionButtonPressed() {
    Get.toNamed(AddConditionsScreen.id, arguments: controller.selectedReef);
  }

  List<Level> get getLevels {
    if (controller.conditions == null ||
        controller.conditions!.levels.isEmpty) {
      return [];
    }

    List<Level> levels = [];

    controller.conditions!.levels.forEach((element) {
      if (element.reef == controller.selectedReef) {
        levels.add(element);
      }
    });
    levels.sort((a, b) => a.depth.compareTo(b.depth));

    return levels;
  }

  onChipChanged(String reefName) {
    controller.selectedReef = reefName;
    controller.update();
  }
}

class ConditionsController extends GetxController {
  DateTime selectedDate = DateTime.now();
  late String selectedReef = reefs[0];
  bool _showLoading = true;
  Conditions? conditions;
  Conditions? conditionsViaReef;

  List<String> reefs = [
    "Shallow site area",
    "Northern Rocks area",
    "Wall area"
  ];

  bool get showLoading => _showLoading;

  set showLoading(bool value) {
    _showLoading = value;
    update();
  }
}

class ExpandableListTile extends StatefulWidget {
  const ExpandableListTile({
    Key? key,
    required this.expandedChild,
    required this.title,
    required this.color,
  }) : super(key: key);

  final String title;
  final Widget expandedChild;
  final Color color;

  @override
  State<ExpandableListTile> createState() => _ExpandableListTileState();
}

class _ExpandableListTileState extends State<ExpandableListTile> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      curve: Curves.easeInCubic,
      alignment: Alignment.topCenter,
      constraints: BoxConstraints(
        minHeight: isExpanded ? 500 : 50,
      ),
      width: Get.width,
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: Get.width - 200,
                  child: Text(
                    widget.title,
                    style: TextStyle(
                        color: AppColors.text.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Spacer(),
                IconButton(
                  splashRadius: 20,
                  icon: Icon(isExpanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded),
                  onPressed: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                ),
              ],
            ).paddingSymmetric(vertical: 3),
            isExpanded
                ? FutureBuilder(
                    future: Future.delayed(Duration(milliseconds: 200)),
                    initialData: SizedBox(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return widget.expandedChild
                            .paddingSymmetric(horizontal: 15);
                      }
                      return SizedBox();
                    })
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}

class BookingStatus extends StatefulWidget {
  const BookingStatus(
      {Key? key, required this.initialStatus, required this.onChanged})
      : super(key: key);
  final int initialStatus;
  final Function(int status) onChanged;

  @override
  State<BookingStatus> createState() => _BookingStatusState();
}

class _BookingStatusState extends State<BookingStatus> {
  int status = 0;

  @override
  void initState() {
    status = widget.initialStatus;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            if (status > 0 && status <= 4) {
              status -= 1;

              widget.onChanged(status);
              setState(() {});
            }
          },
          child: Container(
            height: 33,
            width: 27,
            decoration: BoxDecoration(
              color: getProgressColor(status),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4), bottomLeft: Radius.circular(4)),
            ),
            child: Icon(
              Icons.arrow_left,
              size: 16,
            ),
          ),
        ),
        SizedBox(width: 2),
        Container(
          height: 33,
          decoration: BoxDecoration(
            color: getProgressColor(status),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4), bottomLeft: Radius.circular(4)),
          ),
          child: Text(
            bookingStatus[status],
            style: TextStyle(
                fontSize: FontSize.small, fontWeight: FontWeight.w600),
          ).paddingOnly(left: 15, right: 15, top: 8),
        ),
        SizedBox(width: 2),
        GestureDetector(
          onTap: () {
            if (status < 4) {
              status += 1;

              widget.onChanged(status);
              setState(() {});
            }
          },
          child: Container(
            height: 33,
            width: 27,
            decoration: BoxDecoration(
              color: getProgressColor(status),
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(4),
                  bottomRight: Radius.circular(4)),
            ),
            child: Icon(
              Icons.arrow_right,
              size: 16,
            ),
          ),
        )
      ],
    );
  }

  Color getProgressColor(int index) {
    if (index == 0) {
      return Colors.white70;
    } else if (index == 1) {
      return Colors.black26;
    } else if (index == 2) {
      return AppColors.text.skyBlue.withOpacity(0.5);
    } else if (index == 3) {
      return Colors.red.withOpacity(0.7);
    } else if (index == 4) {
      return Colors.yellow.withOpacity(0.7);
    } else {
      return Colors.white70;
    }
  }

  List<String> bookingStatus = [
    "Booking Done",
    "Paper work",
    "Pool Session",
    "Dive Session",
    "Left Dive Center"
  ];
}

class BoatSelector extends StatefulWidget {
  const BoatSelector({Key? key}) : super(key: key);

  @override
  State<BoatSelector> createState() => _BoatSelectorState();
}

class _BoatSelectorState extends State<BoatSelector> {
  List<String> allBoats = [
    "Tucy",
    "007",
    "Batman",
    "Ranga",
    "Traveller",
    "Class Room",
  ];

  TextEditingController boatTED = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      child: (boatTED.text == "")
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
                      boatTED.text,
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
              value: e,
              onTap: () {
                setState(() {
                  boatTED.text = e;
                });
              },
              child: Text(
                e,
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
          showTextFieldDialog(context);
        }
      },
    );
  }

  void showTextFieldDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Boat'),
          content: AppTextField(
            controller: TextEditingController(),
            hintText: "Add",
            errorValidator: () {
              return null;
            },
            validator: (_) {
              return null;
            },
          ),
          actions: [
            TextButton(
              child: Text('Cancel', style: TextStyle(color: Colors.black)),
              onPressed: () {
                Get.back();
              },
            ),
            TextButton(
              child: Text('Ok', style: TextStyle(color: Colors.black)),
              onPressed: () {},
            ),
          ],
        );
      },
    );
  }
}
