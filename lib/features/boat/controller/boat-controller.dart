import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/features/boat/models/boat-model.dart';
import 'package:temple_adventures/features/boat/models/boat-passengers-model.dart';
import 'package:temple_adventures/features/counter-model.dart';

class BoatLogic {
  BoatLogic(){
    getBoatsCount();
  }

  BoatController controller = Get.put(BoatController());

  DateTime date = DateTime.now();

  getData() async {
    var data = await FirebaseFirestore.instance.collection("boats").get();
    controller.boatsList = [];
    print(data.docs.length);
    data.docs.forEach((element) {
      log(element.data().toString());
      BoatsModel boat = BoatsModel.fromMap(element.data());
      print(boat.boatName);
      controller.boatsList.add(boat);
    });
  }

  getPassengersData() async {
    var data = await FirebaseFirestore.instance
        .collection("counter")
        .doc("count")
        .get();
    CounterModel counterModel = CounterModel.fromMap(data.data());

    String bookingDate = DateFormat('dd-MM-yyyy').format(date);
    controller.passengerModel = [];
    log(bookingDate);
    log(counterModel.boat.toString());
    for (int i = 1; i <= counterModel.boat; i++) {
      var data = await FirebaseFirestore.instance
          .collection("boats")
          .doc(i.toString())
          .collection("allocation")
          .doc(bookingDate)
          .get();
      BoatPassengersModel boatPassengersModel =
          BoatPassengersModel.fromMap(data.data());
      controller.passengerModel.add(boatPassengersModel);
      log(boatPassengersModel.passengers.toString());
    }
    log(controller.passengerModel.toString());
  }

  getBoatsCount() async {
    var data = await FirebaseFirestore.instance
        .collection("counter")
        .doc("count")
        .get();
    controller.boatsCount = CounterModel.fromMap(data.data());
  }

}

class BoatController extends GetxController {
  List<BoatsModel> boatsList = [];
  List<BoatPassengersModel> passengerModel = [];
  CounterModel boatsCount;

}
