import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/models/item-model.dart';
import 'package:temple_adventures/core/util/spacing-widget.dart';
import 'package:temple_adventures/features/boat/models/boat-details.dart';

import '../../../board-plan/presentation/widgets/customer-details.dart';
import '../../../bookings/models/booking-model.dart';
import '../../controllers/home-controller.dart';

class EmployeeDiveCalenderListTile extends StatefulWidget {
  EmployeeDiveCalenderListTile({Key? key, required this.itemModel, required this.selectedDate}) : super(key: key);

  final ItemModel itemModel;
  final DateTime selectedDate;
  late final _EmployeeDiveCalenderListTileState employeeDiveCalenderListTileState;

  @override
  State<EmployeeDiveCalenderListTile> createState() {
    employeeDiveCalenderListTileState = _EmployeeDiveCalenderListTileState();
    return employeeDiveCalenderListTileState;
  }

  void closeExpansion() {
    employeeDiveCalenderListTileState.closeExpansion();
  }
}

class _EmployeeDiveCalenderListTileState extends State<EmployeeDiveCalenderListTile> {
  bool isExpanded = false;
  HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
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
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${widget.itemModel.activity} ",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "${widget.itemModel.name?.capitalizeFirst} (${widget.itemModel.bookingID})",
                      style: TextStyle(
                        fontFamily: AppFonts.nunito,
                        color: AppColors.text.darkgrey,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                IconButton(
                  visualDensity: VisualDensity(horizontal: 0, vertical: 0),
                  padding: EdgeInsets.all(0),
                  splashRadius: 20,
                  iconSize: 20,
                  icon: Icon(isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded),
                  onPressed: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                ),
              ],
            ).paddingOnly(left: 20),
            if (isExpanded)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Spacing.h10,
                  _buildKeyValuePairs("Booking Id", widget.itemModel.bookingID ?? "-"),
                  if (!widget.itemModel.bookingModel!.isQuickBooking)
                    _buildKeyValuePairs(
                      "Balance",
                      "${getBalance(widget.itemModel.bookingModel?.payments ?? [], double.parse(widget.itemModel.paid).roundToDouble(), double.parse(widget.itemModel.cost).roundToDouble())} / -",
                    ),
                  _buildKeyValuePairs("Session", widget.itemModel.session),
                  if (!widget.itemModel.bookingModel!.isQuickBooking)
                    _buildKeyValuePairs(
                      "Registered",
                      "${widget.itemModel.bookingModel!.pax!.length - 1} / ${widget.itemModel.bookingModel!.noOfPersons}",
                      isDanger: ((widget.itemModel.bookingModel!.pax!.length - 1) !=
                          (widget.itemModel.bookingModel!.noOfPersons)),
                    ),
                  (widget.itemModel.remarks == "")
                      ? _buildKeyValuePairs("Remarks", "-")
                      : _buildKeyValuePairs("Remarks", widget.itemModel.remarks.toString()),
                  _buildKeyValuePairs("Status", getStatus(widget.itemModel.bookingModel!)),
                  _buildKeyValuePairs("Boat", "Tucy @ 7:30"),
                  _buildKeyValuePairs(
                      "Instructor Tanks",
                      "N/${widget.itemModel.bookingModel?.getInstructorTanks(controller.selectedDate)?.nitrox ?? 0} - "
                          "A/${widget.itemModel.bookingModel?.getInstructorTanks(controller.selectedDate)?.air ?? 0}"),
                  _buildKeyValuePairs(
                      "Customer Tanks",
                      "N/${widget.itemModel.bookingModel?.getBoatInfo(controller.selectedDate)?.nitrox ?? 0} - "
                          "A/${widget.itemModel.bookingModel?.getBoatInfo(controller.selectedDate)?.air ?? 0}"),
                  _buildInterns(widget.itemModel.bookingModel?.boatDetails?.interns ?? []),
                  _buildKeyValuePairs(
                    "Notes",
                    (widget.itemModel.bookingModel!.boatDetails!.employeeNotes != null &&
                            widget.itemModel.bookingModel!.boatDetails!.employeeNotes!.isNotEmpty)
                        ? widget.itemModel.bookingModel!.boatDetails!.employeeNotes!
                        : "-",
                  ),
                  Spacing.h10,
                  Divider(thickness: 1, color: Colors.black).paddingOnly(right: 20),
                ],
              ).paddingOnly(left: 20)
          ],
        ),
      ),
    );
  }

  String getBalance(List<PaymentModel> payments, double deposit, double total) {
    double t = deposit;
    payments.forEach((payment) {
      t += payment.amount!;
    });
    return (total - t).toInt().toString();
  }

  Widget _buildKeyValuePairs(
    String key,
    String value, {
    bool isDanger = false,
    bool shrinkKey = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (shrinkKey)
          Text(
            key,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 13,
              letterSpacing: 0.3,
              fontWeight: FontWeight.w600,
            ),
          ).paddingOnly(right: 10)
        else
          Expanded(
            child: Text(
              key,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 13,
                letterSpacing: 0.3,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        Container(
          width: 170,
          child: Text(
            value,
            style: TextStyle(
              color: isDanger ? Colors.red : Colors.black,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ],
    ).paddingOnly(bottom: 6);
  }

  Widget _buildInterns(
    List<Intern> interns, {
    bool shrinkKey = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (shrinkKey)
          Text(
            "Interns (N - A)",
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 13,
              letterSpacing: 0.3,
              fontWeight: FontWeight.w600,
            ),
          ).paddingOnly(right: 10)
        else
          Expanded(
            child: Text(
              "Interns (N - A)",
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 13,
                letterSpacing: 0.3,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        Container(
            width: 170,
            child: Wrap(
              children: [
                if (interns.length == 0) Text("-"),
                ...interns.map(
                  (e) => Text(
                    "${e.name}${"(${e.nitrox} - ${e.air})"}, ",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                )
              ],
            )),
      ],
    ).paddingOnly(bottom: 6);
  }

  void closeExpansion() {
    setState(() {
      isExpanded = false;
      log("==========depth expansion closed");
      log(isExpanded.toString());
    });
  }

  String getStatus(Booking bookingModel) {
    return bookingModel.isDSD
        ? dsdStatus[bookingModel.boatDetails?.bookingStatus ?? 0]
        : coursesStatus[bookingModel.getStatus(controller.selectedDate) ?? 0];
  }
}
