import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_ui_tools/utils/utils.dart';
import '../../../../core/models/item_model.dart';
import '../../../../core/util/alignment_extensions.dart';
import '../../../../core/util/spacing_widgets.dart';
import '../../../../core/widgets/app_button.dart';
import '../../models/booking_model.dart';
import 'add_customer_dialog.dart';
import 'certification_status.dart';

class CertificationBottomSheet extends StatefulWidget {
  const CertificationBottomSheet({
    Key? key,
    required this.itemModel,
  }) : super(key: key);

  final ItemModel itemModel;

  static void show(BuildContext context, {required ItemModel itemModel}) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      builder: (BuildContext context) {
        return CertificationBottomSheet(itemModel: itemModel);
      },
    );
  }

  @override
  State<CertificationBottomSheet> createState() => _CertificationBottomSheetState();
}

class _CertificationBottomSheetState extends State<CertificationBottomSheet> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Screen.height,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 30,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Spacing.h30,
          buildTitleAndClose(),
          Spacing.h20,
          buildCustomers(),
          Spacing.h30,
        ],
      ).scrollable.paddingSymmetric(horizontal: 20),
    );
  }

  Widget buildCustomers() {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('bookings').doc(widget.itemModel.bookingID).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Center(child: Text('No data available'));
        }

        final bookingData = snapshot.data!.data();
        Booking booking = Booking.fromMap(bookingData!);
        ItemModel itemModel = ItemModel.fromBooking(booking);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...(booking.pax ?? []).asMap().entries.map((entry) {
              final index = entry.key;
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "${itemModel.bookingModel?.pax?[index]['first-name']} ${itemModel.bookingModel?.pax?[index]['last-name']}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                      Spacing.w20,
                      Text(
                        "(${itemModel.bookingModel?.pax?[index]['email']})",
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Spacing.h20,
                  if (itemModel.colorCode != 'Blue' &&
                      itemModel.isCustomerBooking &&
                      (itemModel.bookingModel?.boatDetails?.instructors ?? []).isNotEmpty)
                    CertificationStatus(
                      paxIndex: index,
                      itemModel: itemModel,
                      onChanged: (int status) async {
                        itemModel.bookingModel!.pax?[index]['certificateStatus'] = status;
                        itemModel.bookingModel?.certificationStatuses?.clear();
                        itemModel.bookingModel?.pax?.forEach((pax) {
                          itemModel.bookingModel?.certificationStatuses?.add(pax['certificateStatus']);
                        });
                        await FirebaseFirestore.instance
                            .collection('bookings')
                            .doc(itemModel.bookingModel!.id)
                            .set(itemModel.bookingModel!.toMap());
                      },
                      isCertificationDetailsView: false,
                    ),
                  Spacing.h20,
                ],
              );
            }).toList(),
            Spacing.h20,
            buildAddCustomerButton(),
          ],
        );
      },
    );
  }

  Widget buildTitleAndClose() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          'Manage Certs',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ).paddingOnly(top: 8),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: onApply,
        ),
      ],
    );
  }

  void onApply() {
    Navigator.pop(context);
  }

  Widget buildAddCustomerButton() {
    if (widget.itemModel.bookingModel!.pax!.length < widget.itemModel.bookingModel!.noOfPersons!) {
      return AppButton.miniFlat(
        text: 'Add Customer',
        onTap: () {
          AddCustomerDialog.show(
            context,
            bookingModel: widget.itemModel.bookingModel!,
          );
        },
      );
    }
    return const SizedBox();
  }
}
