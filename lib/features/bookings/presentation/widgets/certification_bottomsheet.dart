import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_ui_tools/utils/utils.dart';

import '../../../../core/models/item_model.dart';
import '../../../../core/util/alignment_extensions.dart';
import '../../../../core/util/spacing_widgets.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../certifications/presentation/widgets/pick_photos_widget.dart';
import '../../models/booking_model.dart';
import 'add_customer_dialog.dart';
import 'certification_status.dart';

class CertificationBottomSheet extends StatefulWidget {
  const CertificationBottomSheet({
    Key? key,
    required this.itemModel,
    required this.selectedDate,
  }) : super(key: key);

  final ItemModel itemModel;
  final DateTime? selectedDate;

  static void show(
    BuildContext context, {
    required ItemModel itemModel,
    required DateTime? selectedDate,
  }) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      builder: (BuildContext context) {
        return CertificationBottomSheet(
          itemModel: itemModel,
          selectedDate: selectedDate,
        );
      },
    );
  }

  @override
  State<CertificationBottomSheet> createState() => _CertificationBottomSheetState();
}

class _CertificationBottomSheetState extends State<CertificationBottomSheet> {
  File? pickedImage;
  bool showLoading = false;
  late ItemModel itemModel;
  late Booking booking;

  @override
  void initState() {
    super.initState();
    itemModel = widget.itemModel;
    booking = widget.itemModel.bookingModel!;
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
    return Stack(
      children: [
        Column(
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
                        "${booking.pax?[index]['first-name']} ${booking.pax?[index]['last-name']}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                      Spacing.w20,
                      Expanded(
                        child: Text(
                          "(${booking.pax?[index]['email']})",
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Spacing.h20,
                  if (itemModel.colorCode != 'Blue' &&
                      itemModel.isCustomerBooking &&
                      (booking.boatDetails?.instructors ?? []).isNotEmpty)
                    CertificationStatus(
                      paxIndex: index,
                      itemModel: itemModel,
                      onChanged: (int status) async {
                        booking.pax?[index]['certificateStatus'] = status;
                        booking.certificationStatuses?.clear();
                        booking.pax?.forEach((pax) {
                          booking.certificationStatuses?.add(pax['certificateStatus']);
                        });
                        await FirebaseFirestore.instance.collection('bookings').doc(booking.id).set(booking.toMap());
                        setState(() {});
                      },
                      isCertificationDetailsView: false,
                      selectedDate: widget.selectedDate,
                    ),
                  Spacing.h20,
                  PickPhotosWidget(
                    pickedImage: booking.pax?[index]['photo'],
                    onChanged: (File? image) async {
                      if (image != null) {
                        setState(() {
                          showLoading = true;
                        });
                        booking.pax?[index]['photo'] = await uploadImage(image);
                        await FirebaseFirestore.instance.collection('bookings').doc(booking.id).set(booking.toMap());
                        setState(() {
                          showLoading = false;
                        });
                      }
                    },
                  ),
                  Spacing.h15,
                  if (index != (booking.pax!.length - 1)) const Divider(),
                  Spacing.h15,
                ],
              );
            }).toList(),
            Spacing.h20,
            buildAddCustomerButton(),
          ],
        ),
        if (showLoading)
          Container(
            height: Screen.height,
            width: Screen.width,
            color: Colors.white,
            child: const CircularProgressIndicator().center,
          ),
      ],
    );
  }

  Future<String> uploadImage(File? selectedImage) async {
    String downloadURL = '';

    if (selectedImage != null) {
      try {
        String fileName = '${DateTime.now().millisecondsSinceEpoch}';

        Reference storageReference = FirebaseStorage.instance.ref().child('Images/$fileName.jpg');

        await storageReference.putFile(selectedImage);

        downloadURL = await storageReference.getDownloadURL();
      } catch (error) {
        print('Error uploading image : $error');
      }
    }

    return downloadURL;
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
          onPressed: () {
            if (!showLoading) {
              Navigator.pop(context);
            }
          },
        ),
      ],
    );
  }

  Widget buildAddCustomerButton() {
    if (booking.pax!.length < booking.noOfPersons!) {
      return AppButton.miniFlat(
        text: 'Add Customer',
        onTap: () async {
          Booking newBooking = await AddCustomerDialog.show(
            context,
            bookingModel: booking,
          );

          booking = newBooking;
          setState(() {});
        },
      );
    }
    return const SizedBox();
  }
}
