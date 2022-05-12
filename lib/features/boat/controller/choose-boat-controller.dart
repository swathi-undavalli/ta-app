import 'dart:developer';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/features/boat/models/boat-model.dart';
import 'package:temple_adventures/features/boat/models/boat-passengers-model.dart';
import 'package:temple_adventures/features/bookings/controller/new-booking-controller.dart';
import 'package:temple_adventures/features/bookings/models/booking-model.dart';

class ChooseBoatLogic {
  ChooseBoatLogic() {
    init();
  }

  ChooseBoatController controller = Get.put(ChooseBoatController());
  NewBookingLogic bookingLogic = NewBookingLogic();

  init() async {
    controller.showLoading = true;
    log("init started");
    await getData();
    log("init done");
    controller.showLoading = false;
  }

  getData() async {
    var data = await FirebaseFirestore.instance.collection("boats").get();
    controller.boatsList = [];

    log("1");

    data.docs.forEach((element) {
      BoatsModel boat = BoatsModel.fromMap(element.data());
      controller.boatsList.add(boat);
      controller.update();
    });
    log("2");

    controller.boatsList.forEach((boat) {
      controller.selectedSeatsCount
          .add(List.generate(controller.boatsList.length, (index) => 0));
    });
    log("3");

    bookingLogic.controller.bookingModel = BookingModel(
      noOfPersons: 1,
      pax: [
        {
          "first-name": "praveen",
          "email": "praveen@kcn.com",
          "phoneNumber": "564684848712",
        },
      ],
      diveDate: [
        DateTime(2022, 10, 10, 6, 00),
        DateTime(2022, 10, 11, 6, 00),
      ],
    );
    controller.diveDates = bookingLogic.controller.bookingModel.diveDate;
    controller.fixedSeatCount = List.generate(controller.diveDates.length,
        (index) => List.generate(controller.boatsList.length, (index) => 0));

    controller.selectedEmployees = List.generate(controller.diveDates.length,
        (index) => List.generate(controller.boatsList.length, (index) => []));

    log("4");

    for (int dateIndex = 0;
        dateIndex < controller.diveDates.length;
        dateIndex++) {
      log("4.1");
      DateTime diveDate = controller.diveDates[dateIndex];
      var d = await FirebaseFirestore.instance
          .collection("coastGuardSlip")
          .doc(DateFormat("dd-MM-yyyy").format(diveDate))
          .get();
      Map<String, dynamic> data = d.data();
      log("4.2");
      if (data != null && data.containsKey(diveDate.toIso8601String())) {
        log("4.2.1");
        BoatPassengersModel boatModel =
            BoatPassengersModel.fromMap(data[diveDate.toIso8601String()]);
        log("4.2.2");
        controller.fixedSeatCount[dateIndex] =
            getBoatsCount(boatModel.passenger);
        log("4.2.3");
        controller.selectedEmployees[dateIndex] =
            getEmployees(boatModel.employees);
        log("4.2.4");
      }
      log("4.3");
    }

    log("5");

    log(controller.fixedSeatCount.toString());

    controller.requiredCount = List.generate(
        bookingLogic.controller.bookingModel.diveDate.length,
        (index) => bookingLogic.controller.bookingModel.noOfPersons);

    log("6");
  }

  List<int> getBoatsCount(List<Passenger> passenger) {
    List<int> list = List.generate(controller.boatsList.length, (index) => 0);
    for (int i = 0; i < controller.boatsList.length; i++) {
      int fixedSeats = 0;
      for (Passenger p in passenger) {
        if (p.boatID == (i + 1).toString()) {
          fixedSeats++;
        }
      }
      list[i] = fixedSeats;
    }
    return list;
  }

  List<List<Employee>> getEmployees(List<Employee> employees) {
    List<List<Employee>> list =
        List.generate(controller.boatsList.length, (index) => []);

    for (int i = 0; i < controller.boatsList.length; i++) {
      List<Employee> emps = [];
      for (Employee e in employees) {
        if (e.boatID == (i + 1).toString()) {
          emps.add(e);
        }
      }
      list[i] = emps;
    }
    return list;
  }

  onCheckPressed() async {
    // Map<String, Map<String, dynamic>> data = {};

    //! Validation of seat selection.
    for (int i = 0; i < controller.diveDates.length; i++) {
      if (controller.selectedSeatsCount[i].reduce((v, e) => v + e) ==
          controller.requiredCount[i]) {
      } else {
        Fluttertoast.showToast(msg: "Please Select Seats");
        return;
      }
    }

    for (int diveIndex = 0;
        diveIndex < controller.diveDates.length;
        diveIndex++) {
      DateTime diveDate = controller.diveDates[diveIndex];
      var d = await FirebaseFirestore.instance
          .collection("coastGuardSlip")
          .doc(DateFormat("dd-MM-yyyy").format(diveDate))
          .get();
      Map<String, dynamic> data = d.data();
      if (data == null) {
        data = {};
      }
      log(data.toString());
      BoatPassengersModel boatModel;
      if (data.containsKey(diveDate.toIso8601String())) {
        boatModel =
            BoatPassengersModel.fromMap(data[diveDate.toIso8601String()]);
      } else {
        boatModel = BoatPassengersModel(passenger: [], employees: []);
      }
      List<int> selectedSeats = controller.selectedSeatsCount[diveIndex];

      for (int i = 0; i < selectedSeats.length; i++) {
        int boatID = i + 1;
        int selectedSeatCount = selectedSeats[i];
        boatModel.passenger.addAll(List.generate(
            selectedSeatCount,
            (index) => Passenger(
                  name: bookingLogic.controller.bookingModel.pax[0]
                      ["first-name"],
                  email: bookingLogic.controller.bookingModel.pax[0]["email"],
                  phone: bookingLogic.controller.bookingModel.pax[0]
                      ["phoneNumber"],
                  gender: "Male",
                  boatID: boatID.toString(),
                )));
      }
      // List<List<Employee>> selectedEmployee = controller.selectedEmployees[diveIndex];
      // log(controller.selectedEmployees[diveIndex].toString());
      boatModel.employees = [];
      for (int i = 0; i < controller.boatsList.length; i++) {
        boatModel.employees.addAll(controller.selectedEmployees[diveIndex][i]);
      }

      log(boatModel.employees.toString());

      data[diveDate.toIso8601String()] = boatModel.toMap();

      FirebaseFirestore.instance
          .collection("coastGuardSlip")
          .doc(DateFormat("dd-MM-yyyy").format(diveDate))
          .set(data);
    }
  }
}

class ChooseBoatController extends GetxController {
  List<List<int>> selectedSeatsCount = [];
  List<List<int>> fixedSeatCount = [];
  List<List<List<Employee>>> selectedEmployees = [];
  List<BoatsModel> boatsList = [];
  List<DateTime> diveDates = [];
  List<int> requiredCount = [];
  int _currentDiveDateIndex = 0;

  bool _showLoading = false;

  bool get showLoading => _showLoading;

  set showLoading(bool value) {
    _showLoading = value;
    update();
  }

  int get currentDiveDateIndex => _currentDiveDateIndex;

  set currentDiveDateIndex(int value) {
    _currentDiveDateIndex = value;
    update();
  }
}
