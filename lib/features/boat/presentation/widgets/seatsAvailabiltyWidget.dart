import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/widgets/app-button.dart';
import 'package:temple_adventures/features/boat/models/boat-model.dart';
import 'package:temple_adventures/features/boat/presentation/widgets/bottomSheetWidget.dart';
import 'package:temple_adventures/features/boat/presentation/widgets/seat.dart';
import '../../../../core/widgets/app-expansion-panel.dart';
import '../../models/boat-passengers-model.dart';
import 'freelanceDiverBottomSheetWidget.dart';

class SeatsAvailabilityExpansionPanel extends StatefulWidget {
  final BoatsModel boat;
  final int fixedSeats;
  final int selectedSeats;
  final int? maxSeats;
  final bool enableSelection;
  final List<Employees> selectedEmployees;
  final List<Freelancer> selectedFreelancers;
  final List<Employees> commonEmployees;
  final List<Freelancer> commonFreelancers;
  final Function(bool) onSeatSelected;
  final Function(Employees) onEmployeeDeleted;
  final Function(List<Employees>, List<Employees>) onEmployeesModified;
  final Function(List<Freelancer>, List<Freelancer>) onFreelancerModified;
  final Function(Freelancer) onFreelanceAdded;

  SeatsAvailabilityExpansionPanel({
    required this.boat,
    required this.selectedSeats,
    required this.commonEmployees,
    required this.commonFreelancers,
    required this.fixedSeats,
    required this.maxSeats,
    required this.enableSelection,
    required this.selectedEmployees,
    required this.selectedFreelancers,
    required this.onFreelanceAdded,
    required this.onSeatSelected,
    required this.onEmployeeDeleted,
    required this.onEmployeesModified,
    required this.onFreelancerModified,
  });

  @override
  State<SeatsAvailabilityExpansionPanel> createState() =>
      _SeatsAvailabilityExpansionPanelState();
}

