import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:temple_ui_tools/styling/alignment_extensions.dart';
import 'package:temple_ui_tools/styling/spacing_widgets.dart';
import 'package:temple_ui_tools/utils/utils.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/models/item_model.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../../bookings/models/booking_model.dart';
import '../../../bookings/presentation/widgets/certification_status.dart';

class CertificationDetailsView extends StatefulWidget {
  const CertificationDetailsView({super.key, required this.itemModel, required this.customer});

  final ItemModel itemModel;
  final Map<String, dynamic> customer;

  static Route route(ItemModel itemModel, Map<String, dynamic> customer) => MaterialPageRoute(
        builder: (context) => CertificationDetailsView(
          itemModel: itemModel,
          customer: customer,
        ),
      );

  @override
  State<CertificationDetailsView> createState() => _CertificationDetailsViewState();
}

class _CertificationDetailsViewState extends State<CertificationDetailsView> {
  bool isDownloading = false;
  bool isSharing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background.lightBlue,
      appBar: const AppBarWidget(heading: 'Certification Details'),
      body: SafeArea(
        child: Column(
          children: [
            buildKeyValuePairs(
              key: 'Booking Id',
              value: '${widget.itemModel.bookingID} ',
            ),
            buildKeyValuePairs(
              key: 'Name',
              value: '${widget.customer['first-name']} ${widget.customer['last-name']}',
            ),
            buildKeyValuePairs(key: 'Email', value: widget.customer['email']),
            buildKeyValuePairs(
              key: 'Date of Birth',
              value: widget.customer['dateOfBirth'] ??
                  ((widget.customer['dob'] != null)
                      ? DateFormat('dd-MM-yyy').format((widget.customer['dob'] as Timestamp).toDate())
                      : '-'),
            ),
            buildKeyValuePairs(key: 'Certification', value: widget.itemModel.activity),
            buildKeyValuePairs(
              key: 'Course Completion Date',
              value: widget.itemModel.bookingModel!.bookingDate?.last ?? '-',
            ),
            buildKeyValuePairs(
              key: 'Balance',
              value: getBalance(
                widget.itemModel.bookingModel!.payments!,
                double.parse(widget.itemModel.paid).roundToDouble(),
                double.parse(widget.itemModel.cost).roundToDouble(),
              ),
            ),
            buildKeyValuePairs(
              key: 'Completed instructor',
              value: widget.itemModel.bookingModel
                      ?.getInstructor(DateFormat('dd-MM-yyyy').parse(widget.itemModel.bookingModel!.bookingDate!.last))
                      ?.name ??
                  '-',
            ),
            buildKeyValuePairs(key: 'Instructor No', value: '-'),
            buildKeyValuePairs(key: 'Invoice No', value: widget.itemModel.bookingModel?.receiptNo ?? '-'),
            buildKeyValuePairs(key: 'Course / Equipment Upsell', value: '-'),
            Spacing.h30,
            CertificationStatus(
              onChanged: (int status) async {
                Booking booking = widget.itemModel.bookingModel!;

                booking.pax![widget.itemModel.bookingModel!.pax!.indexOf(widget.customer)]['certificateStatus'] =
                    status;
                booking.certificationStatuses?.clear();
                booking.pax?.forEach((pax) {
                  booking.certificationStatuses?.add(pax['certificateStatus']);
                });
                await FirebaseFirestore.instance.collection('bookings').doc(booking.id).set(booking.toMap());
              },
              itemModel: widget.itemModel,
              isCertificationDetailsView: true,
              paxIndex: widget.itemModel.bookingModel!.pax!.indexOf(widget.customer),
              selectedDate: null,
            ),
            Spacing.h30,
            if (widget.customer['photo'] != null)
              Row(
                children: [
                  SizedBox(
                    height: 130,
                    width: 130,
                    child: Image.network(
                      widget.customer['photo'],
                      height: Screen.width * 4 / 3,
                      width: Screen.width,
                      fit: BoxFit.cover,
                    ),
                  ).left,
                  Spacing.w20,
                  (isDownloading)
                      ? const CircularProgressIndicator(color: Colors.black, strokeWidth: 3).size(20, 20)
                      : IconButton(
                          onPressed: () async {
                            setState(() {
                              isDownloading = true;
                            });
                            await saveImageToGallery(widget.customer['photo']);
                            setState(() {
                              isDownloading = false;
                            });
                          },
                          icon: const Icon(
                            Icons.arrow_circle_down_rounded,
                            size: 28,
                          ),
                        ),
                  Spacing.w10,
                  (isSharing)
                      ? const CircularProgressIndicator(color: Colors.black, strokeWidth: 3).size(20, 20)
                      : IconButton(
                          onPressed: () async {
                            setState(() {
                              isSharing = true;
                            });
                            await shareImage(widget.customer['photo']);
                            setState(() {
                              isSharing = false;
                            });
                          },
                          icon: const Icon(Icons.share),
                        ),
                ],
              ),
          ],
        ).paddingSymmetric(horizontal: 20, vertical: 20).scrollable,
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

  Widget buildKeyValuePairs({required String key, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            key,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 12,
              letterSpacing: 0.3,
              fontWeight: FontWeight.w600,
              height: 1.3,
            ),
          ),
        ),
        SizedBox(
          width: 180,
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
              height: 1.3,
            ),
          ),
        ),
      ],
    ).paddingOnly(bottom: 5);
  }

  Future<void> shareImage(String imageUrl) async {
    http.Response response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      if (response.statusCode == 200) {
        Directory tempDir = await getTemporaryDirectory();

        File imageFile = File('${tempDir.path}/image.png');

        await imageFile.writeAsBytes(response.bodyBytes);

        SharePlus.instance.share(ShareParams(
          files: [XFile(imageFile.path)],
          text: '${widget.customer['first-name']} ${widget.customer['last-name']}',
          subject: '${widget.customer['email']}',
          sharePositionOrigin: Rect.fromCenter(center: const Offset(0, 0), width: 0, height: 0),
        ));
      } else {
        throw Exception('Failed to load image');
      }
    }
  }

  Future<void> saveImageToGallery(String imageUrl) async {
    await _downloadAndSaveImage(imageUrl);

    Fluttertoast.showToast(msg: 'Image downloaded successfully');
  }

  Future<void> _downloadAndSaveImage(String imageUrl) async {
    try {
      http.Response response = await http.get(Uri.parse(imageUrl));

      await ImageGallerySaverPlus.saveImage(Uint8List.fromList(response.bodyBytes));
    } catch (error) {
      log('Error downloading or saving image: $error');
    }
  }
}
