import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/access_levels.dart';
import 'package:temple_adventures/core/constants/assets.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/util/ta-image.dart';
import 'package:temple_adventures/features/boat/models/boat-model.dart';
import 'package:temple_adventures/features/boat/presentation/screens/editBoat-page.dart';
import 'package:url_launcher/url_launcher.dart';

class AllBoatsExpansionPanelWidget extends StatefulWidget {
  int boatID;

  AllBoatsExpansionPanelWidget({required this.boatID});

  @override
  State<AllBoatsExpansionPanelWidget> createState() =>
      _AllBoatsExpansionPanelWidgetState();
}

class _AllBoatsExpansionPanelWidgetState
    extends State<AllBoatsExpansionPanelWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection("boats")
            .doc(widget.boatID.toString())
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            BoatsModel boat = BoatsModel.fromMap(snapshot.data!.data()!);
            return Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                curve: Curves.easeInCubic,
                alignment: Alignment.topCenter,
                constraints: BoxConstraints(
                  minHeight: isExpanded ? 400 : 50,
                ),
                width: 350,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  // border: Border.all(color: AppColors.text.grey),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 100,
                                child: Row(
                                  children: [
                                    Text(
                                      boat.boatName!,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: AppColors.text.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    if (!boat.ocean!)
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(
                                          Icons.directions_bus_rounded,
                                          size: 20,
                                          color: AppColors.text.darkgrey,
                                        ),
                                      )
                                  ],
                                ),
                              ),
                              Spacer(),
                              EmployeeAccess(
                                access: AccessRights.editBookings,
                                child: IconButton(
                                  splashRadius: 20,
                                  icon: Icon(Icons.edit,
                                      color: AppColors.background.black),
                                  iconSize: 12,
                                  onPressed: () {
                                    Get.toNamed(EditBoatPage.id,
                                        arguments: boat);
                                  },
                                ),
                              ),
                              IconButton(
                                splashRadius: 20,
                                iconSize: 23,
                                icon: Icon(isExpanded
                                    ? Icons.keyboard_arrow_up_rounded
                                    : Icons.keyboard_arrow_down_rounded),
                                onPressed: () {
                                  setState(() {
                                    isExpanded = !isExpanded;
                                    //log(isExpanded.toString());
                                  });
                                },
                              ),
                            ]),
                      ),
                      if (isExpanded)
                        Padding(
                          padding: const EdgeInsets.only(left: 25, right: 25),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: 20),
                              Stack(
                                children: [
                                  boat.ocean!
                                      ? TAImage(
                                          AppImages.icon.newBoat,
                                          height: 90,
                                          // width: 100,
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.only(
                                              right: 10.0),
                                          child: TAImage(
                                            AppImages.icon.vehicle,
                                            height: 90,
                                          ),
                                        ),
                                  Positioned(
                                    left: boat.ocean! ? 80 : 65,
                                    top: boat.ocean! ? 5 : 15,
                                    bottom: 5,
                                    child: Container(
                                      height: 400,
                                      width: 160,
                                      child: Wrap(
                                          direction: Axis.horizontal,
                                          verticalDirection:
                                              VerticalDirection.down,
                                          children: [
                                            ...List.generate(boat.capacity!,
                                                (index) {
                                              return buildSeat(
                                                  borderColor:
                                                      AppColors.text.skyBlue,
                                                  color: AppColors
                                                      .text.lightSkyBlue);
                                            }),
                                          ]),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 50),
                              Padding(
                                padding: const EdgeInsets.only(left: 25.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: buildCaptainName(
                                          icon: AppImages.icon.captain,
                                          name: boat.captainName!),
                                    ),
                                    SizedBox(height: 20),
                                    Expanded(
                                      child: buildCaptainPhone(
                                          icon: Icons.phone,
                                          phoneNumber: boat.phoneNumber!),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                    ],
                  ),
                ),
              ),
            );
          }
          return Container();
        });
  }

  Widget buildCaptainName({required String icon, required String name}) {
    return Row(
      children: [
        TAImage(
          icon,
          height: 20,
          width: 20,
        ),
        SizedBox(width: 10),
        Container(
          width: 85,
          child: Text(
            name,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: FontSize.small, fontWeight: FontWeight.w700),
          ),
        )
      ],
    );
  }

  Widget buildCaptainPhone(
      {required IconData icon, required String phoneNumber}) {
    return GestureDetector(
      onTap: () {
        makingPhoneCall(phoneNumber);
      },
      child: Row(
        children: [
          Icon(icon, size: 15),
          SizedBox(width: 10),
          Text(
            phoneNumber,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: FontSize.small, fontWeight: FontWeight.w700),
          )
        ],
      ),
    );
  }

  makingPhoneCall(String phoneNumber) async {
    String url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget buildSeat({required Color borderColor, Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(left: 3.5, top: 6),
      child: Container(
        height: 12,
        width: 7,
        decoration: BoxDecoration(
            borderRadius: BorderRadiusDirectional.circular(2),
            border: Border.all(color: borderColor, width: 1),
            color: color),
      ),
    );
  }
}
