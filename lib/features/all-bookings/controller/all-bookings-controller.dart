import 'package:cloud_firestore/cloud_firestore.dart';
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
    List<ItemModel> bookingList = [];
    var data = await FirebaseFirestore.instance.collection("bookings").get();
    data.docs.forEach((element) {
      print(element.data());
      BookingModel booking = BookingModel.fromMap(element.data());
      var i = ItemModel.fromBookings(booking);
      bookingList.add(i);
    });
    print("ended=========");
    controller.bookings = bookingList;
    controller.showLoading = false;
  }
}

class AllBookingsController extends GetxController {
  List<ItemModel> bookings;

  bool _showLoading = true;

  bool get showLoading => _showLoading;

  set showLoading(bool value) {
    _showLoading = value;
    update();
  }
}
