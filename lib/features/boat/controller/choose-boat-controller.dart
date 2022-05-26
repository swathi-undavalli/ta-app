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
      controller.selectedSeatsCount.add(
        List.generate(
          controller.boatsList.length,
          (index) {
            return 0;
          },
        ),
      );
      controller.firebaseSeatsCount.add(
        List.generate(
          controller.boatsList.length,
          (index) {
            return 0;
          },
        ),
      );
    });

    log("3");

    // controller.bookingModel = BookingModel(
    //   noOfPersons: 1,
    //   pax: [
    //     {
    //       "first-name": "praveen",
    //       "email": "praveen@kcn.com",
    //       "phoneNumber": "564684848712",
    //     },
    //   ],
    //   diveDate: [
    //     DateTime(2022, 10, 10, 6, 00),
    //     DateTime(2022, 10, 11, 6, 00),
    //   ],
    // );
    controller.bookingModel = Get.arguments as BookingModel;
    controller.diveDates = controller.bookingModel.diveDate;
    controller.fixedSeatCount = List.generate(controller.diveDates.length,
        (index) => List.generate(controller.boatsList.length, (index) => 0));

    controller.selectedEmployees = List.generate(controller.diveDates.length,
        (index) => List.generate(controller.boatsList.length, (index) => []));
    controller.selectedFreelancers = List.generate(controller.diveDates.length,
        (index) => List.generate(controller.boatsList.length, (index) => []));
    controller.commonEmployees = List.generate(
        controller.boatsList.length,
        (index) => controller.selectedEmployees[controller.currentDiveDateIndex]
            [index]).expand((x) => x).toList();
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
        try {
          BoatPassengersModel boatModel =
              BoatPassengersModel.fromMap(data[diveDate.toIso8601String()]);
        } catch (e) {
          log("issue here $e");
        }
        BoatPassengersModel boatModel =
            BoatPassengersModel.fromMap(data[diveDate.toIso8601String()]);
        log("4.2.2");
        controller.fixedSeatCount[dateIndex] =
            getBoatsCount(boatModel.passenger);
        log("4.2.3");
        controller.selectedEmployees[dateIndex] =
            getEmployees(boatModel.employees);
        controller.selectedFreelancers[dateIndex] =
            getFreelancers(boatModel.freelancer);

        controller.selectedSeatsCount[dateIndex] =
            getSelectedSeatsCount(boatModel.passenger);
        controller.firebaseSeatsCount[dateIndex] =
            getSelectedSeatsCount(boatModel.passenger);

        log("4.2.4");
      }
      log("4.3");
    }

    log("5");

    log(controller.fixedSeatCount.toString());

    controller.requiredCount = List.generate(
        controller.bookingModel.diveDate.length,
        (index) => controller.bookingModel.noOfPersons);
    controller.commonEmployees = List.generate(
        controller.boatsList.length,
        (index) => controller.selectedEmployees[controller.currentDiveDateIndex]
            [index]).expand((x) => x).toList();

    log("6");
  }

  List<int> getBoatsCount(List<Passenger> passenger) {
    List<int> list = List.generate(controller.boatsList.length, (index) => 0);
    for (int i = 0; i < controller.boatsList.length; i++) {
      int fixedSeats = 0;
      for (Passenger p in passenger) {
        if (p.boatID == (i + 1).toString()) {
          if (p.email != controller.bookingModel.pax[0]["email"]) fixedSeats++;
        }
      }
      list[i] = fixedSeats;
    }
    return list;
  }

  List<int> getSelectedSeatsCount(List<Passenger> passenger) {
    List<int> list = List.generate(controller.boatsList.length, (index) => 0);
    for (int i = 0; i < controller.boatsList.length; i++) {
      int selectedSeats = 0;
      for (Passenger p in passenger) {
        if (p.boatID == (i + 1).toString()) {
          if (p.email == controller.bookingModel.pax[0]["email"])
            selectedSeats++;
        }
      }
      list[i] = selectedSeats;
    }
    return list;
  }

  List<List<Employees>> getEmployees(List<Employees> employees) {
    List<List<Employees>> list =
        List.generate(controller.boatsList.length, (index) => []);

    for (int i = 0; i < controller.boatsList.length; i++) {
      List<Employees> emps = [];
      for (Employees e in employees) {
        if (e.boatID == (i + 1).toString()) {
          emps.add(e);
        }
      }
      list[i] = emps;
    }
    return list;
  }

  List<List<Freelancer>> getFreelancers(List<Freelancer> freelancers) {
    List<List<Freelancer>> list =
        List.generate(controller.boatsList.length, (index) => []);

    for (int i = 0; i < controller.boatsList.length; i++) {
      List<Freelancer> fls = [];
      for (Freelancer f in freelancers) {
        if (f.boatID == (i + 1).toString()) {
          fls.add(f);
        }
      }
      list[i] = fls;
    }
    return list;
  }

  onCheckPressed() async {
    controller.showLoading = true;
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
        boatModel =
            BoatPassengersModel(passenger: [], employees: [], freelancer: []);
      }

      List<int> selectedSeats = controller.selectedSeatsCount[diveIndex];
      log(boatModel.passenger.length.toString());

      for (int dateIndex = 0;
          dateIndex < controller.diveDates.length;
          dateIndex++) {
        for (int boatIndex = 0;
            boatIndex < controller.boatsList.length;
            boatIndex++) {
          if (controller.firebaseSeatsCount[dateIndex][boatIndex] -
                  controller.selectedSeatsCount[dateIndex][boatIndex] ==
              0) {
          } else if (controller.firebaseSeatsCount[dateIndex][boatIndex] -
                  controller.selectedSeatsCount[dateIndex][boatIndex] >
              0) {
            log("a");
            int diff = controller.firebaseSeatsCount[dateIndex][boatIndex] -
                controller.selectedSeatsCount[dateIndex][boatIndex];

            for (int i = 0; i < diff; i++) {
              for (int p = 0; p < boatModel.passenger.length; p++) {
                if (boatModel.passenger[p].email ==
                        controller.bookingModel.pax[0]["email"] &&
                    boatModel.passenger[p].boatID ==
                        (boatIndex + 1).toString()) {
                  log("found");
                  boatModel.passenger.removeAt(p);
                  break;
                }
              }
            }
          } else {
            int diff = controller.selectedSeatsCount[dateIndex][boatIndex] -
                controller.firebaseSeatsCount[dateIndex][boatIndex];
            for (int i = 0; i < diff; i++) {
              boatModel.passenger.add(
                Passenger(
                  name: controller.bookingModel.pax[0]["first-name"],
                  email: controller.bookingModel.pax[0]["email"],
                  phone: controller.bookingModel.pax[0]["phoneNumber"],
                  gender: "Male",
                  boatID: (boatIndex + 1).toString(),
                ),
              );
            }
          }
        }
      }
      log(boatModel.passenger.length.toString());

      // for (int i = 0; i < selectedSeats.length; i++) {
      //   int boatID = i + 1;
      //   int selectedSeatCount = selectedSeats[i];
      //   boatModel.passenger.addAll(
      //     List.generate(
      //       selectedSeatCount,
      //       (index) => Passenger(
      //         name: controller.bookingModel.pax[0]["first-name"],
      //         email: controller.bookingModel.pax[0]["email"],
      //         phone: controller.bookingModel.pax[0]["phoneNumber"],
      //         gender: "Male",
      //         boatID: boatID.toString(),
      //       ),
      //     ),
      //   );
      // }
      log(boatModel.passenger.length.toString());
      // log("------------------------");

      // List<List<Employee>> selectedEmployee = controller.selectedEmployees[diveIndex];
      // log(controller.selectedEmployees[diveIndex].toString());
      boatModel.employees = [];
      for (int i = 0; i < controller.boatsList.length; i++) {
        boatModel.employees.addAll(controller.selectedEmployees[diveIndex][i]);
      }
      boatModel.freelancer = [];
      for (int i = 0; i < controller.boatsList.length; i++) {
        boatModel.freelancer
            .addAll(controller.selectedFreelancers[diveIndex][i]);
      }

      log(boatModel.employees.toString());

      data[diveDate.toIso8601String()] = boatModel.toMap();

      FirebaseFirestore.instance
          .collection("coastGuardSlip")
          .doc(DateFormat("dd-MM-yyyy").format(diveDate))
          .set(data);
    }
    controller.showLoading = false;
    Get.back();
  }
}

class ChooseBoatController extends GetxController {
  List<List<int>> selectedSeatsCount = [];
  List<List<int>> firebaseSeatsCount = [];
  List<List<int>> fixedSeatCount = [];
  List<List<List<Employees>>> selectedEmployees = [];
  List<List<List<Freelancer>>> selectedFreelancers = [];
  List<Employees> commonEmployees = [];
  List<BoatsModel> boatsList = [];
  List<DateTime> diveDates = [];
  List<int> requiredCount = [];
  int _currentDiveDateIndex = 0;

  BookingModel bookingModel;

  reset() {
    selectedSeatsCount = [];
    firebaseSeatsCount = [];
    fixedSeatCount = [];
    selectedEmployees = [];
    boatsList = [];
    diveDates = [];
    requiredCount = [];
    currentDiveDateIndex = 0;
    showLoading = true;
  }

  bool _showLoading = true;

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
