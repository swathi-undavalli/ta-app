import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:temple_ui_tools/utils/utils.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/models/item_model.dart';
import '../../../../core/util/spacing_widgets.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../activities/model/colors_data.dart';
import '../../../board_plan/presentation/widgets/customer_details.dart';
import '../../../boat/models/boat_details.dart';
import '../../../boat/models/boats.dart';
import '../../../boat/presentation/widgets/customer_booking_status.dart';
import '../../../boat/presentation/widgets/customer_expandable_list_tile.dart';
import '../../../bookings/models/booking_model.dart';
import '../../../bookings/presentation/widgets/certification_bottomsheet.dart';
import '../../../bookings/presentation/widgets/dive_log_bootomsheet.dart';
import '../../controllers/home_controller.dart';

class EmployeeDiveCalenderListTile extends StatefulWidget {
  EmployeeDiveCalenderListTile({
    Key? key,
    required this.itemModel,
    required this.selectedDate,
  }) : super(key: key);

  final ItemModel itemModel;
  final DateTime selectedDate;
  final EmployeeDiveCalenderListTileState employeeDiveCalenderListTileState = EmployeeDiveCalenderListTileState();

  @override
  State<EmployeeDiveCalenderListTile> createState() {
    // ignore: no_logic_in_create_state
    return employeeDiveCalenderListTileState;
  }

  void closeExpansion() {
    employeeDiveCalenderListTileState.closeExpansion();
  }
}

class EmployeeDiveCalenderListTileState extends State<EmployeeDiveCalenderListTile> {
  bool isExpanded = false;
  HomeController controller = Get.put(HomeController());

  List<Boat> allBoats = [];
  Boat? selectedBoat;

  @override
  void initState() {
    getSelectedBoat(
      widget.itemModel.bookingModel?.getBoatInfo(widget.selectedDate)?.id ?? '',
    );
    super.initState();
  }

