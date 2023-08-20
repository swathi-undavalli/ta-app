import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:share/share.dart';
import 'package:temple_adventures/core/constants/assets.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/constants/enums.dart';
import 'package:temple_adventures/core/util/app-func.dart';
import 'package:temple_adventures/core/util/ta-image.dart';
import 'package:temple_adventures/core/widgets/app-button.dart';
import 'package:temple_adventures/core/widgets/bookings_calender_widget/bookings_calender_widget_controller_new.dart';
import 'package:temple_adventures/access_levels.dart';
import 'package:temple_adventures/core/widgets/qr-image.dart';
import 'package:temple_adventures/features/bookings/controller/edit-payments-controller.dart';
import 'package:temple_adventures/features/bookings/models/booking-model.dart';
import 'package:intl/intl.dart' as intl;
import 'package:temple_adventures/features/bookings/presentation/screens/add-payments-screen.dart';
import 'package:temple_adventures/features/bookings/presentation/screens/edit-payments-screen.dart';
import 'package:temple_adventures/features/bookings/presentation/widgets/app-text-fields.dart';
import 'package:temple_adventures/features/bookings/presentation/widgets/share_bookingDetails_widget.dart';
import 'package:temple_adventures/features/edit-booking/presentation/screens/edit-booking-new-screen.dart';
import 'package:temple_adventures/features/home/model/employee.dart';
import 'package:temple_adventures/features/logs/models/log-model.dart';
import 'package:temple_adventures/features/logs/presentation/screens/log-screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import '../../features/home/model/colors_data.dart';

// ignore: must_be_immutable
class BookingsExpansionPanel extends StatelessWidget {
  final ExpansionPanelLogic logic = ExpansionPanelLogic();
  final SearchController searchController = Get.put(SearchController());
  final List<ItemModel>? items;
  bool searchBar = true;
  Function? onDeletePressed;
  Function? onSearchTap;
  List<Widget> expansions = [];
  TextEditingController depositTED = TextEditingController();
  TextEditingController searchTED = TextEditingController();

  BookingsCalenderWidgetLogicNew bookingCalenderLogicNew =
      BookingsCalenderWidgetLogicNew();

  BookingsExpansionPanel(
      {this.items,
      this.onDeletePressed,
      this.onSearchTap,
      required this.searchBar});

  generateList(List<ItemModel> itemsList) {
    if (itemsList.isEmpty) return [Text("No Results Found")];
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
    return GetBuilder<SearchController>(builder: (controller) {
      return Column(
        children: [
          if (searchBar == true) buildSearchBar(),
          if (controller.showSearchField)
            ...generateList(items!.where((ItemModel item) {
              if (item.bookingID!.contains(searchTED.text.trim())) return true;
              if (item.name!
                  .toLowerCase()
                  .contains(searchTED.text.trim().toLowerCase())) return true;
              return false;
            }).toList())
          else
            ...generateList(items!)
        ],
      );
    });
  }

  ///====================UI==================///

