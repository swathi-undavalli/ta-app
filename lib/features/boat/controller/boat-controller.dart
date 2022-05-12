import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/features/boat/models/boat-model.dart';
import 'package:temple_adventures/features/boat/models/boat-passengers-model.dart';

class BoatLogic {
  BoatLogic() {
    init();
  }

  BoatController controller = Get.put(BoatController());

  init() async {
    await getData();
    controller.showLoading = false;
  }

  getData() async {
    log("getting data");
    controller.boatsList = [];

    var boatsData = await FirebaseFirestore.instance.collection("boats").get();

    boatsData.docs.forEach((element) {
      BoatsModel boat = BoatsModel.fromMap(element.data());
      controller.boatsList.add(boat);
      controller.update();
    });

    var d = await FirebaseFirestore.instance
        .collection("coastGuardSlip")
        // .doc("05-05-2022")
        .doc(DateFormat('dd-MM-yyyy').format(controller.selectedDate))
        .get();

    Map<String, dynamic> passengerData = d.data();
    if (passengerData == null) {
      log("no data found");
      controller.noDataFound = true;
    } else {
      log(passengerData.toString());

      controller.noDataFound = false;
      controller.timeList = [];
      controller.bookedPassengers = [];

      passengerData.keys.toList().forEach((p) {
        controller.timeList.add(DateTime.parse(p));
      });

      passengerData.values.toList().forEach((p) {
        controller.bookedPassengers.add(BoatPassengersModel.fromMap(p));
      });
    }
    log("data found");
  }
}

class BoatController extends GetxController {
  List<BoatsModel> boatsList = [];
  List<DateTime> timeList = [];
  List<BoatPassengersModel> bookedPassengers = [];

  bool _showLoading = true;
  bool _noDataFound = true;

  bool get noDataFound => _noDataFound;

  set noDataFound(bool value) {
    _noDataFound = value;
    update();
  }

  bool get showLoading => _showLoading;

  set showLoading(bool value) {
    _showLoading = value;
    update();
  }

  // DateTime _selectedDate = DateTime.now();
  DateTime _selectedDate = DateTime(
    2022,
    5,
    5,
  );
  DateTime get selectedDate => _selectedDate;
  set selectedDate(DateTime value) {
    _selectedDate = value;
    update();
  }
}