  Future<void> getSelectedBoat(String boatId) async {
    var d = await FirebaseFirestore.instance
        .collection('dailyBoats')
        .doc(DateFormat('dd-MM-yyyy').format(widget.selectedDate))
        .get();
    Map<String, dynamic>? data = d.data();
    BoatsModel? boatsModel = BoatsModel.fromMap(data);
    allBoats = boatsModel.boats ?? [];
    for (var boat in allBoats) {
      if (boat.id == boatId) {
        selectedBoat = boat;
      }
    }
    setState(() {});
  }

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
                      '${widget.itemModel.activity} ',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '${widget.itemModel.name?.capitalizeFirst} '
                      'x'
                      ' ${(widget.itemModel.bookingModel!.noOfPersons.toString())}'
                      ' (${widget.itemModel.bookingID})',
                      style: TextStyle(
                        fontFamily: AppFonts.nunito,
                        color: AppColors.text.darkgrey,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  visualDensity: const VisualDensity(horizontal: 0, vertical: 0),
                  padding: const EdgeInsets.all(0),
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
                  _buildKeyValuePairs('Booking Id', widget.itemModel.bookingID ?? '-'),
                  if (!widget.itemModel.bookingModel!.isQuickBooking)
                    _buildKeyValuePairs(
                      'Balance',
                      '${getBalance(widget.itemModel.bookingModel?.payments ?? [], double.parse(widget.itemModel.paid).roundToDouble(), double.parse(widget.itemModel.cost).roundToDouble())} / -',
                    ),
                  if (!widget.itemModel.bookingModel!.isQuickBooking)
                    _buildKeyValuePairs(
                      'Registered',
                      '${widget.itemModel.bookingModel!.registeredUsers.length} / ${widget.itemModel.bookingModel!.noOfPersons}',
                      isDanger: ((widget.itemModel.bookingModel!.registeredUsers.length) !=
                          (widget.itemModel.bookingModel!.noOfPersons)),
                    ),
                  (widget.itemModel.remarks == '')
                      ? _buildKeyValuePairs('Remarks', '-')
                      : _buildKeyValuePairs(
                          'Remarks',
                          widget.itemModel.remarks.toString(),
                        ),
                  // _buildKeyValuePairs(
                  //     'Status', getStatus(widget.itemModel.bookingModel!)),
                  _buildKeyValuePairs('Boat', selectedBoat?.name ?? '-'),
                  _buildKeyValuePairs(
                      'Customer Tanks',
                      'N/${widget.itemModel.bookingModel?.getBoatInfo(controller.selectedDate)?.nitrox ?? 0} - '
                          'A/${widget.itemModel.bookingModel?.getBoatInfo(controller.selectedDate)?.air ?? 0}'),
                  _buildDiveBuddies(widget.itemModel.bookingModel?.boatDetails?.diveBuddies ?? []),
                  _buildKeyValuePairs(
                    'Notes',
                    (widget.itemModel.bookingModel!.boatDetails!.employeeNotes != null &&
                            widget.itemModel.bookingModel!.boatDetails!.employeeNotes!.isNotEmpty)
                        ? widget.itemModel.bookingModel!.boatDetails!.employeeNotes!
                        : '-',
                  ),
                  Spacing.h5,
                  Row(
                    children: [
                      AppButton.miniFlat(
                        text: 'Add Log',
                        onTap: () {
                          DiveLogBottomSheet.show(
                            context,
                            bookingModel: widget.itemModel.bookingModel!,
                            date: selectedDate,
                          );
                        },
                      ),
                      const Spacer(),
                      AppButton.miniFlat(
                        onTap: () {
                          CertificationBottomSheet.show(context, itemModel: widget.itemModel);
                        },
                        text: 'Manage Certs',
                      ),
                    ],
                  ).paddingOnly(right: 15),
                  Spacing.h15,
                  BookingStatus(
                    initialStatus: widget.itemModel.bookingModel!.isDSD
                        ? widget.itemModel.bookingModel?.boatDetails?.bookingStatus ?? 0
                        : widget.itemModel.bookingModel?.getStatus(widget.selectedDate) ?? 0,
                    onChanged: (int status) async {
                      await updateBoatDetails(
                        bookingModel: widget.itemModel.bookingModel!,
                        bookingStatus: status,
                        selectedDate: widget.selectedDate,
                      );
                    },
                    isDSD: (colorsData!.blue.contains(widget.itemModel.activity)),
                  ),

                  Spacing.h10,
                  const Divider(thickness: 1, color: Colors.black).paddingOnly(right: 20),
                ],
              ).paddingOnly(left: 20),
          ],
        ),
      ),
    );
  }

  String getBalance(List<PaymentModel> payments, double deposit, double total) {
    double t = deposit;
    for (var payment in payments) {
      t += payment.amount!;
    }
    return (total - t).toInt().toString();
  }

  Widget _buildKeyValuePairs(
    String key,
    String value, {
    bool isDanger = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 150,
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
        Expanded(
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

  Widget _buildDiveBuddies(List<Instructor> interns) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 150,
          child: Text(
            'Dive Buddies (N - A)',
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 13,
              letterSpacing: 0.3,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Wrap(
          children: [
            if (interns.isEmpty) const Text('-'),
            ...interns.map(
              (e) => SizedBox(
                width: Screen.width - 210,
                child: Text(
                  "${e.name}${"(${e.nitrox ?? 0} - ${e.air ?? 0})"}, ",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ).paddingOnly(bottom: 6);
  }

  void closeExpansion() {
    setState(() {
      isExpanded = false;
      log('==========depth expansion closed');
      log(isExpanded.toString());
    });
  }

  String getStatus(Booking bookingModel) {
    return bookingModel.isDSD
        ? dsdStatus[bookingModel.boatDetails?.bookingStatus ?? 0]
        : coursesStatus[bookingModel.getStatus(controller.selectedDate) ?? 0];
  }
}
