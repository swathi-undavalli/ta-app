import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/widgets/app-expansion-panel.dart';
import 'package:temple_adventures/features/bookings/models/booking-model.dart';

class AllBookingsLogic {
  AllBookingsLogic() {
    getBookings();
  }
  AllBookingsController controller = Get.put(AllBookingsController());
  getBookings() async {
    print("getBookings");
    controller.showLoading = true;
    controller.bookings = [];
    List<ItemModel> bookingList = [];

    var data = await FirebaseFirestore.instance.collection("bookings").get();
    print(data.docs.length);
    data.docs.forEach((element) {
      log(element.data().toString());
      BookingModel booking = BookingModel.fromMap(element.data());
      var i = ItemModel.fromBookings(booking);
      bookingList.add(i);
      log(bookingList.toString());
    });
    print("ended=========");
    controller.bookings = bookingList;
    print(controller.bookings);
    controller.update();
    controller.showLoading = false;
  }


  void updateSearchListByIDorName(String text) {
    controller.suggestionsList = [];
    // print(
    //     controller.bookings[controller.bookings.length - 1].bookingID);
    controller.bookings.forEach((booking) {
      if (booking.bookingID.contains(text) || booking.name.toLowerCase().contains(text.toLowerCase())) {
        controller.suggestionsList.add(booking);
      }
    });
    controller.update();
  }

// getBookingsCount() async {
  //   var fact = 1;
  //   var pageCount = 0;
  //   controller.pages = [];
  //   var data = await FirebaseFirestore.instance
  //       .collection("counter")
  //       .doc("booking")
  //       .get();
  //   // log("==========" + data["count"].toString());
  //   Map<String, dynamic> count = data.data();
  //   var totalCount = count["count"].toString();
  //   // var myCount = int.parse(totalCount) / 10;
  //   // pageCount = myCount.ceil();
  //   // for (int i = 1; i <= pageCount; i++) {
  //   //   fact = fact * i;
  //   //   controller.pages.add(fact.toString());
  //   //   fact = 1;
  //   // }
  //   log(controller.pages.toString());
  //   controller.bookingCount = int.parse(totalCount);
  // }

}

class AllBookingsController extends GetxController {
  List<ItemModel> bookings;

  bool _showSuggestions = false;

  List<ItemModel> suggestionsList = [];


  TextEditingController searchTED = TextEditingController();

  bool _showLoading = true;

  bool _onSelected = false;

  List<String> pages = [];

  String _selectedPage = "1";

  int _bookingCount;

  bool get onSelected => _onSelected;

  bool get showLoading => _showLoading;

  String get selectedPage => _selectedPage;

  int get bookingCount => _bookingCount;

  bool get showSuggestions => _showSuggestions;

  set showSuggestions(bool value) {
    _showSuggestions = value;
    update();
  }
  set bookingCount(int value) {
    _bookingCount = value;
    update();
  }

  set selectedPage(String value) {
    _selectedPage = value;
    update();
  }

  set onSelected(bool value) {
    _onSelected = value;
    update();
  }

  set showLoading(bool value) {
    _showLoading = value;
    update();
  }
}
