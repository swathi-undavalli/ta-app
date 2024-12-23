import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' as intl;
import 'package:share_plus/share_plus.dart';
import 'package:temple_ui_tools/styling/alignment_extensions.dart';
import 'package:temple_ui_tools/styling/spacing_widgets.dart';
import 'package:temple_ui_tools/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../features/activities/model/colors_data.dart';
import '../../features/bookings/controller/edit_payments_controller.dart';
import '../../features/bookings/models/booking_model.dart';
import '../../features/bookings/presentation/views/add_payments_view.dart';
import '../../features/bookings/presentation/views/edit_booking_view.dart';
import '../../features/bookings/presentation/views/edit_payments_view.dart';
import '../../features/bookings/presentation/widgets/add_customer_dialog.dart';
import '../../features/bookings/presentation/widgets/app_text_fields.dart';
import '../../features/bookings/presentation/widgets/certification_bottomsheet.dart';
import '../../features/bookings/presentation/widgets/share_booking_details_widget.dart';
import '../../features/bookings/repository/booking_repo.dart';
import '../../features/dive_logs/presentation/widgets/dive_log_bootomsheet.dart';
import '../../features/employees/model/employee.dart';
import '../../features/logs/models/log_model.dart';
import '../../features/logs/presentation/views/log_view.dart';
import '../constants/assets.dart';
import '../constants/constants.dart';
import '../constants/enums.dart';
import '../models/item_model.dart';
import '../util/utils.dart';
import 'access_levels.dart';
import 'app_button.dart';
import 'bookings_calender_widget/bookings_calender_widget_controller_new.dart';
import 'qr_image.dart';
import 'ta_image.dart';

// ignore: must_be_immutable
class BookingsExpansionPanel extends StatelessWidget {
  final ExpansionPanelLogic logic = ExpansionPanelLogic();
  final SearchController searchController = Get.put(SearchController());
  final List<ItemModel>? items;
  bool searchBar = true;
  Function? onDeletePressed;
  Function? onSearchTap;
  List<Widget> expansions = [];
  TextEditingController searchTED = TextEditingController();
  final DateTime selectedDate;

  BookingsCalenderWidgetLogicNew bookingCalenderLogicNew = BookingsCalenderWidgetLogicNew();

  BookingsExpansionPanel({
    super.key,
    this.items,
    this.onDeletePressed,
    this.onSearchTap,
    required this.searchBar,
    required this.selectedDate,
  });

  generateList(List<ItemModel> itemsList) {
    if (itemsList.isEmpty) return [const Text('No Results Found')];
    logic.controller.isExpanded = [];
    expansions = [];
    for (int i = 0; i < itemsList.length; i++) {
      logic.controller.isExpanded.add(false);
      expansions.add(buildExpansion(itemModel: itemsList[i], i: i));
    }
    return expansions;
  }