  Widget buildSearchBar() {
    return GetBuilder<SearchController>(builder: (controller) {
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
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search,
                        size: 20, color: AppColors.text.darkgrey),
                    SizedBox(width: 15),
                    Container(
                      width: controller.showSearchField ? 240 : 0,
                      child: TextField(
                        onTap: () {
                          onSearchTap!();
                        },
                        decoration: InputDecoration(
                            enabledBorder:
                                OutlineInputBorder(borderSide: BorderSide.none),
                            focusedBorder:
                                OutlineInputBorder(borderSide: BorderSide.none),
                            disabledBorder:
                                OutlineInputBorder(borderSide: BorderSide.none),
                            hintText: 'Search...',
                            hintStyle: TextStyle(fontSize: 14, height: 1)),
                        controller: searchTED,
                        onChanged: (text) {
                          searchController.update();
                        },
                      ),
                    ),
                    (searchTED.text != "")
                        ? GestureDetector(
                            onTap: () {
                              searchTED.text = "";
                              searchController.update();
                            },
                            child: Icon(Icons.close_outlined,
                                size: 20, color: AppColors.text.darkgrey),
                          )
                        : SizedBox(),
                  ],
                ),
              ),
            )
          : SizedBox();
    });
  }

  Widget buildExpansion({ItemModel? itemModel, int? i}) {
    getColor() {
      if (itemModel!.bookingModel?.cancelBooking == true) {
        return Colors.red.shade200;
      } else {
        String cc = '';

        if (colorsData!.blue.contains(itemModel.activity))
          cc = "Blue";
        else if (colorsData!.purple.contains(itemModel.activity))
          cc = "Purple";
        else if (colorsData!.red.contains(itemModel.activity))
          cc = "Red";
        else if (colorsData!.green.contains(itemModel.activity))
          cc = "Green";
        else if (colorsData!.white.contains(itemModel.activity)) cc = "White";

        if (cc == "Blue")
          return Color(0xffA9EBF8).withOpacity(0.3);
        else if (cc == "Purple")
          return Color(0xffDDB3FF);
        else if (cc == "Red")
          return Color(0xffF8FF96);
        else if (cc == "Green")
          return Color(0xff96F1BD);
        else if (cc == "White") return Color(0xffE0E0E0);
      }
    }

    final button = PopupMenuButton(
      icon: TAImage(
        AppImages.icon.whatsapp,
        color: Colors.green,
        height: 40,
        width: 40,
      ),
      key: _menuKey,
      itemBuilder: (_) => <PopupMenuItem<String>>[
        PopupMenuItem<String>(
          child: Text(
            'Booking info',
            style: TextStyle(fontSize: 12),
          ),
          onTap: () async {
            if (itemModel != null && itemModel.bookingModel != null) {
              File pdfFile = await ShareBookingDetails.generatePdf(
                  itemModel.bookingModel!);
              Share.shareFiles([pdfFile.path]);
            }
          },
        ),
        PopupMenuItem<String>(
          child: Text(
            'Confirmation of timing',
            style: TextStyle(fontSize: 12),
          ),
          onTap: () async {
            if (itemModel != null) {
              log(itemModel.phone.toString());
              String phone = itemModel.phone!.replaceAll("+", "");
              String message = """
               Hello "${itemModel.name}"
Hope you are excited to have your scuba diving session. Please note that the time for your boat is ${intl.DateFormat("dd-MM-yyy @ hh:mm a").format(itemModel.bookingModel!.diveDate![0]!)}. Please report to the dive center before 15 minutes. 
Please note that if you are not present at the center by the scheduled time, the boat will leave without you, and there will be no scheduling change or refunds applicable as per our policies.
                         """;

              var uri = "https://wa.me/$phone?text=$message";
              var encoded = Uri.encodeFull(uri);
              if (!await launchUrl(Uri.parse(encoded),
                  mode: LaunchMode.externalApplication)) {
                showToast("cannot launch whatsapp");
              }
            }
          },
        ),
        PopupMenuItem<String>(
          child: Text(
            'Cancellation warning',
            style: TextStyle(fontSize: 12),
          ),
          onTap: () async {
            log("booking cancellation");
            if (itemModel != null) {
              log(itemModel.phone.toString());
              String phone = itemModel.phone!.replaceAll("+", "");
              String message = """
               Hello "${itemModel.name}"
Please note that you are late for your scheduled ocean dive as part of your Discover Scuba Diving Experience. As previously mentioned in our bookings policies, the boat will leave without you and and we will be unable to reschedule you to a different slot. There will also be no refund for the missed dives. However you can get in touch with our bookings team, who can give you options on how you can schedule another ocean dive session for an added cost.

Regards,

Temple Adventures Dive Operations team
                         """;

              var uri = "https://wa.me/$phone?text=$message";
              var encoded = Uri.encodeFull(uri);
              if (!await launchUrl(Uri.parse(encoded),
                  mode: LaunchMode.externalApplication)) {
                showToast("cannot launch whatsapp");
              }
            }
          },
        ),
        PopupMenuItem<String>(
          child: Text(
            'Feedback',
            style: TextStyle(fontSize: 12),
          ),
          onTap: () async {
            if (itemModel != null) {
              log(itemModel.phone.toString());
              String phone = itemModel.phone!.replaceAll("+", "");
              String link =
                  "https://search.google.com/local/writereview?placeid=ChIJAQAAVIZhUzoRzCVTS0w0_uA";
              String message = """
                If you had a wonderful time diving with us, It would be a great help for us if you can write your experience on Google 😊 or please give us a star ☺️ Thank you for choosing us 🐋
Please click the below link : $link
                         """;

              var uri = "https://wa.me/$phone?text=$message";
              var encoded = Uri.encodeFull(uri);
              if (!await launchUrl(Uri.parse(encoded),
                  mode: LaunchMode.externalApplication)) {
                showToast("cannot launch whatsapp");
              }
            }
          },
        ),
        PopupMenuItem<String>(
          child: Text(
            'Paperwork link',
            style: TextStyle(fontSize: 12),
          ),
          onTap: () async {
            if (itemModel!.bookingModel != null) {
              String bookingId = itemModel.bookingModel!.id!;
              String bs64 = base64.encode(bookingId.codeUnits);
              print(bs64);
              String link =
                  "https://templeadventures.com/temple_paperwork/?bookingId=$bs64&author=dGVtcGxl&paperwork_id=MTQ=";
              log(link);

              var headers = {
                "x-api-key": "uSirf5x9fM5iYjPuu8GXS4TVvLbt1tdg9DUe7f7N",
                "Content-Type": "application/json"
              };
              final result = await http.post(
                Uri.parse('https://api.aws3.link/shorten'),
                body: jsonEncode({
                  "longUrl": link,
                  "expireHours": 48,
                }),
                headers: headers,
              );

              final jsonLink = jsonDecode(result.body)["shortUrl"];

              String phone = itemModel.phone!.replaceAll("+", "");
              String message = """
                                          *Temple Adventures - Scuba Diving Pondicherry*

Hey *${itemModel.name!.trim().toLowerCase().capitalizeFirst}*,

Thanks for choosing us, we are excited to take you scuba diving with us 😍.

we need *all the divers to complete* the *paperwork process*. Please share this link with them.

*Please complete the paperwork process* by clicking the below link: $jsonLink. This includes _Discover Scuba Diving Form, Medical Form, Liability Releases, Agency NDA and our policies_

                                          """;
              var uri = "https://wa.me/$phone?text=$message";
              var encoded = Uri.encodeFull(uri);
              if (!await launchUrl(Uri.parse(encoded),
                  mode: LaunchMode.externalApplication)) {
                showToast("cannot launch whatsapp");
              }
            }
          },
        ),
      ],
    );

    return GetBuilder<ExpansionPanelController>(builder: (controller) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInCubic,
          alignment: Alignment.topCenter,
          constraints: BoxConstraints(
            minHeight: (controller.isExpanded[i!] &&
                    !(itemModel?.bookingModel?.isQuickBooking ?? true))
                ? 500
                : 50,
          ),
          width: Get.width,
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
                                  itemModel!.name!
                                      .toLowerCase()
                                      .capitalizeFirst!,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: AppColors.text.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Text(
                                " x " +
                                    (itemModel.bookingModel!.noOfPersons
                                        .toString()),
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: AppColors.text.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              ),
                              if (bookingCalenderLogicNew
                                      .controller.selectedType ==
                                  FilterType.Pool)
                                Text(
                                  "(${intl.DateFormat("hh:mm a").format(itemModel.bookingModel!.poolDate![0]!)})",
                                  style: TextStyle(
                                      color: AppColors.text.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500),
                                ).paddingOnly(left: 5),
                              if (getBalance(
                                      itemModel.bookingModel!.payments!,
                                      double.parse(itemModel.paid)
                                          .roundToDouble(),
                                      double.parse(itemModel.cost)
                                          .roundToDouble()) !=
                                  "0")
                                Text(
                                  "  💵  ",
                                  style: TextStyle(
                                      fontSize: FontSize.small,
                                      color: Colors.grey),
                                ),
                              if (itemModel.colorCode == "Blue" &&
                                  itemModel.bookingModel!.pax!.length - 1 ==
                                      itemModel.bookingModel!.noOfPersons)
                                Icon(
                                  Icons.verified,
                                  color: AppColors.text.skyBlue,
                                  size: 12,
                                ).paddingOnly(left: 3),
                              if (itemModel.bookingModel!.hasMedicalIssues)
                                Text(
                                  "  🏥️",
                                  style: TextStyle(fontSize: FontSize.small),
                                ),
                            ],
                          ),
                        ),
                        if (itemModel.bookingModel?.isQuickBooking ?? false)
                          Text(
                            "  (Quick)",
                            style: TextStyle(
                                fontSize: FontSize.small,
                                fontWeight: FontWeight.bold),
                          ),
                        IconButton(
                          splashRadius: 20,
                          icon: Icon(controller.isExpanded[i]
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.keyboard_arrow_down_rounded),
                          onPressed: () {
                            //log("tapped");
                            controller.isExpanded[i] =
                                !controller.isExpanded[i];
                            //log(controller.isExpanded.toString());
                            controller.update();
                          },
                        ),
                      ]),
                  controller.isExpanded[i]
                      ? FutureBuilder(
                          future: Future.delayed(Duration(milliseconds: 200)),
                          initialData: SizedBox(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(height: 5),
                                  if (!itemModel.bookingModel!.isQuickBooking)
                                    Row(
                                      children: [
                                        Spacer(),
                                        IconButton(
                                          splashRadius: 20,
                                          icon: Icon(Icons.call_rounded,
                                              color:
                                                  AppColors.background.black),
                                          iconSize: 15,
                                          onPressed: () {
                                            log(double.parse(itemModel.balance)
                                                .floorToDouble()
                                                .toString());
                                            makingPhoneCall(itemModel.phone);
                                          },
                                        ),
                                        EmployeeAccess(
                                          access: AccessRights.editBookings,
                                          child: IconButton(
                                            splashRadius: 20,
                                            icon: Icon(Icons.delete,
                                                color:
                                                    AppColors.background.black),
                                            iconSize: 15,
                                            onPressed: () {
                                              if (itemModel.bookingModel
                                                      ?.cancelBooking !=
                                                  true) {
                                                _bookingCancellationDialog(
                                                    context, itemModel);
                                              } else {
                                                showToast(
                                                    "Booking Cancelled successfully");
                                              }
                                            },
                                          ),
                                        ),
                                        EmployeeAccess(
                                          access: AccessRights.editBookings,
                                          child: IconButton(
                                            splashRadius: 20,
                                            icon: Icon(Icons.edit,
                                                color:
                                                    AppColors.background.black),
                                            iconSize: 15,
                                            onPressed: () {
                                              var model =
                                                  itemModel.bookingModel;
                                              Get.toNamed(
                                                  EditBookingNewScreen.id,
                                                  arguments: model);
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
                                            var model = itemModel.bookingModel;
                                            Get.toNamed(EditBookingNewScreen.id,
                                                arguments: model);
                                          },
                                          child: Text(
                                            "Edit",
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: AppColors.text.black,
                                                fontFamily: AppFonts.nunito,
                                                decoration:
                                                    TextDecoration.underline,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        EmployeeAccess(
                                          access: AccessRights.editBookings,
                                          child: IconButton(
                                            splashRadius: 20,
                                            icon: Icon(Icons.edit,
                                                color:
                                                    AppColors.background.black),
                                            iconSize: 15,
                                            onPressed: () {
                                              var model =
                                                  itemModel.bookingModel;
                                              Get.toNamed(
                                                  EditBookingNewScreen.id,
                                                  arguments: model);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  if (itemModel.bookingModel
                                              ?.cancellationReason !=
                                          null &&
                                      itemModel.bookingModel
                                              ?.cancellationReason !=
                                          "")
                                    SizedBox(
                                      width: Get.width,
                                      child: RichText(
                                        text: TextSpan(
                                          text: "Cancellation Reason : ",
                                          style: TextStyle(
                                            fontFamily: AppFonts.nunito,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.text.black,
                                            fontSize: 13,
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: itemModel.bookingModel
                                                  ?.cancellationReason,
                                              style: TextStyle(
                                                color: Colors.grey[700],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ).paddingOnly(right: 10, bottom: 15),
                                    ),
                                  if (itemModel.bookingModel!.parentBookingId !=
                                          null &&
                                      itemModel.bookingModel!.parentBookingId !=
                                          "")
                                    buildKeyValuePairs("Parent Booking Id",
                                        itemModel.parentBookingID!),
                                  buildKeyValuePairs(
                                      "Booking Id", itemModel.bookingID!),
                                  buildKeyValuePairs(
                                      "Activity", itemModel.activity),
                                  if (!itemModel.bookingModel!.isQuickBooking)
                                    buildKeyValuePairs(
                                        "Total Cost",
                                        double.parse(itemModel.cost)
                                            .roundToDouble()
                                            .toString()),
                                  if (!itemModel.bookingModel!.isQuickBooking)
                                    buildKeyValuePairs(
                                        "Deposit",
                                        double.parse(itemModel.paid)
                                            .roundToDouble()
                                            .toString()),
                                  if (!itemModel.bookingModel!.isQuickBooking)
                                    buildKeyValuePairs(
                                      "Balance",
                                      getBalance(
                                          itemModel.bookingModel!.payments!,
                                          double.parse(itemModel.paid)
                                              .roundToDouble(),
                                          double.parse(itemModel.cost)
                                              .roundToDouble()),
                                    ),
                                  buildKeyValuePairs(
                                      "Pax",
                                      itemModel.bookingModel!.noOfPersons
                                          .toString()),
                                  if (!itemModel.bookingModel!.isQuickBooking)
                                    (itemModel.receiptNo != null)
                                        ? buildKeyValuePairs(
                                            "Invoice no", itemModel.receiptNo!)
                                        : buildKeyValuePairs("Invoice no", "-"),
                                  if (!itemModel.bookingModel!.isQuickBooking)
                                    (itemModel.remarks == "")
                                        ? buildKeyValuePairs("Remarks", "-")
                                        : buildKeyValuePairs("Remarks",
                                            itemModel.remarks.toString()),
                                  if (!itemModel.bookingModel!.isQuickBooking)
                                    buildKeyValuePairs(
                                        "Phone", itemModel.phone!),
                                  if (!itemModel.bookingModel!.isQuickBooking)
                                    buildKeyValuePairs(
                                        "Email", itemModel.email!),
                                  buildKeyValuePairs("Time", itemModel.time),
                                  buildKeyValuePairs("Date", itemModel.date),
                                  buildKeyValuePairs(
                                      "Session", itemModel.session),
                                  if (!itemModel.bookingModel!.isQuickBooking)
                                    buildKeyValuePairs(
                                      "Registered",
                                      "${itemModel.bookingModel!.pax!.length - 1} / ${itemModel.bookingModel!.noOfPersons}",
                                      isDanger: ((itemModel
                                                  .bookingModel!.pax!.length -
                                              1) !=
                                          (itemModel
                                              .bookingModel!.noOfPersons)),
                                    ),
                                  SizedBox(height: 30),
                                  if (!itemModel.bookingModel!.isQuickBooking)
                                    buildPaymentStatus(
                                      itemModel: itemModel,
                                      totalAmount:
                                          itemModel.bookingModel!.totalCost,
                                      payments: [
                                        PaymentModel(
                                          amount: double.parse(itemModel.paid)
                                              .roundToDouble(),
                                          collectedBy: itemModel.employeeName,
                                          reciptNo: itemModel.receiptNo,
                                          referenceNo: itemModel.bookingModel!
                                              .paymentTransactionId,
                                          remarks: "",
                                          paymentMode: itemModel
                                              .bookingModel!.paymentMode,
                                          time:
                                              itemModel.bookingModel!.createdAt,
                                        ),
                                        ...itemModel.bookingModel!.payments!
                                      ],
                                    ),
                                  SizedBox(height: 10),
                                  if (itemModel.colorCode == "Blue" &&
                                      (!itemModel.bookingModel!.isQuickBooking))
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "Doctor Required",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            SizedBox(width: 15),
                                            Icon(Icons.medication, size: 20),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        ...itemModel.bookingModel!.pax!
                                            .map((e) {
                                          if (e['needDoctor'] == true)
                                            return Container(
                                              height: 30,
                                              child: Row(
                                                children: [
                                                  Container(
                                                    height: 8,
                                                    width: 8,
                                                    decoration: BoxDecoration(
                                                        color: Colors.red,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                  ).paddingOnly(top: 2),
                                                  SizedBox(width: 10),
                                                  Text(
                                                    e['first-name'] +
                                                        e['last-name'],
                                                    style: TextStyle(
                                                        fontSize:
                                                            FontSize.small),
                                                  ),
                                                  Spacer(),
                                                  IconButton(
                                                    splashRadius: 15,
                                                    padding: EdgeInsets.zero,
                                                    icon: Icon(
                                                      Icons.call_rounded,
                                                      color: AppColors
                                                          .background.black,
                                                      size: 15,
                                                    ),
                                                    iconSize: 15,
                                                    onPressed: () {
                                                      makingPhoneCall(
                                                          e['phoneNumber']);
                                                    },
                                                  ),
                                                ],
                                              ).paddingOnly(right: 20),
                                            );
                                          return SizedBox();
                                        }),
                                        SizedBox(height: 20),
                                      ],
                                    ),
                                  if (itemModel.colorCode != "Blue" &&
                                      (!itemModel.bookingModel!.isQuickBooking))
                                    Row(
                                      children: [
                                        AppButton.miniFlat(
                                          text: "Process Cert",
                                          onTap: () async {
                                            String message = """

*${itemModel.name!.trim().toLowerCase().capitalizeFirst! + itemModel.bookingModel!.pax![0]["last-name"]} 's* ${itemModel.activity}

*Certification details:* 

Email : *${itemModel.email}* 
Date of Birth : *${(itemModel.bookingModel!.pax![0]["dob"] != null) ? intl.DateFormat("dd-MM-yyy").format((itemModel.bookingModel!.pax![0]["dob"] as Timestamp).toDate()) : "-"}* 
Certification : *${itemModel.activity}* 
Course Completion Date : *${intl.DateFormat("dd-MM-yyy").format(DateTime.now())}* 
Balance : *${getBalance(itemModel.bookingModel!.payments!, double.parse(itemModel.paid).roundToDouble(), double.parse(itemModel.cost).roundToDouble())} /-* 
Completed instructor : *${currentEmployee!.name.trim()}* 
Instructor No : *${currentEmployee!.agencyId ?? "-"}* 
Invoice No : *${itemModel.bookingModel!.receiptNo}* 
Course / Equipment Upsell :     *${"-"}*
 
Regards,
*${currentEmployee!.name.trim()}*
                                          """;
                                            await Clipboard.setData(
                                                ClipboardData(text: message));
                                            Fluttertoast.showToast(
                                                msg:
                                                    "Message copied to Clipboard");
                                          },
                                        ).paddingOnly(right: 15),
                                        Spacer(),
                                        AppButton.miniFlat(
                                          text: "E-Learning",
                                          onTap: () async {
                                            String message = """
*E-Learning request details:* 

First Name : *${itemModel.name!.trim().toLowerCase().capitalizeFirst}* 
Last Name : *${(itemModel.bookingModel!.pax![0]["last-name"] != "") ? itemModel.bookingModel!.pax![0]["last-name"] : "-"}* 
Email : *${itemModel.email}* 
Date of Birth : *${(itemModel.bookingModel!.pax![0]["dob"] != null) ? intl.DateFormat("dd-MM-yyy").format((itemModel.bookingModel!.pax![0]["dob"] as Timestamp).toDate()) : "-"}* 
Course Name : *${itemModel.activity}* 
Invoice No : *${itemModel.bookingModel!.receiptNo}* 
Phone Number : *${itemModel.bookingModel!.pax![0]["phoneNumber"]}* 
 
Regards,
*${currentEmployee!.name.trim()}*
                                          """;
                                            await Clipboard.setData(
                                                ClipboardData(text: message));
                                            Fluttertoast.showToast(
                                                msg:
                                                    "Message copied to Clipboard");
                                          },
                                        ).paddingOnly(right: 15),
                                      ],
                                    ),
                                  if (!itemModel.bookingModel!.isQuickBooking)
                                    Row(
                                      children: [
                                        Spacer(),
                                        if (itemModel.colorCode == "Blue")
                                          button,
                                        if (itemModel.colorCode == "Blue")
                                          AppButton.miniFlat(
                                            text: "PaperWork",
                                            bgColor: AppColors.text.green
                                                .withOpacity(0.8),
                                            onTap: () async {
                                              String bookingId =
                                                  itemModel.bookingModel!.id!;
                                              String bs64 = base64
                                                  .encode(bookingId.codeUnits);
                                              print(bs64);
                                              String link =
                                                  "https://templeadventures.com/temple_paperwork/?bookingId=$bs64&author=dGVtcGxl&paperwork_id=MTQ=";

                                              showModalBottomSheet(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  isScrollControlled: true,
                                                  context: context,
                                                  useRootNavigator: true,
                                                  builder: (context) {
                                                    return Container(
                                                      padding: EdgeInsets.only(
                                                          bottom: MediaQuery.of(
                                                                  context)
                                                              .viewInsets
                                                              .bottom,
                                                          top: 30,
                                                          left: 30,
                                                          right: 30),
                                                      decoration:
                                                          const BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        15),
                                                                topRight: Radius
                                                                    .circular(
                                                                        15)),
                                                      ),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Container(
                                                                width: 150,
                                                                child: Text(
                                                                  "${itemModel.name!.capitalizeFirst! + "x" + itemModel.pax.toString()}",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize:
                                                                          FontSize
                                                                              .textSize),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              ),
                                                              const Spacer(),
                                                              Material(
                                                                color: Colors
                                                                    .transparent,
                                                                child: InkWell(
                                                                    highlightColor: Colors
                                                                        .blue
                                                                        .withOpacity(
                                                                            0.2),
                                                                    splashColor: Colors
                                                                        .grey
                                                                        .withOpacity(
                                                                            0.3),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20),
                                                                    radius: 100,
                                                                    onTap: () {
                                                                      Navigator.pop(
                                                                          context);
                                                                      // provider.onCancelPressed();
                                                                    },
                                                                    child: Icon(
                                                                        Icons
                                                                            .close)),
                                                              )
                                                            ],
                                                          ),
                                                          SizedBox(height: 50),
                                                          Container(
                                                            height: 50,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                              color: AppColors
                                                                  .text
                                                                  .lightSkyBlue
                                                                  .withOpacity(
                                                                      0.1),
                                                            ),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                SizedBox(
                                                                    width: 15),
                                                                Container(
                                                                  width: 200,
                                                                  child: Text(
                                                                    "temple_paperwork/?bookingId..",
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  ),
                                                                ),
                                                                Spacer(),
                                                                IconButton(
                                                                    onPressed:
                                                                        () async {
                                                                      await Clipboard.setData(
                                                                          ClipboardData(
                                                                              text: link));
                                                                      Fluttertoast
                                                                          .showToast(
                                                                              msg: "Link copied to Clipboard");
                                                                    },
                                                                    icon: Icon(
                                                                        Icons
                                                                            .copy_outlined,
                                                                        size:
                                                                            20)),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(height: 50),
                                                          Container(
                                                            alignment: Alignment
                                                                .center,
                                                            child: QRImage(
                                                                height: 150,
                                                                width: 150,
                                                                data:
                                                                    "https://templeadventures.com/temple_paperwork/?bookingId=$bs64&author=dGVtcGxl&paperwork_id=MTQ="),
                                                          ),
                                                          SizedBox(height: 50),
                                                        ],
                                                      ),
                                                    );
                                                  });
                                            },
                                          ).paddingOnly(right: 15),
                                      ],
                                    ),
                                  SizedBox(height: 20),
                                  Row(
                                    children: [
                                      if (itemModel.employeeName != null)
                                        Container(
                                          alignment: Alignment.centerRight,
                                          child: RichText(
                                            text: TextSpan(
                                              text: "Created By : ",
                                              style: TextStyle(
                                                fontFamily: AppFonts.nunito,
                                                color: AppColors.text.darkgrey,
                                                fontSize: 10,
                                              ),
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text: itemModel.employeeName,
                                                  style: TextStyle(
                                                    color: Color(0xff484646),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      Spacer(),
                                      if (!itemModel
                                          .bookingModel!.isQuickBooking)
                                        (itemModel.colorCode == "Blue")
                                            ? AppButton.miniFlat(
                                                text: "Manage PAX",
                                                onTap: () async {
                                                  Booking? bookingModel =
                                                      itemModel.bookingModel;
                                                  showModalBottomSheet(
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      isScrollControlled: true,
                                                      context: context,
                                                      useRootNavigator: true,
                                                      builder: (context) {
                                                        return Container(
                                                          padding: EdgeInsets.only(
                                                              bottom: MediaQuery
                                                                      .of(context)
                                                                  .viewInsets
                                                                  .bottom,
                                                              top: 30,
                                                              left: 30,
                                                              right: 30),
                                                          constraints:
                                                              BoxConstraints(
                                                                  minHeight:
                                                                      300),
                                                          decoration:
                                                              const BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius: BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        15),
                                                                topRight: Radius
                                                                    .circular(
                                                                        15)),
                                                          ),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Container(
                                                                    width: 150,
                                                                    child: Text(
                                                                      "${itemModel.name!.capitalizeFirst! + " X " + itemModel.pax.toString()}",
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          fontSize:
                                                                              FontSize.textSize),
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    ),
                                                                  ),
                                                                  const Spacer(),
                                                                  Material(
                                                                    color: Colors
                                                                        .transparent,
                                                                    child: InkWell(
                                                                        highlightColor: Colors.blue.withOpacity(0.2),
                                                                        splashColor: Colors.grey.withOpacity(0.3),
                                                                        borderRadius: BorderRadius.circular(20),
                                                                        radius: 100,
                                                                        onTap: () {
                                                                          Navigator.pop(
                                                                              context);
                                                                          // provider.onCancelPressed();
                                                                        },
                                                                        child: Icon(Icons.close)),
                                                                  )
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                  height: 20),
                                                              ...bookingModel!
                                                                  .pax!
                                                                  .asMap()
                                                                  .entries
                                                                  .map((e) {
                                                                int index =
                                                                    e.key;
                                                                String? email =
                                                                    e.value[
                                                                        "email"];
                                                                if (index == 0)
                                                                  return SizedBox();
                                                                return Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                        email!),
                                                                    IconButton(
                                                                      onPressed:
                                                                          () {
                                                                        onDeletePaxPressed(
                                                                            bookingModel,
                                                                            index);
                                                                      },
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .delete,
                                                                        size:
                                                                            20,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                );
                                                              }),
                                                            ],
                                                          ),
                                                        );
                                                      });
                                                },
                                              ).paddingOnly(right: 15)
                                            : AppButton.miniFlat(
                                                text: "Booking Info",
                                                bgColor: AppColors.text.orange
                                                    .withOpacity(0.8),
                                                onTap: () async {
                                                  File pdfFile =
                                                      await ShareBookingDetails
                                                          .generatePdf(itemModel
                                                              .bookingModel!);
                                                  Share.shareFiles(
                                                      [pdfFile.path]);
                                                },
                                              ).paddingOnly(right: 15),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                ],
                              );
                            }
                            return SizedBox();
                          })
                      : SizedBox(),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Future<void> _bookingCancellationDialog(
      BuildContext context, ItemModel itemModel) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Cancellation Reason',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            content: AppTextField(
              controller: logic.controller.cancelMessage,
              hintText: "Reason",
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
                text: "Cancel",
                onTap: () {
                  Get.back();
                  logic.controller.cancelMessage.text = "";
                },
              ),
              AppButton.miniFlat(
                text: "Okay",
                onTap: () {
                  if (itemModel.bookingModel?.boatDetails?.boat != null) {
                    removeBoat(
                      bookingModel: itemModel.bookingModel!,
                      selectedDate:
                          bookingCalenderLogicNew.controller.selectedDate,
                    );
                  }

                  if (itemModel.bookingModel != null &&
                      logic.controller.cancelMessage.text != "") {
                    log(logic.controller.cancelMessage.text);
                    if (itemModel.bookingModel!.cancelBooking == null ||
                        itemModel.bookingModel!.cancelBooking == false) {
                      FirebaseFirestore.instance
                          .collection('bookings')
                          .doc(itemModel.bookingModel!.id)
                          .set({
                        "cancelBooking": true,
                        "cancellationReason":
                            logic.controller.cancelMessage.text
                      }, SetOptions(merge: true));
                    }

                    LogModel logModel = LogModel(
                        type: LogType.bookingDeleted,
                        bookingId: itemModel.bookingModel!.id);
                    FirebaseFirestore.instance
                        .collection("logs")
                        .doc()
                        .set(logModel.toMap());
                    logic.controller.cancelMessage.text = "";
                    Get.back();
                    BookingsCalenderWidgetLogicNew bookingCalenderLogic =
                        BookingsCalenderWidgetLogicNew();
                    bookingCalenderLogic.onDateSelected(
                        bookingCalenderLogic.controller.lastDateIndex);
                  } else {
                    showToast("Please add cancellation Reason");
                  }
                },
              ),
            ],
          );
        });
  }

  Future<void> removeBoat({
    required Booking bookingModel,
    required DateTime selectedDate,
  }) async {
    bookingModel.setBoatInfo(
      selectedDate,
      null,
    );

    await FirebaseFirestore.instance
        .collection('bookings')
        .doc(bookingModel.id)
        .set(
          bookingModel.toMap(),
        );
  }

  makingPhoneCall(String? phoneNumber) async {
    String url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
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
                height: 1.3),
          ),
        ),
        Container(
          width: 180,
          child: Text(
            value,
            // overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: isDanger ? Colors.red : Colors.black,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
                height: 1.3),
          ),
        ),
      ],
    );
  }

  Widget buildPaymentStatus(
      {required double totalAmount,
      required List<PaymentModel> payments,
      required ItemModel? itemModel}) {
    double deposits = 0.0;

    payments.forEach((payment) {
      deposits += payment.amount!;
    });

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
                    color: (totalAmount == deposits)
                        ? Colors.green.shade400
                        : Colors.black,
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
                    ? SizedBox()
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
                            decoration: BoxDecoration(
                                color: AppColors.text.skyBlue,
                                shape: BoxShape.circle),
                            child: Icon(
                              Icons.circle,
                              size: 10,
                              color: AppColors.text.black,
                            ),
                          ),
                        ),
                      ],
                    )),
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
                          color: Colors.black);
                    }),
                  ),
                ),
                (totalAmount == deposits)
                    ? SizedBox()
                    : Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            buildNumber(
                                text:
                                    (totalAmount - deposits).round().toString(),
                                // text: "16000",
                                color: Colors.red,
                                fontWeight: FontWeight.normal),
                          ],
                        )),
                Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        buildNumber(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            text: totalAmount.round().toString()),
                      ],
                    )),
              ],
            ).paddingOnly(top: 20),
          ],
        ).paddingOnly(right: 20),
        SizedBox(height: 20),
        GestureDetector(
          onTap: () {
            EditPaymentsLogic editPaymentsLogic = EditPaymentsLogic();
            editPaymentsLogic.controller.bookingModel = itemModel!.bookingModel;
            Get.toNamed(EditPaymentsScreen.id);
          },
          child: Row(
            children: [
              Text(
                "Edit Payments",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              SizedBox(width: 20),
              Icon(Icons.edit, size: 15),
              Spacer(),
              AppButton.miniFlat(
                text: "Add Payment",
                onTap: () {
                  Get.toNamed(AddPaymentsScreen.id,
                      arguments: itemModel!.bookingModel);
                },
              ).paddingOnly(right: 15)
            ],
          ),
        ),
        SizedBox(height: 20),
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
          decoration: BoxDecoration(
              color: Colors.green, borderRadius: BorderRadius.circular(10)),
        ).paddingOnly(top: 2),
        SizedBox(width: 10),
        Container(
          width: Get.width - 73,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Payment ${payment.amount!.round()} by ${payment.paymentMode ?? "-"} collected by ${payment.collectedBy}",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  wordSpacing: 2,
                ),
              ),
              SizedBox(height: 2),
              if (payment.time != null &&
                  now.day == payment.time!.day &&
                  now.month == payment.time!.month &&
                  now.year == payment.time!.year)
                Text(
                  "Today - ${intl.DateFormat("hh:mm a").format(payment.time!)}",
                  style:
                      TextStyle(fontSize: 10, color: AppColors.text.darkgrey),
                )
              else if (payment.time != null)
                Text(
                  intl.DateFormat("EEE dd MMM yy - hh:mm a")
                      .format(payment.time!),
                  style:
                      TextStyle(fontSize: 10, color: AppColors.text.darkgrey),
                )
              else
                Text(
                  "Initial Deposit",
                  style:
                      TextStyle(fontSize: 10, color: AppColors.text.darkgrey),
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

  Widget buildNumber(
      {FontWeight? fontWeight, Color? color, required String text}) {
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
    payments.forEach((payment) {
      t += payment.amount!;
    });
    return (total - t).toInt().toString();
  }

  // Future<Uint8List> _createImageFromWidget(
  //   Widget widget, {
  //   Duration wait = const Duration(milliseconds: 450),
  // }) async {
  //   final RenderRepaintBoundary repaintBoundary = RenderRepaintBoundary();
  //   Size logicalSize = ui.window.physicalSize / ui.window.devicePixelRatio;
  //   double pixelRatio = ui.window.devicePixelRatio;
  //   final RenderView renderView = RenderView(
  //     window: ui.window,
  //     child: RenderPositionedBox(
  //         alignment: Alignment.center,
  //         // heightFactor: Get.height,
  //         child: repaintBoundary),
  //     configuration: ViewConfiguration(
  //       size: logicalSize,
  //       devicePixelRatio: pixelRatio,
  //     ),
  //   );
  //
  //   final PipelineOwner pipelineOwner = PipelineOwner();
  //   final BuildOwner buildOwner = BuildOwner(focusManager: FocusManager());
  //   pipelineOwner.rootNode = renderView;
  //   renderView.prepareInitialFrame();
  //   final RenderObjectToWidgetElement<RenderBox> rootElement =
  //       RenderObjectToWidgetAdapter<RenderBox>(
  //     container: repaintBoundary,
  //     child: Directionality(
  //       textDirection: TextDirection.ltr,
  //       child: widget,
  //     ),
  //   ).attachToRenderTree(buildOwner);
  //   buildOwner.buildScope(rootElement);
  //
  //   await Future.delayed(wait);
  //
  //   buildOwner.buildScope(rootElement);
  //   buildOwner.finalizeTree();
  //   pipelineOwner.flushLayout();
  //   pipelineOwner.flushCompositingBits();
  //   pipelineOwner.flushPaint();
  //
  //   final ui.Image image =
  //       await repaintBoundary.toImage(pixelRatio: pixelRatio);
  //   //final ui.Image image = await repaintBoundary.toImage(pixelRatio: 1);
  //   final ByteData byteData =
  //       (await image.toByteData(format: ui.ImageByteFormat.png))!;
  //   return byteData.buffer.asUint8List();
  // }

  Future<void> onDeletePaxPressed(Booking bookingModel, int index) async {
    Get.defaultDialog(
      contentPadding: EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 30),
      title: "\nAre You Sure ? ",
      middleText:
          "Booking PAX (${bookingModel.pax![index]["email"]}) will Be Deleted Permanently.",
      backgroundColor: Colors.white,
      titleStyle: TextStyle(
          color: AppColors.text.black,
          fontFamily: AppFonts.nunito,
          fontSize: 16,
          fontWeight: FontWeight.bold),
      middleTextStyle: TextStyle(
          color: AppColors.text.black,
          fontFamily: AppFonts.nunito,
          fontSize: 15,
          fontWeight: FontWeight.w500),
      confirm: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppButton.miniText(
            text: 'Cancel',
            onTap: () {
              Get.back();
            },
          ),
          AppButton.miniFlat(
            text: 'OK',
            onTap: () async {
              bookingModel.pax!.removeAt(index);
              FirebaseFirestore.instance
                  .collection("bookings")
                  .doc(bookingModel.id)
                  .set(bookingModel.toMap());
              LogModel logModel = LogModel(
                  type: LogType.bookingPaxDeleted, bookingId: bookingModel.id);
              FirebaseFirestore.instance
                  .collection("logs")
                  .doc()
                  .set(logModel.toMap());
              Get.back();
              Get.back();
              BookingsCalenderWidgetLogicNew bookingCalenderLogic =
                  BookingsCalenderWidgetLogicNew();
              bookingCalenderLogic.onDateSelected(
                  bookingCalenderLogic.controller.lastDateIndex);
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

  TextEditingController cancelMessage = TextEditingController();
}

class ItemModel {
  bool expanded;
  final String? name;
  String time;
  String session;
  final String? email;
  final String? bookingID;
  final String? parentBookingID;
  final String? phone;
  final String activity;
  final String colorCode;
  final String price;
  final String date;
  final String cost;
  final String paid;
  final String balance;
  final String? remarks;
  final int? pax;
  final bool registration;
  final String? receiptNo;
  final String? employeeName;
  Booking? bookingModel;

  ItemModel({
    required this.phone,
    required this.parentBookingID,
    required this.activity,
    required this.bookingID,
    required this.colorCode,
    required this.price,
    required this.time,
    required this.session,
    required this.date,
    required this.cost,
    required this.paid,
    required this.receiptNo,
    required this.balance,
    required this.remarks,
    required this.registration,
    this.expanded = false,
    required this.name,
    required this.employeeName,
    required this.pax,
    required this.email,
    this.bookingModel,
  });

  factory ItemModel.fromBookings(Booking bookingModel) {
    getSessions() {
      var d = "";
      if (bookingModel.theoryDate != null) d = d + "Theory, ";
      if (bookingModel.poolDate != null) d = d + "Pool, ";
      if (bookingModel.diveDate != null) d = d + "Dive, ";
      return d.substring(0, d.length - 2);
    }

    getTime() {
      var d = "";
      if (bookingModel.theoryDate != null &&
          bookingModel.theoryDate!.isNotEmpty)
        d = d +
            intl.DateFormat("hh:mm a").format(bookingModel.theoryDate![0]!) +
            ", ";
      if (bookingModel.poolDate != null && bookingModel.poolDate!.isNotEmpty)
        d = d +
            intl.DateFormat("hh:mm a").format(bookingModel.poolDate![0]!) +
            ", ";
      if (bookingModel.diveDate != null && bookingModel.diveDate!.isNotEmpty)
        d = d +
            intl.DateFormat("hh:mm a").format(bookingModel.diveDate![0]!) +
            ", ";
      return d.substring(0, d.length - 2);
    }

    //log(bookingModel.balance.toString());
    return ItemModel(
      phone: bookingModel.pax![0]["countryCode"] +
          bookingModel.pax![0]["phoneNumber"],
      bookingID: bookingModel.id,
      activity: bookingModel.activity![0]!.name.toString(),
      price: bookingModel.activity![0]!.price.toString(),
      colorCode: bookingModel.activity![0]!.color.toString(),
      date: bookingModel.bookingDate![0],
      cost: bookingModel.totalCost.toString(),
      paid: bookingModel.paid.toString(),
      balance: bookingModel.balance.toString(),
      registration: true,
      receiptNo: bookingModel.receiptNo,
      name: bookingModel.pax![0]["first-name"],
      pax: bookingModel.noOfPersons,
      email: bookingModel.pax![0]["email"],
      remarks: bookingModel.remarks,
      time: getTime(),
      session: getSessions(),
      employeeName: bookingModel.employeeName,
      bookingModel: bookingModel,
      parentBookingID: bookingModel.parentBookingId,
    );
  }
}

class SearchController extends GetxController {
  bool _showSearchField = true;

  bool get showSearchField => _showSearchField;

  set showSearchField(bool value) {
    _showSearchField = value;
    update();
  }
}
