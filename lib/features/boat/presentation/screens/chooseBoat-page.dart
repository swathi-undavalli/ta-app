import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/widgets/back-navigation-icon.dart';
import 'package:temple_adventures/features/boat/controller/choose-boat-controller.dart';
import 'package:temple_adventures/features/boat/models/boat-passengers-model.dart';
import 'package:temple_adventures/features/boat/presentation/widgets/seatsAvailabiltyWidget.dart';
import 'package:temple_adventures/features/bookings/models/booking-model.dart';

class ChooseBoatPage extends StatelessWidget {
  static const String id = "ChooseBoatPage";

  final ChooseBoatLogic logic = ChooseBoatLogic();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        onPressed: () async {
          logic.onCheckPressed();
        },
        backgroundColor: AppColors.background.black,
        child: Icon(Icons.check),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: WillPopScope(
          onWillPop: () async {
            logic.controller.reset();
            return true;
          },
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  buildDateSelector(),
                  SizedBox(height: 15),
                  buildBoatSelector(),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDateSelector() {
    return GetBuilder<ChooseBoatController>(builder: (controller) {
      if (controller.showLoading) return SizedBox();
      return Row(
        children: [
          SizedBox(
            width: 23,
          ),
          Text(
            DateFormat('dd-MM-yyyy')
                .format(controller.diveDates[controller.currentDiveDateIndex]),
            style: TextStyle(
                fontSize: 16,
                fontFamily: AppFonts.nunito,
                color: AppColors.text.black,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            width: 10,
          ),
          // Spacer(),
          // IconButton(
          //   onPressed: (controller.currentDiveDateIndex != 0)
          //       ? () {
          //           if (controller.currentDiveDateIndex != 0)
          //             controller.currentDiveDateIndex--;
          //         }
          //       : null,
          //   icon: Icon(
          //     Icons.navigate_before_rounded,
          //     color: (controller.currentDiveDateIndex != 0)
          //         ? Colors.black87
          //         : Colors.grey,
          //   ),
          // ),
          // IconButton(
          //   onPressed: (controller.currentDiveDateIndex !=
          //           controller.diveDates.length - 1)
          //       ? () {
          //           if (controller.currentDiveDateIndex !=
          //               controller.diveDates.length - 1)
          //             controller.currentDiveDateIndex++;
          //         }
          //       : null,
          //   icon: Icon(
          //     Icons.navigate_next_rounded,
          //     color: (controller.currentDiveDateIndex !=
          //             controller.diveDates.length - 1)
          //         ? Colors.black87
          //         : Colors.grey,
          //   ),
          // ),
        ],
      );
    });
  }

  Widget buildBoatSelector() {
    return GetBuilder<ChooseBoatController>(builder: (controller) {
      if (controller.showLoading) return SizedBox();
      return Column(
        children: [
          buildSeatsSelected(controller.currentDiveDateIndex),
          SizedBox(height: 40),
          Column(
            children: [
              if (controller.boatsList.isEmpty)
                SizedBox(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  ),
                  height: 300,
                ),
              if (controller.boatsList.isNotEmpty)
                ...List.generate(
                  controller.boatsList.length,
                  (index) => SeatsAvailabilityExpansionPanel(
                    boat: controller.boatsList[index],
                    fixedSeats: controller
                        .fixedSeatCount[controller.currentDiveDateIndex][index],
                    selectedSeats: controller
                            .selectedSeatsCount[controller.currentDiveDateIndex]
                        [index],
                    selectedEmployees: controller
                            .selectedEmployees[controller.currentDiveDateIndex]
                        [index],
                    selectedFreelancers: controller.selectedFreelancers[
                        controller.currentDiveDateIndex][index],
                    commonEmployees: controller.commonEmployees,
                    maxSeats: controller.boatsList[index].capacity,
                    enableSelection: controller
                            .selectedSeatsCount[controller.currentDiveDateIndex]
                            .reduce((v, e) => v + e) !=
                        controller
                            .requiredCount[controller.currentDiveDateIndex],
                    onSeatSelected: (bool isSelected) {
                      if (isSelected) {
                        controller.selectedSeatsCount[
                            controller.currentDiveDateIndex][index]++;
                      } else {
                        controller.selectedSeatsCount[
                            controller.currentDiveDateIndex][index]--;
                      }
                      controller.update();
                    },
                    onFreelanceAdded: (Freelancer freelancer) {
                      controller
                          .selectedFreelancers[controller.currentDiveDateIndex]
                              [index]
                          .add(freelancer);
                      controller.update();
                    },
                    onEmployeesModified: (
                      List<Employees> employees,
                      List<Employees> commonEmployees,
                    ) {
                      controller.selectedEmployees[
                          controller.currentDiveDateIndex][index] = employees;
                      controller.commonEmployees = commonEmployees;
                      controller.update();
                    },
                    onFreelancerModified: (
                      List<Freelancer> freelancers,
                      List<Freelancer> commonFreelancers,
                    ) {
                      controller.selectedFreelancers[
                          controller.currentDiveDateIndex][index] = freelancers;
                      controller.commonFreelancers = commonFreelancers;
                      controller.update();
                    },
                    commonFreelancers: controller.commonFreelancers,
                  ),
                ),
            ],
          ),
        ],
      );
    });
  }

  Widget buildSeatsSelected(dateIndex) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Row(
        children: [
          GetBuilder<ChooseBoatController>(builder: (controller) {
            return Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: controller.selectedSeatsCount[dateIndex]
                        .reduce((v, e) => v + e)
                        .toString(),
                    style: TextStyle(
                      fontSize: 30,
                      fontFamily: AppFonts.nunito,
                      color: controller.selectedSeatsCount[dateIndex]
                                  .reduce((v, e) => v + e) !=
                              controller.requiredCount[dateIndex]
                          ? Colors.red
                          : Colors.lightGreenAccent.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: '/${controller.requiredCount[dateIndex]}',
                    style: TextStyle(
                        fontSize: 10,
                        fontFamily: AppFonts.nunito,
                        color: AppColors.text.black,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            );
          }),
          SizedBox(width: 10),
          Container(
            alignment: Alignment.bottomCenter,
            height: 27,
            child: Text(
              "Selected",
              style: TextStyle(
                color: AppColors.text.black,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAppBar() {
    return AppBar(
      toolbarHeight: 70,
      centerTitle: true,
      title: Text(
        "Select Seats",
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          letterSpacing: 1.2,
        ),
      ),
      leading: GestureDetector(
        onTap: () {
          logic.controller.reset();
        },
        child: BackNavigationIcon(),
      ),
      elevation: 0,
      backgroundColor: AppColors.background.white,
    );
  }
}
