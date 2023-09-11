import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:temple_adventures/core/models/item-model.dart';
import 'package:temple_adventures/features/bookings/models/booking-model.dart';

class HomeLogic {
  HomeController controller = Get.put(HomeController());

  Future<void> getBookings() async {
    controller.bookings = [];
    controller.showLoading = true;

      var data = await FirebaseFirestore.instance
          .collection("bookings")
          .where(
            "bookingDate",
            arrayContains: DateFormat("dd-MM-yyyy")
                .format(controller.selectedDate),
          )
          .get();


      data.docs.forEach((element) {
        Booking booking = Booking.fromMap(element.data());
        if (booking.boatDetails != null &&
            booking.boatDetails?.instructors != null &&
            booking.boatDetails!.instructors!.isNotEmpty) {
          if (booking.boatDetails!.instructors!.first.id == "9") {
            ItemModel itemModel = ItemModel.fromBookings(booking);
          controller.bookings.add(itemModel);
        }
        log(controller.bookings.toString());

        }
      });

    log(controller.bookings.toString());
    controller.showLoading = false;
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

  DateTime selectedDate = DateTime.now();

  bool _showLoading = false;

  bool get showLoading => _showLoading;

  set showLoading(bool value) {
    _showLoading = value;
    update();
  }
}
