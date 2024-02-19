import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import '../../boat/models/boats.dart';
import '../../bookings/models/booking_model.dart';
import '../presentation/widgets/coast_guard_slip_pdf.dart';

class CoastGuardSlipLogic {
  CoastGuardSlipController controller = Get.put(CoastGuardSlipController());

  Future<void> init() async {
    controller.showLoading = true;
    await getAllBoats();
    await getAllBookings();
    controller.showLoading = false;
  }

  Future<void> getAllBoats() async {
    controller.boats = [];

    var data = await FirebaseFirestore.instance
        .collection('dailyBoats')
        .doc(DateFormat('dd-MM-yyyy').format(controller.selectedDate))
        .get();

    BoatsModel boatsModel = BoatsModel.fromMap(data.data());
    controller.boats.addAll(boatsModel.boats as Iterable<Boat>);
  }

  Future<void> getAllBookings() async {
    controller.bookings = [];

    var data = await FirebaseFirestore.instance
        .collection('bookings')
        .where(
          'bookingDate',
          arrayContains: DateFormat('dd-MM-yyyy').format(controller.selectedDate),
        )
        .get();

    for (var element in data.docs) {
      Booking booking = Booking.fromMap(element.data());
      controller.bookings.add(booking);
    }
  }

  Future<void> onDateChanged(DateTime date) async {
    controller.selectedDate = date;
    controller.showLoading = true;
    await init();
    controller.showLoading = false;
  }

  Future<void> generateCoastGuardSlip() async {
    log(controller.boats.toList().toString());
    log(controller.bookings.toList().toString());
    if (controller.boats.isNotEmpty) {
      File pdfFile = await CoastGuardSlip.generatePdf(
        selectedDate: controller.selectedDate,
        boats: controller.boats,
        allBookings: controller.bookings,
      );
      Share.shareFiles([pdfFile.path]);
    } else {
      Fluttertoast.showToast(msg: 'No Boats Added');
    }
  }
}

class CoastGuardSlipController extends GetxController {
  DateTime selectedDate = DateTime.now();
  bool _showLoading = true;

  bool get showLoading => _showLoading;

  set showLoading(bool value) {
    _showLoading = value;
    update();
  }

  List<Boat> boats = [];
  List<Booking> bookings = [];
}