  final GlobalKey _menuKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchController>(
      builder: (controller) {
        return Column(
          children: [
            if (searchBar == true) buildSearchBar(),
            if (controller.showSearchField)
              ...generateList(
                items!.where((ItemModel item) {
                  if (item.bookingID!.contains(searchTED.text.trim())) return true;
                  if (item.name!.toLowerCase().contains(searchTED.text.trim().toLowerCase())) return true;
                  return false;
                }).toList(),
              )
            else
              ...generateList(items!),
          ],
        );
      },
    );
  }

  ///====================UI==================///

  Widget buildSearchBar() {
    return GetBuilder<SearchController>(
      builder: (controller) {
        return (controller.showSearchField && items!.length > 5)
            ? Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: AnimatedContainer(
                  width: controller.showSearchField ? 380 : 0,
                  duration: const Duration(milliseconds: 500),
                  height: 47,
                  decoration: BoxDecoration(
                    color: AppColors.background.white,
                    // border: Border.all(color: Colors.black, width: 0.50),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search, size: 20, color: AppColors.text.darkgrey),
                      const SizedBox(width: 15),
                      SizedBox(
                        width: controller.showSearchField ? 240 : 0,
                        child: TextField(
                          onTap: () {
                            onSearchTap!();
                          },
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
                            disabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                            hintText: 'Search...',
                            hintStyle: TextStyle(fontSize: 14, height: 1),
                          ),
                          controller: searchTED,
                          onChanged: (text) {
                            searchController.update();
                          },
                        ),
                      ),
                      (searchTED.text != '')
                          ? GestureDetector(
                              onTap: () {
                                searchTED.text = '';
                                searchController.update();
                              },
                              child: Icon(Icons.close_outlined, size: 20, color: AppColors.text.darkgrey),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              )
            : const SizedBox();
      },
    );
  }

  Widget buildExpansion({ItemModel? itemModel, int? i}) {
    getColor() {
      if (itemModel!.bookingModel?.cancelBooking == true) {
        return Colors.red.shade200;
      } else {
        String cc = '';

        if (colorsData!.blue.contains(itemModel.activity)) {
          cc = 'Blue';
        } else if (colorsData!.purple.contains(itemModel.activity)) {
          cc = 'Purple';
        } else if (colorsData!.red.contains(itemModel.activity)) {
          cc = 'Red';
        } else if (colorsData!.green.contains(itemModel.activity)) {
          cc = 'Green';
        } else if (colorsData!.white.contains(itemModel.activity)) {
          cc = 'White';
        }

        if (cc == 'Blue') {
          return const Color(0xffA9EBF8).withOpacity(0.3);
        } else if (cc == 'Purple') {
          return const Color(0xffDDB3FF);
        } else if (cc == 'Red') {
          return const Color(0xffF8FF96);
        } else if (cc == 'Green') {
          return const Color(0xff96F1BD);
        } else if (cc == 'White') {
          return const Color(0xffE0E0E0);
        }
      }
    }

    final button = PopupMenuButton(
      icon: TAImage(
        AppImages.icons.whatsapp,
        color: Colors.green,
        height: 40,
        width: 40,
      ),
      key: _menuKey,
      itemBuilder: (_) => <PopupMenuItem<String>>[
        PopupMenuItem<String>(
          child: const Text(
            'Booking info',
            style: TextStyle(fontSize: 12),
          ),
          onTap: () async {
            if (itemModel != null && itemModel.bookingModel != null) {
              File pdfFile = await ShareBookingDetails.generatePdf(itemModel.bookingModel!);
              Share.shareXFiles([XFile(pdfFile.path)]);
            }
          },
        ),
        if (itemModel?.colorCode == 'Blue')
          PopupMenuItem<String>(
            child: const Text(
              'Confirmation of timing',
              style: TextStyle(fontSize: 12),
            ),
            onTap: () async {
              if (itemModel != null) {
                log(itemModel.phone.toString());
                String phone = itemModel.phone!.replaceAll('+', '');
                String message = """
               Hello "${itemModel.name}"
Hope you are excited to have your scuba diving session. Please note that the time for your boat is ${intl.DateFormat("dd-MM-yyy @ hh:mm a").format(itemModel.bookingModel!.diveDate![0]!)}. Please report to the dive center before 15 minutes. 
Please note that if you are not present at the center by the scheduled time, the boat will leave without you, and there will be no scheduling change or refunds applicable as per our policies.
                         """;

                var uri = 'https://wa.me/$phone?text=$message';
                var encoded = Uri.encodeFull(uri);
                if (!await launchUrl(Uri.parse(encoded), mode: LaunchMode.externalApplication)) {
                  showToast('cannot launch whatsapp');
                }
              }
            },
          ),
        if (itemModel?.colorCode == 'Blue')
          PopupMenuItem<String>(
            child: const Text(
              'Cancellation warning',
              style: TextStyle(fontSize: 12),
            ),
            onTap: () async {
              log('booking cancellation');
              if (itemModel != null) {
                log(itemModel.phone.toString());
                String phone = itemModel.phone!.replaceAll('+', '');
                String message = '''
               Hello "${itemModel.name}"
Please note that you are late for your scheduled ocean dive as part of your Discover Scuba Diving Experience. As previously mentioned in our bookings policies, the boat will leave without you and and we will be unable to reschedule you to a different slot. There will also be no refund for the missed dives. However you can get in touch with our bookings team, who can give you options on how you can schedule another ocean dive session for an added cost.

Regards,

Temple Adventures Dive Operations team
                         ''';

                var uri = 'https://wa.me/$phone?text=$message';
                var encoded = Uri.encodeFull(uri);
                if (!await launchUrl(Uri.parse(encoded), mode: LaunchMode.externalApplication)) {
                  showToast('cannot launch whatsapp');
                }
              }
            },
          ),
        PopupMenuItem<String>(
          child: const Text(
            'Feedback',
            style: TextStyle(fontSize: 12),
          ),
          onTap: () async {
            if (itemModel != null) {
              log(itemModel.phone.toString());
              String phone = itemModel.phone!.replaceAll('+', '');
              String link = 'https://search.google.com/local/writereview?placeid=ChIJAQAAVIZhUzoRzCVTS0w0_uA';
              String message = '''
                If you had a wonderful time diving with us, It would be a great help for us if you can write your experience on Google 😊 or please give us a star ☺️ Thank you for choosing us 🐋
Please click the below link : $link
                         ''';

              var uri = 'https://wa.me/$phone?text=$message';
              var encoded = Uri.encodeFull(uri);
              if (!await launchUrl(Uri.parse(encoded), mode: LaunchMode.externalApplication)) {
                showToast('cannot launch whatsapp');
              }
            }
          },
        ),
        PopupMenuItem<String>(
          child: const Text(
            'Paperwork link',
            style: TextStyle(fontSize: 12),
          ),
          onTap: () async {
            if (itemModel!.bookingModel != null) {
              String bookingId = itemModel.bookingModel!.id!;
              String bs64 = base64.encode(bookingId.codeUnits);
              String link = 'https://templeadventures.com/temple_paperwork/?bookingId=$bs64&author=dGVtcGxl';
              var headers = {
                'x-api-key': 'uSirf5x9fM5iYjPuu8GXS4TVvLbt1tdg9DUe7f7N',
                'Content-Type': 'application/json',
              };
              final result = await http.post(
                Uri.parse('https://api.aws3.link/shorten'),
                body: jsonEncode({
                  'longUrl': link,
                  'expireHours': 48,
                }),
                headers: headers,
              );

              final jsonLink = jsonDecode(result.body)['shortUrl'];

              String phone = itemModel.phone!.replaceAll('+', '');
              String message = '''
                                          *Temple Adventures - Scuba Diving Pondicherry*

Hey *${itemModel.name!.trim().toLowerCase().capitalizeFirst}*,

Thanks for choosing us, we are excited to take you scuba diving with us 😍.

we need *all the divers to complete* the *paperwork process*. Please share this link with them.

*Please complete the paperwork process* by clicking the below link: $jsonLink. This includes _Discover Scuba Diving Form, Medical Form, Liability Releases, Agency NDA and our policies_

                                          ''';
              var uri = 'https://wa.me/$phone?text=$message';
              var encoded = Uri.encodeFull(uri);
              if (!await launchUrl(Uri.parse(encoded), mode: LaunchMode.externalApplication)) {
                showToast('cannot launch whatsapp');
              }
            }
          },
        ),
      ],
    );
    TextEditingController invoiceTED = TextEditingController(text: itemModel?.bookingModel?.invoiceNo ?? '');

    return GetBuilder<ExpansionPanelController>(
      builder: (controller) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInCubic,
          alignment: Alignment.topCenter,
          constraints: BoxConstraints(
            minHeight: (controller.isExpanded[i!] && !(itemModel?.bookingModel?.isQuickBooking ?? true)) ? 500 : 50,
          ),
          width: Screen.width,
          decoration: BoxDecoration(
            color: getColor(),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Flexible(
                              child: Text(
                                itemModel!.name!.toLowerCase().capitalizeFirst!,
                                overflow: TextOverflow.ellipsis,
                                style:
                                    TextStyle(color: AppColors.text.black, fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                            ),
                            Text(
                              ' x ${itemModel.bookingModel!.noOfPersons}',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: AppColors.text.black, fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                            if (bookingCalenderLogicNew.controller.selectedType == FilterType.Pool)
                              Text(
                                "(${intl.DateFormat("hh:mm a").format(itemModel.bookingModel!.poolDate![0]!)})",
                                style:
                                    TextStyle(color: AppColors.text.black, fontSize: 12, fontWeight: FontWeight.w500),
                              ).paddingOnly(left: 5),
                            if (getBalance(
                                  itemModel.bookingModel!.payments!,
                                  double.parse(itemModel.paid).roundToDouble(),
                                  double.parse(itemModel.cost).roundToDouble(),
                                ) !=
                                '0')
                              const Text(
                                '  💵  ',
                                style: TextStyle(fontSize: FontSize.small, color: Colors.grey),
                              ),
                            if (itemModel.bookingModel!.registeredUsers.length == itemModel.bookingModel!.noOfPersons)
                              Icon(
                                Icons.verified,
                                color: AppColors.text.skyBlue,
                                size: 12,
                              ).paddingOnly(left: 3),
                            if (itemModel.bookingModel!.hasMedicalIssues)
                              const Text(
                                '  🏥️',
                                style: TextStyle(fontSize: FontSize.small),
                              ),
                          ],
                        ),
                      ),
                      if (itemModel.bookingModel?.isQuickBooking ?? false)
                        const Text(
                          '  (Quick)',
                          style: TextStyle(fontSize: FontSize.small, fontWeight: FontWeight.bold),
                        ),
                      IconButton(
                        splashRadius: 20,
                        icon: Icon(
                          controller.isExpanded[i]
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.keyboard_arrow_down_rounded,
                        ),
                        onPressed: () {
                          log(itemModel.bookingModel!.registeredUsers.toString());
                          controller.isExpanded[i] = !controller.isExpanded[i];
                          controller.update();
                        },
                      ),
                    ],
                  ),
                  controller.isExpanded[i]
                      ? FutureBuilder(
                          future: Future.delayed(const Duration(milliseconds: 200)),
                          initialData: const SizedBox(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.done) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  const SizedBox(height: 5),
                                  if (!itemModel.bookingModel!.isQuickBooking)
                                    Row(
                                      children: [
                                        const Spacer(),
                                        IconButton(
                                          splashRadius: 20,
                                          icon: Icon(Icons.call_rounded, color: AppColors.background.black),
                                          iconSize: 15,
                                          onPressed: () {
                                            openPhoneApp(itemModel.phone);
                                          },
                                        ),
                                        EmployeeAccess(
                                          access: AccessRights.editBookings,
                                          child: IconButton(
                                            splashRadius: 20,
                                            icon: Icon(Icons.delete, color: AppColors.background.black),
                                            iconSize: 15,
                                            onPressed: () {
                                              if (itemModel.bookingModel?.cancelBooking != true) {
                                                _bookingCancellationDialog(context, itemModel);
                                              } else {
                                                showToast('Booking Cancelled successfully');
                                              }
                                            },
                                          ),
                                        ),
                                        EmployeeAccess(
                                          access: AccessRights.editBookings,
                                          child: IconButton(
                                            splashRadius: 20,
                                            icon: Icon(Icons.edit, color: AppColors.background.black),
                                            iconSize: 15,
                                            onPressed: () {
                                              Navigator.push(context, EditBookingView.route(itemModel.bookingModel!));
                                            },
                                          ),
                                        ),
                                      ],
                                    ).paddingOnly(bottom: 15),
                                  if (itemModel.bookingModel!.isQuickBooking)
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(context, EditBookingView.route(itemModel.bookingModel!));
                                          },
                                          child: Text(
                                            'Edit',
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: AppColors.text.black,
                                              fontFamily: AppFonts.nunito,
                                              decoration: TextDecoration.underline,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        EmployeeAccess(
                                          access: AccessRights.editBookings,
                                          child: IconButton(
                                            splashRadius: 20,
                                            icon: Icon(Icons.edit, color: AppColors.background.black),
                                            iconSize: 15,
                                            onPressed: () {
                                              Navigator.push(context, EditBookingView.route(itemModel.bookingModel!));
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  if (itemModel.bookingModel?.cancellationReason != null &&
                                      itemModel.bookingModel?.cancellationReason != '')
                                    SizedBox(
                                      width: Screen.width,
                                      child: RichText(
                                        text: TextSpan(
                                          text: 'Cancellation Reason : ',
                                          style: TextStyle(
                                            fontFamily: AppFonts.nunito,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.text.black,
                                            fontSize: 13,
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: itemModel.bookingModel?.cancellationReason,
                                              style: TextStyle(
                                                color: Colors.grey[700],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ).paddingOnly(right: 10, bottom: 15),
                                    ),
                                  buildKeyValuePairs('Booking Id', itemModel.bookingID!),
                                  buildKeyValuePairs('Activity', itemModel.activity),
                                  if (!itemModel.bookingModel!.isQuickBooking)
                                    buildKeyValuePairs(
                                      'Total Cost',
                                      double.parse(itemModel.cost).roundToDouble().toString(),
                                    ),
                                  if (!itemModel.bookingModel!.isQuickBooking)
                                    buildKeyValuePairs(
                                      'Deposit',
                                      double.parse(itemModel.paid).roundToDouble().toString(),
                                    ),
                                  if (!itemModel.bookingModel!.isQuickBooking)
                                    buildKeyValuePairs(
                                      'Balance',
                                      getBalance(
                                        itemModel.bookingModel!.payments!,
                                        double.parse(itemModel.paid).roundToDouble(),
                                        double.parse(itemModel.cost).roundToDouble(),
                                      ),
                                    ),
                                  buildKeyValuePairs('Pax', itemModel.bookingModel!.noOfPersons.toString()),
                                  if (!itemModel.bookingModel!.isQuickBooking)
                                    (itemModel.receiptNo != null)
                                        ? buildKeyValuePairs('Invoice no', itemModel.receiptNo!)
                                        : buildKeyValuePairs('Invoice no', '-'),
                                  if (!itemModel.bookingModel!.isQuickBooking)
                                    (itemModel.remarks == '')
                                        ? buildKeyValuePairs('Remarks', '-')
                                        : buildKeyValuePairs('Remarks', itemModel.remarks.toString()),
                                  if (!itemModel.bookingModel!.isQuickBooking)
                                    buildKeyValuePairs('Phone', itemModel.phone!),
                                  if (!itemModel.bookingModel!.isQuickBooking)
                                    buildKeyValuePairs('Email', itemModel.email!),
                                  buildKeyValuePairs('Time', itemModel.time),
                                  buildKeyValuePairs('Date', itemModel.date),
                                  buildKeyValuePairs('Session', itemModel.session),
                                  if (!itemModel.bookingModel!.isQuickBooking)
                                    buildKeyValuePairs(
                                      'Registered',
                                      '${itemModel.bookingModel!.registeredUsers.length} / ${itemModel.bookingModel!.noOfPersons}',
                                      isDanger: ((itemModel.bookingModel!.registeredUsers.length) !=
                                          (itemModel.bookingModel!.noOfPersons)),
                                    ),
                                  Spacing.h20,
                                  if (!itemModel.bookingModel!.isQuickBooking)
                                    buildPaymentStatus(
                                      context,
                                      itemModel: itemModel,
                                      totalAmount: itemModel.bookingModel!.totalCost,
                                      payments: [
                                        PaymentModel(
                                          amount: double.parse(itemModel.paid).roundToDouble(),
                                          collectedBy: itemModel.employeeName,
                                          reciptNo: itemModel.receiptNo,
                                          referenceNo: itemModel.bookingModel!.paymentTransactionId,
                                          remarks: '',
                                          paymentMode: itemModel.bookingModel!.paymentMode,
                                          time: itemModel.bookingModel!.createdAt,
                                        ),
                                        ...itemModel.bookingModel!.payments!,
                                      ],
                                    ),
                                  Spacing.h10,
                                  if ((!itemModel.bookingModel!.isQuickBooking))
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Row(
                                          children: [
                                            Text(
                                              'Doctor Required',
                                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                            ),
                                            SizedBox(width: 15),
                                            Icon(Icons.medication, size: 20),
                                          ],
                                        ),
                                        Spacing.h10,
                                        for (int i = 0; ((i < itemModel.bookingModel!.pax!.length)); i++)
                                          if (itemModel.bookingModel!.pax![i]['needDoctor'] == true)
                                            SizedBox(
                                              height: 30,
                                              child: Row(
                                                children: [
                                                  IconButton(
                                                    splashRadius: 15,
                                                    padding: EdgeInsets.zero,
                                                    icon: Icon(
                                                      Icons.delete,
                                                      color: AppColors.background.black,
                                                      size: 15,
                                                    ),
                                                    iconSize: 15,
                                                    onPressed: () async {
                                                      Booking booking = itemModel.bookingModel!;
                                                      booking.pax![i]['needDoctor'] = false;
                                                      await FirebaseFirestore.instance
                                                          .collection('bookings')
                                                          .doc(itemModel.bookingID)
                                                          .set(booking.toMap());
                                                      BookingsCalenderWidgetControllerNew controller =
                                                          BookingsCalenderWidgetControllerNew();
                                                      BookingsCalenderWidgetLogicNew calenderLogic =
                                                          BookingsCalenderWidgetLogicNew();
                                                      DateTime date = controller.selectedDate;
                                                      calenderLogic.getBookings(date);
                                                    },
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Text(
                                                    itemModel.bookingModel!.pax![i]['first-name'] +
                                                        itemModel.bookingModel!.pax![i]['last-name'],
                                                    style: const TextStyle(fontSize: FontSize.small),
                                                  ),
                                                  const Spacer(),
                                                  IconButton(
                                                    splashRadius: 15,
                                                    padding: EdgeInsets.zero,
                                                    icon: Icon(
                                                      Icons.call_rounded,
                                                      color: AppColors.background.black,
                                                      size: 15,
                                                    ),
                                                    iconSize: 15,
                                                    onPressed: () {
                                                      openPhoneApp(itemModel.bookingModel!.pax![i]['phoneNumber']);
                                                    },
                                                  ),
                                                ],
                                              ).paddingOnly(right: 20),
                                            ),
                                        const SizedBox(height: 20),
                                      ],
                                    ),
                                  if (itemModel.colorCode != 'Blue' && (!itemModel.bookingModel!.isQuickBooking))
                                    Row(
                                      children: [
                                        if (itemModel.colorCode != 'Blue' && itemModel.isCustomerBooking)
                                          AppButton.miniFlat(
                                            onTap: () {
                                              CertificationBottomSheet.show(
                                                context,
                                                itemModel: itemModel,
                                                selectedDate: selectedDate,
                                              );
                                            },
                                            text: 'Manage Certs',
                                          ),
                                        const Spacer(),
                                        AppButton.miniFlat(
                                          text: 'E-Learning',
                                          onTap: () async {
                                            String message = """
        *E-Learning request details:* 
        
        First Name : *${itemModel.name!.trim().toLowerCase().capitalizeFirst}* 
        Last Name : *${(itemModel.bookingModel!.details!.lastName != "") ? itemModel.bookingModel!.details!.lastName : "-"}* 
        Email : *${itemModel.email}* 
        Date of Birth : *${intl.DateFormat("dd-MM-yyy").format((itemModel.bookingModel!.details?.dob)?.toDate() ?? DateTime.now())}* 
        Course Name : *${itemModel.activity}* 
        Invoice No : *${(itemModel.bookingModel?.receiptNo != null && itemModel.bookingModel?.receiptNo != '') ? itemModel.bookingModel?.receiptNo : '-'}* 
        Phone Number : *${itemModel.bookingModel!.details!.phoneNumber}* 
         
        Regards,
        *${currentEmployee!.name.trim()}*
                                        """;
                                            await Clipboard.setData(ClipboardData(text: message));
                                            Fluttertoast.showToast(msg: 'Message copied to Clipboard');
                                          },
                                        ).paddingOnly(right: 15),
                                      ],
                                    ),
                                  Row(
                                    children: [
                                      if (itemModel.colorCode != 'Blue' && itemModel.isCustomerBooking)
                                        AppButton.miniFlat(
                                          text: 'Add Log',
                                          onTap: () {
                                            DiveLogBottomSheet.show(
                                              context,
                                              bookingModel: itemModel.bookingModel!,
                                              date: selectedDate,
                                            );
                                          },
                                        ),
                                      const Spacer(),
                                      if (!itemModel.bookingModel!.isQuickBooking) button,
                                      if (!itemModel.bookingModel!.isQuickBooking)
                                        AppButton.miniFlat(
                                          text: 'PaperWork',
                                          bgColor: AppColors.text.green.withOpacity(0.8),
                                          onTap: () async {
                                            String bookingId = itemModel.bookingModel!.id!;
                                            String bs64 = base64.encode(bookingId.codeUnits);
                                            String link =
                                                'https://templeadventures.com/temple_paperwork/?bookingId=$bs64&author=dGVtcGxl';

                                            showModalBottomSheet(
                                              backgroundColor: Colors.transparent,
                                              isScrollControlled: true,
                                              context: context,
                                              useRootNavigator: true,
                                              builder: (context) {
                                                return Container(
                                                  padding: EdgeInsets.only(
                                                    bottom: MediaQuery.of(context).viewInsets.bottom,
                                                    top: 30,
                                                    left: 30,
                                                    right: 30,
                                                  ),
                                                  decoration: const BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.only(
                                                      topLeft: Radius.circular(15),
                                                      topRight: Radius.circular(15),
                                                    ),
                                                  ),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          SizedBox(
                                                            width: 150,
                                                            child: Text(
                                                              '${itemModel.name!.capitalizeFirst!}x${itemModel.pax}',
                                                              style: const TextStyle(
                                                                fontWeight: FontWeight.w600,
                                                                fontSize: FontSize.textSize,
                                                              ),
                                                              overflow: TextOverflow.ellipsis,
                                                            ),
                                                          ),
                                                          const Spacer(),
                                                          Material(
                                                            color: Colors.transparent,
                                                            child: InkWell(
                                                              highlightColor: Colors.blue.withOpacity(0.2),
                                                              splashColor: Colors.grey.withOpacity(0.3),
                                                              borderRadius: BorderRadius.circular(20),
                                                              radius: 100,
                                                              onTap: () {
                                                                Navigator.pop(context);
                                                                // provider.onCancelPressed();
                                                              },
                                                              child: const Icon(Icons.close),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 50),
                                                      Container(
                                                        height: 50,
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(20),
                                                          color: AppColors.text.lightSkyBlue.withOpacity(0.1),
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            const SizedBox(width: 15),
                                                            const SizedBox(
                                                              width: 200,
                                                              child: Text(
                                                                'temple_paperwork/?bookingId..',
                                                                overflow: TextOverflow.ellipsis,
                                                              ),
                                                            ),
                                                            const Spacer(),
                                                            IconButton(
                                                              onPressed: () async {
                                                                await Clipboard.setData(
                                                                  ClipboardData(text: link),
                                                                );
                                                                Fluttertoast.showToast(
                                                                  msg: 'Link copied to Clipboard',
                                                                );
                                                              },
                                                              icon: const Icon(Icons.copy_outlined, size: 20),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(height: 50),
                                                      Container(
                                                        alignment: Alignment.center,
                                                        child: QRImage(
                                                          height: 150,
                                                          width: 150,
                                                          data:
                                                              'https://templeadventures.com/temple_paperwork/?bookingId=$bs64&author=dGVtcGxl',
                                                        ),
                                                      ),
                                                      const SizedBox(height: 50),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        ).paddingOnly(right: 15),
                                    ],
                                  ),
                                  AppTextField(
                                    controller: invoiceTED,
                                    hintText: 'Invoice No',
                                    minLines: 3,
                                    errorValidator: () {
                                      return null;
                                    },
                                    validator: (_) {
                                      return null;
                                    },
                                  ),
                                  const Text(
                                    'Notes wont be saved until "Update Notes" button is pressed',
                                    style: TextStyle(
                                      fontSize: 10,
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: AppButton.miniFlat(
                                      text: 'Update Notes',
                                      onTap: () async {
                                        itemModel.bookingModel =
                                            itemModel.bookingModel?.copyWith(invoiceNo: invoiceTED.text);
                                        await FirebaseFirestore.instance
                                            .collection('bookings')
                                            .doc(itemModel.bookingModel?.id)
                                            .set(itemModel.bookingModel!.toMap());
                                        controller.update();
                                      },
                                    ),
                                  ).paddingOnly(right: 10),
                                  Spacing.h20,
                                  Row(
                                    children: [
                                      if (itemModel.employeeName != null)
                                        Container(
                                          alignment: Alignment.centerRight,
                                          child: RichText(
                                            text: TextSpan(
                                              text: 'Created By : ',
                                              style: TextStyle(
                                                fontFamily: AppFonts.nunito,
                                                color: AppColors.text.darkgrey,
                                                fontSize: 10,
                                              ),
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text: itemModel.employeeName,
                                                  style: const TextStyle(
                                                    color: Color(0xff484646),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      const Spacer(),
                                      AppButton.miniFlat(
                                        text: 'Manage PAX',
                                        onTap: () async {
                                          Booking? bookingModel = itemModel.bookingModel;
                                          showModalBottomSheet(
                                            backgroundColor: Colors.transparent,
                                            isScrollControlled: true,
                                            context: context,
                                            useRootNavigator: true,
                                            builder: (context) {
                                              return Container(
                                                padding: EdgeInsets.only(
                                                  bottom: MediaQuery.of(context).viewInsets.bottom,
                                                  top: 30,
                                                  left: 20,
                                                  right: 20,
                                                ),
                                                constraints: const BoxConstraints(minHeight: 300),
                                                decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(15),
                                                    topRight: Radius.circular(15),
                                                  ),
                                                ),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Spacing.h10,
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                          width: 150,
                                                          child: Text(
                                                            '${itemModel.name!.capitalizeFirst!} X ${itemModel.pax}',
                                                            style: const TextStyle(
                                                              fontWeight: FontWeight.w600,
                                                              fontSize: FontSize.textSize,
                                                            ),
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        ),
                                                        const Spacer(),
                                                        Material(
                                                          color: Colors.transparent,
                                                          child: InkWell(
                                                            highlightColor: Colors.blue.withOpacity(0.2),
                                                            splashColor: Colors.grey.withOpacity(0.3),
                                                            borderRadius: BorderRadius.circular(20),
                                                            radius: 100,
                                                            onTap: () {
                                                              Navigator.pop(context);
                                                            },
                                                            child: const Icon(Icons.close).paddingAll(5),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Spacing.h20,
                                                    ...bookingModel!.pax!.asMap().entries.map(
                                                      (e) {
                                                        int index = e.key;
                                                        String? email = e.value['email'];
                                                        return Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Column(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(email!),
                                                                if (bookingModel.isPaperworkDone(index))
                                                                  const Text(
                                                                    'Paperwork completed',
                                                                    style: TextStyle(fontSize: 10),
                                                                  ),
                                                              ],
                                                            ),
                                                            IconButton(
                                                              onPressed: () {
                                                                onDeletePaxPressed(context, bookingModel, index);
                                                              },
                                                              icon: const Icon(
                                                                Icons.delete,
                                                                size: 20,
                                                                color: Colors.black,
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    ),
                                                    buildAddCustomerButton(context, bookingModel),
                                                  ],
                                                ).scrollable,
                                              );
                                            },
                                          );
                                        },
                                      ).paddingOnly(right: 15),
                                    ],
                                  ),
                                  Spacing.h20,
                                ],
                              );
                            }
                            return const SizedBox();
                          },
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
        ).paddingOnly(bottom: 15);
      },
    );
  }

  Widget buildAddCustomerButton(context, Booking bookingModel) {
    if (bookingModel.pax!.length < bookingModel.noOfPersons!) {
      return AppButton.miniFlat(
        text: 'Add Customer',
        onTap: () {
          AddCustomerDialog.show(
            context,
            bookingModel: bookingModel,
          );
        },
      ).paddingSymmetric(horizontal: 20);
    }
    return const SizedBox();
  }

  Future<void> _bookingCancellationDialog(BuildContext context, ItemModel itemModel) async {
    return showDialog(
      context: context,
      builder: (context) {
        bool isProcessing = false;

        return AlertDialog(
          title: const Text(
            'Cancellation Reason',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          content: AppTextField(
            controller: logic.controller.cancelMessage,
            hintText: 'Reason',
            maxLines: 2,
            errorValidator: () {
              return null;
            },
            validator: (_) {
              return null;
            },
          ),
          actions: <Widget>[
            AppButton.miniText(
              text: 'Cancel',
              onTap: () {
                Navigator.pop(context);
                logic.controller.cancelMessage.text = '';
              },
            ),
            AppButton.miniFlat(
              text: 'Okay',
              onTap: () async {
                if (!isProcessing) {
                  isProcessing = true;
                  String reason = logic.controller.cancelMessage.text.trim();

                  if (reason != '') {
                    /// do delete.
                    //remove assigned boats
                    if (itemModel.bookingModel?.boatDetails?.boat != null) {
                      await BookingRepo.removeBoat(
                        bookingModel: itemModel.bookingModel!,
                        selectedDate: bookingCalenderLogicNew.controller.selectedDate,
                      );
                    }

                    //set cancellation to true.
                    await FirebaseFirestore.instance
                        .collection('bookings')
                        .doc(itemModel.bookingModel!.id)
                        .set({'cancelBooking': true, 'cancellationReason': reason}, SetOptions(merge: true));

                    //add logs
                    LogModel logModel = LogModel(type: LogType.bookingDeleted, bookingId: itemModel.bookingModel!.id);
                    await FirebaseFirestore.instance.collection('logs').doc().set(logModel.toMap());

                    // reset ted
                    logic.controller.cancelMessage.text = '';
                    if (context.mounted) {
                      Navigator.pop(context);
                    }

                    // refresh bookings
                    BookingsCalenderWidgetLogicNew bookingCalenderLogic = BookingsCalenderWidgetLogicNew();
                    bookingCalenderLogic.onDateSelected(DateTime.now());
                  } else {
                    //show error.
                    showToast('Please add cancellation Reason');
                  }
                  isProcessing = false;
                } else {
                  showToast('Please wait while deleting');
                }
              },
            ),
          ],
        );
      },
    );
  }

  openPhoneApp(String? phoneNumber) async {
    String url = 'tel:$phoneNumber';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget buildKeyValuePairs(String key, String value, {bool isDanger = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            key,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 13,
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
            // overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: isDanger ? Colors.red : Colors.black,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildPaymentStatus(
    BuildContext context, {
    required double totalAmount,
    required List<PaymentModel> payments,
    required ItemModel? itemModel,
  }) {
    double deposits = 0.0;

    for (var payment in payments) {
      deposits += payment.amount!;
    }

    int n = payments.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 1,
                    color: (totalAmount == deposits) ? Colors.green.shade400 : Colors.black,
                  ),
                ),
              ],
            ).paddingOnly(top: 7, left: 16, right: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: n,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List<Widget>.generate(n, (i) {
                      return buildCircle(color: Colors.black);
                    }),
                  ),
                ),
                (totalAmount == deposits)
                    ? const SizedBox()
                    : Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            buildCircle(color: Colors.red),
                          ],
                        ),
                      ),
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 39,
                        child: Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(color: AppColors.text.skyBlue, shape: BoxShape.circle),
                          child: Icon(
                            Icons.circle,
                            size: 10,
                            color: AppColors.text.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: n,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List<Widget>.generate(n, (i) {
                      return buildNumber(
                        text: payments[i].amount!.round().toString(),
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      );
                    }),
                  ),
                ),
                (totalAmount == deposits)
                    ? const SizedBox()
                    : Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            buildNumber(
                              text: (totalAmount - deposits).round().toString(),
                              // text: "16000",
                              color: Colors.red,
                              fontWeight: FontWeight.normal,
                            ),
                          ],
                        ),
                      ),
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      buildNumber(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        text: totalAmount.round().toString(),
                      ),
                    ],
                  ),
                ),
              ],
            ).paddingOnly(top: 20),
          ],
        ).paddingOnly(right: 20),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () {
            EditPaymentsLogic editPaymentsLogic = EditPaymentsLogic();
            editPaymentsLogic.controller.bookingModel = itemModel!.bookingModel;
            Navigator.push(context, EditPaymentsView.route());
          },
          child: Row(
            children: [
              const Text(
                'Edit Payments',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 20),
              const Icon(Icons.edit, size: 15),
              const Spacer(),
              AppButton.miniFlat(
                text: 'Add Payment',
                onTap: () {
                  Navigator.push(context, AddPaymentsView.route(itemModel!.bookingModel!));
                },
              ).paddingOnly(right: 15),
            ],
          ),
        ),
        const SizedBox(height: 20),
        ...List.generate(
          payments.length,
          (index) {
            return buildTransactions(payment: payments[index]);
          },
        ),
      ],
    );
  }

  Widget buildTransactions({required PaymentModel payment}) {
    DateTime now = DateTime.now();
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 8,
          width: 8,
          decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(10)),
        ).paddingOnly(top: 2),
        const SizedBox(width: 10),
        SizedBox(
          width: Screen.width - 73,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Payment ${payment.amount!.round()} by ${payment.paymentMode ?? "-"} collected by ${payment.collectedBy}",
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  wordSpacing: 2,
                ),
              ),
              const SizedBox(height: 2),
              if (payment.time != null &&
                  now.day == payment.time!.day &&
                  now.month == payment.time!.month &&
                  now.year == payment.time!.year)
                Text(
                  "Today - ${intl.DateFormat("hh:mm a").format(payment.time!)}",
                  style: TextStyle(fontSize: 10, color: AppColors.text.darkgrey),
                )
              else if (payment.time != null)
                Text(
                  intl.DateFormat('EEE dd MMM yy - hh:mm a').format(payment.time!),
                  style: TextStyle(fontSize: 10, color: AppColors.text.darkgrey),
                )
              else
                Text(
                  'Initial Deposit',
                  style: TextStyle(fontSize: 10, color: AppColors.text.darkgrey),
                ),
            ],
          ),
        ),
      ],
    ).paddingOnly(bottom: 10);
  }

  Widget buildCircle({Color? color}) {
    return SizedBox(
      width: 39,
      child: Icon(
        Icons.circle,
        size: 10,
        color: color,
      ),
    );
  }

  Widget buildNumber({FontWeight? fontWeight, Color? color, required String text}) {
    return SizedBox(
      width: 39,
      child: Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 10, fontWeight: fontWeight, color: color),
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

  Future<void> onDeletePaxPressed(BuildContext context, Booking bookingModel, int index) async {
    Get.defaultDialog(
      contentPadding: const EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 30),
      title: '\nAre You Sure ? ',
      middleText: "Booking PAX (${bookingModel.pax![index]["email"]}) will Be Deleted Permanently.",
      backgroundColor: Colors.white,
      titleStyle: TextStyle(
        color: AppColors.text.black,
        fontFamily: AppFonts.nunito,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      middleTextStyle: TextStyle(
        color: AppColors.text.black,
        fontFamily: AppFonts.nunito,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      confirm: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppButton.miniText(
            text: 'Cancel',
            onTap: () {
              Navigator.pop(context);
            },
          ),
          AppButton.miniFlat(
            text: 'OK',
            onTap: () async {
              bookingModel.pax!.removeAt(index);
              FirebaseFirestore.instance.collection('bookings').doc(bookingModel.id).set(bookingModel.toMap());
              LogModel logModel = LogModel(type: LogType.bookingPaxDeleted, bookingId: bookingModel.id);
              FirebaseFirestore.instance.collection('logs').doc().set(logModel.toMap());
              Navigator.pop(context);
              Navigator.pop(context);
              BookingsCalenderWidgetLogicNew bookingCalenderLogic = BookingsCalenderWidgetLogicNew();
              bookingCalenderLogic.onDateSelected(
                DateTime.now(),
              );
            },
          ),
        ],
      ),
      barrierDismissible: false,
      radius: 10,
    );
  }
}

class ExpansionPanelLogic {
  ExpansionPanelController controller = Get.put(ExpansionPanelController());
}

class ExpansionPanelController extends GetxController {
  List<bool> isExpanded = [];
  bool showLoading = false;

  TextEditingController cancelMessage = TextEditingController();
}

class SearchController extends GetxController {
  bool _showSearchField = true;

  bool get showSearchField => _showSearchField;

  set showSearchField(bool value) {
    _showSearchField = value;
    update();
  }
}
