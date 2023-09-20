import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:temple_adventures/core/models/item-model.dart';
import 'package:temple_adventures/features/boat/models/boat-details.dart';
import 'package:temple_adventures/features/boat/models/boats.dart';
import 'package:temple_adventures/features/bookings/models/booking-model.dart';
import 'package:temple_adventures/features/employees/model/employee.dart';

class HomeLogic {
  HomeController controller = Get.put(HomeController());

  Future<void> getBookings() async {
    controller.bookings = [];
    controller.diveBuddies = [];
    controller.currentList = [];
    controller.generalStaffList = [];
    controller.showLoading = true;

    var data = await FirebaseFirestore.instance
        .collection("bookings")
        .where(
          "bookingDate",
          arrayContains:
              DateFormat("dd-MM-yyyy").format(controller.selectedDate),
        )
        .get();

    data.docs.forEach((element) {
      Booking booking = Booking.fromMap(element.data());
      ItemModel item = ItemModel.fromBooking(booking);

      /// Get  bookings where i'm instructor
      if (booking.boatDetails?.instructors?.firstWhereOrNull(
              (element) => (element.id == currentEmployee?.id)) !=
          null) {
        controller.bookings.add(item);
      }

      /// Get bookings where i'm dive buddy
      if (booking.boatDetails?.diveBuddies?.firstWhereOrNull(
              (element) => (element.id == currentEmployee?.id)) !=
          null) {
        controller.diveBuddies.add(item);
      }
    });

    await getBoatsData();
    controller.showLoading = false;
  }

  Future<void> getBoatsData() async {
    var data = await FirebaseFirestore.instance
        .collection("dailyBoats")
        .doc(DateFormat("dd-MM-yyyy").format(controller.selectedDate))
        .get();
    Map<String, dynamic> docs = data.data() as Map<String, dynamic>;
    BoatsModel boatsModel = BoatsModel.fromMap(docs);
    for (Boat boat in (boatsModel.boats ?? [])) {
      if ((boat.captains ?? [])
          .map((e) => e.id)
          .toList()
          .contains(currentEmployee?.id)) {
        controller.currentList.add({
          "boat_details": boat,
          "role": "Captain",
        });
      }
      if ((boat.dsdInstructors ?? [])
          .map((e) => e.id)
          .toList()
          .contains(currentEmployee?.id)) {
        controller.currentList.add({
          "boat_details": boat,
          "role": "Dsd Instructor",
        });
      }
      if ((boat.photographer ?? [])
          .map((e) => e.id)
          .toList()
          .contains(currentEmployee?.id)) {
        controller.currentList.add({
          "boat_details": boat,
          "role": "Photographer",
        });
      }
      if ((boat.surfaceSupport ?? [])
          .map((e) => e.id)
          .toList()
          .contains(currentEmployee?.id)) {
        controller.currentList.add({
          "boat_details": boat,
          "role": "Surface Support",
        });
      }
      if ((boat.internPhotoVideo ?? [])
          .map((e) => e.id)
          .toList()
          .contains(currentEmployee?.id)) {
        controller.currentList.add({
          "boat_details": boat,
          "role": "Intern Photographer",
        });
      }
    }
    if ((boatsModel.dsd?.centerStaff ?? [])
        .map((e) => e.id)
        .toList()
        .contains(currentEmployee?.id)) {
      controller.generalStaffList.add("Dsd CenterStaff");
    }
    if ((boatsModel.dsd?.dsdOceanHead ?? [])
        .map((e) => e.id)
        .toList()
        .contains(currentEmployee?.id)) {
      controller.generalStaffList.add("Dsd OceanLead");
    }
    if ((boatsModel.dsd?.dsdPool ?? [])
        .map((e) => e.id)
        .toList()
        .contains(currentEmployee?.id)) {
      controller.generalStaffList.add("Dsd Pool");
    }
    if ((boatsModel.dsd?.courseCenter ?? [])
        .map((e) => e.id)
        .toList()
        .contains(currentEmployee?.id)) {
      controller.generalStaffList.add("Courses Center");
    }
    if ((boatsModel.dsd?.harboursStaff ?? [])
        .map((e) => e.id)
        .toList()
        .contains(currentEmployee?.id)) {
      controller.generalStaffList.add("Harbour Staff");
    }
  }

  Future<void> onDateChanged(DateTime date) async {
    controller.selectedDate = date;
    controller.showLoading = true;
    await getBookings();
    controller.showLoading = false;
  }
}

class HomeController extends GetxController {
  List<ItemModel> bookings = [];

  List<ItemModel> diveBuddies = [];

  List<Map<String, dynamic>> currentList = [];

  List<String> generalStaffList = [];

  DateTime selectedDate = DateTime.now();

  bool _showLoading = false;

  bool get showLoading => _showLoading;

  set showLoading(bool value) {
    _showLoading = value;
    update();
  }
}