class _SeatsAvailabilityExpansionPanelState
    extends State<SeatsAvailabilityExpansionPanel> {
  bool isExpanded = false;

  List<Employees> get selectedEmployees => widget.selectedEmployees;
  List<Employees> get commonEmployees => widget.commonEmployees;

  @override
  Widget build(BuildContext context) {
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
                              widget.boat.boatName!,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: AppColors.text.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                            if (!widget.boat.ocean!)
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
                      Text(
                        widget.selectedSeats.toString(),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: AppColors.text.skyBlue,
                            fontSize: 10,
                            fontWeight: FontWeight.bold),
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
                      buildSideHeading(text: "Customers"),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 270,
                            child: Wrap(
                                direction: Axis.horizontal,
                                verticalDirection: VerticalDirection.down,
                                children: [
                                  ...List.generate((widget.fixedSeats),
                                      (index) {
                                    return Seat(
                                      enabled: false,
                                      selected: true,
                                      isFixed: true,
                                      onSelected: (isSelected) {
                                        widget.onSeatSelected(isSelected);
                                      },
                                    );
                                  }),
                                  ...List.generate((widget.selectedSeats),
                                      (index) {
                                    return Seat(
                                      enabled: widget.enableSelection,
                                      selected: true,
                                      onSelected: (isSelected) {
                                        widget.onSeatSelected(isSelected);
                                      },
                                    );
                                  }),
                                  ...List.generate(
                                      (widget.boat.capacity! -
                                          widget.fixedSeats -
                                          widget.selectedSeats), (index) {
                                    return Seat(
                                      enabled: widget.enableSelection,
                                      selected: false,
                                      onSelected: (isSelected) {
                                        widget.onSeatSelected(isSelected);
                                      },
                                    );
                                  }),
                                ]),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      buildSeatColorRepresentation(
                          borderColor: AppColors.text.grey,
                          color: Colors.grey.withOpacity(0.7),
                          text: "Booked"),
                      SizedBox(height: 15),
                      buildSeatColorRepresentation(
                          borderColor: AppColors.text.skyBlue,
                          color: AppColors.text.lightSkyBlue,
                          text: "Selected"),
                      SizedBox(height: 15),
                      buildSeatColorRepresentation(
                          borderColor: Color(0xff5BFF62),
                          color: Color(0xffD1FFBB),
                          text: "Available"),
                      SizedBox(height: 30),
                      buildSideHeading(text: "Employees"),
                      SizedBox(height: 20),
                      Container(
                        width: 350,
                        child: Wrap(
                          direction: Axis.horizontal,
                          verticalDirection: VerticalDirection.down,
                          children: [
                            ...selectedEmployees
                                .map((e) => buildEmployeeChip(e))
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: Get.width,
                        child: AppButton.miniFlat(
                          onTap: () {
                            Get.bottomSheet(EmployeeSelectorBottomSheet(
                              selectedEmployees: selectedEmployees,
                              commonEmployees: commonEmployees,
                              onEmployeeTapped: (Employees e) {
                                for (Employees emp in selectedEmployees) {
                                  if (emp.id == e.id) {
                                    return;
                                  }
                                }
                                for (Employees emp in commonEmployees) {
                                  if (emp.id == e.id) {
                                    return;
                                  }
                                }
                                e.boatID = widget.boat.id;
                                widget.selectedEmployees.add(e);
                                widget.commonEmployees.add(e);
                                widget.onEmployeesModified(
                                  selectedEmployees,
                                  commonEmployees,
                                );
                              },
                              onEmployeeDeleted: (Employees e) {
                                // widget.selectedEmployees.remove(e);
                                // widget.commonEmployees.remove(e);
                                // for (Employees emp in selectedEmployees) {
                                //   if (emp.id == e.id) {
                                //     selectedEmployees.remove(e);
                                //   }
                                // }
                                // for (Employees emp in commonEmployees) {
                                //   if (emp.id == e.id) {
                                //     commonEmployees.remove(e);
                                //   }
                                // }
                                // e.boatID = widget.boat.id;
                                // selectedEmployees.add(e);
                                // commonEmployees.add(e);
                                // widget.onEmployeesModified(
                                //   selectedEmployees,
                                //   commonEmployees,
                                // );
                              },
                            ));
                            //log("clicked");
                          },
                          text: "Add",
                        ),
                        alignment: Alignment.centerRight,
                      ),
                      buildSideHeading(text: "Freelance Divers"),
                      SizedBox(height: 20),
                      Container(
                        width: 350,
                        child: Wrap(
                          direction: Axis.horizontal,
                          verticalDirection: VerticalDirection.down,
                          children: [
                            ...widget.selectedFreelancers
                                .map((e) => buildFreelanceChip(e))
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: Get.width,
                        child: AppButton.miniFlat(
                          onTap: () {
                            Get.bottomSheet(FreelanceDiverBottomSheet(
                              selectedFreelancers: widget.selectedFreelancers,
                              commonFreelancers: widget.commonFreelancers,
                              onFreelanceTapped: (Freelancer f) {
                                for (Freelancer flr
                                    in widget.selectedFreelancers) {
                                  if (flr.id == f.id) {
                                    return;
                                  }
                                }
                                for (Freelancer flr
                                    in widget.commonFreelancers) {
                                  if (flr.id == f.id) {
                                    return;
                                  }
                                }
                                setState(() {
                                  f.boatID = widget.boat.id;
                                  widget.selectedFreelancers.add(f);
                                  widget.commonFreelancers.add(f);
                                  widget.onFreelancerModified(
                                    widget.selectedFreelancers,
                                    widget.commonFreelancers,
                                  );
                                });
                              },
                            ));
                          },
                          text: "Add",
                        ),
                        alignment: Alignment.centerRight,
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildEmployeeChip(Employees e) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 4, top: 5, bottom: 5),
      child: Container(
        height: 22,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black.withOpacity(0.2), width: 1),
            borderRadius: BorderRadius.circular(11)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  e.name!,
                  style: TextStyle(fontSize: 10),
                ),
              ),
            ),
            SizedBox(width: 1),
            Padding(
              padding: const EdgeInsets.only(right: 2.0, top: 2, bottom: 2),
              child: GestureDetector(
                onTap: () {
                  widget.onEmployeeDeleted(e);
                },
                child: Container(
                  height: 16,
                  width: 16,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black.withOpacity(0.1)),
                  child: Icon(Icons.clear_rounded,
                      size: 12, color: Colors.black.withOpacity(0.6)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildFreelanceChip(Freelancer f) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 4, top: 5, bottom: 5),
      child: Container(
        height: 22,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black.withOpacity(0.2), width: 1),
            borderRadius: BorderRadius.circular(11)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  f.name!,
                  style: TextStyle(fontSize: 10),
                ),
              ),
            ),
            SizedBox(width: 1),
            Padding(
              padding: const EdgeInsets.only(right: 2.0, top: 2, bottom: 2),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    widget.selectedFreelancers.remove(f);
                  });
                },
                child: Container(
                  height: 16,
                  width: 16,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black.withOpacity(0.1)),
                  child: Icon(Icons.clear_rounded,
                      size: 12, color: Colors.black.withOpacity(0.6)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildSideHeading({required String text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: TextStyle(
            color: Colors.black.withOpacity(0.80),
            fontSize: 10,
            fontWeight: FontWeight.w300,
            letterSpacing: 0.75,
          ),
        ),
        SizedBox(height: 5),
        Container(
          width: Get.width,
          height: 1,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black.withOpacity(0.1)),
          ),
        ),
      ],
    );
  }

  Widget buildSeatColorRepresentation(
      {required Color borderColor, Color? color, required String text}) {
    return Row(
      children: [
        Container(
          height: 22,
          width: 17,
          decoration: BoxDecoration(
              borderRadius: BorderRadiusDirectional.circular(4),
              border: Border.all(color: borderColor, width: 1),
              color: color),
          child: Center(
            child: Icon(
              Icons.star,
              size: 8,
              color: AppColors.text.black.withOpacity(0.5),
            ),
          ),
        ),
        SizedBox(width: 10),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        )
      ],
    );
  }
}
