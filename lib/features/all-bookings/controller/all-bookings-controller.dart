import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/widgets/app-expansion-panel.dart';
import 'package:temple_adventures/features/bookings/models/booking-model.dart';

class AllBookingsLogic {
  AllBookingsLogic() {
    // getBookings();
  }
  AllBookingsController controller = Get.put(AllBookingsController());



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
