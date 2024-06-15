import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/util/alignment_extensions.dart';
import '../../../../core/util/spacing_widgets.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../boat/models/boats.dart';
import '../../../bookings/models/booking_model.dart';
import '../../../employees/model/employee.dart';
import '../widgets/coast_guard_slip_pdf.dart';

class CoastGuardSlipView extends StatefulWidget {
  const CoastGuardSlipView({Key? key}) : super(key: key);

  static Route route() => MaterialPageRoute(
        builder: (context) => const CoastGuardSlipView(),
      );

  @override
  State<CoastGuardSlipView> createState() => _CoastGuardSlipViewState();
}

class _CoastGuardSlipViewState extends State<CoastGuardSlipView> {
  DateTime selectedDate = DateTime.now();
  bool showLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background.lightBlue,
      appBar: const AppBarWidget(heading: 'Coast Guard Slip'),
      body: SafeArea(
        child: Column(
          children: [
            Spacing.h20,
            buildCalenderWidget(),
            Spacing.h20,
            Spacing.h30,
            if (showLoading)
              const CircularProgressIndicator(
                color: Colors.white,
                backgroundColor: Colors.black,
              ).center
            else
              AppButton.flat(
                onTap: generateCoastGuardSlip,
                text: 'Generate',
                color: Colors.black,
                textColor: Colors.white,
              ).center,
          ],
        ).paddingSymmetric(horizontal: 20, vertical: 20),
      ),
    );
  }

  Widget buildCalenderWidget() {
    return Row(
      children: [
        buildButton(
          onTap: () {
            setState(() {
              selectedDate = selectedDate.subtract(const Duration(days: 1));
            });
          },
          icon: Icons.arrow_back_ios_rounded,
        ),
        Spacing.w15,
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            DateFormat('dd-MM-yyyy').format(selectedDate),
            style: TextStyle(
              fontSize: 16,
              color: AppColors.text.black,
              fontWeight: FontWeight.bold,
              fontFamily: AppFonts.nunito,
            ),
          ),
        ),
        Spacing.w15,
        Text(
          DateFormat('EEEE').format(selectedDate),
          style: TextStyle(
            fontSize: 13,
            color: AppColors.text.black,
            fontFamily: AppFonts.nunito,
            fontWeight: FontWeight.w600,
          ),
        ),
        Spacing.w15,
        buildButton(
          onTap: () {
            setState(() {
              selectedDate = selectedDate.add(const Duration(days: 1));
            });
          },
          icon: Icons.arrow_forward_ios_rounded,
        ),
        const Spacer(),
        IconButton(
          splashRadius: 20,
          onPressed: () {
            showDateSelector();
          },
          icon: const Icon(
            Icons.calendar_today_outlined,
            size: 17,
          ),
        ),
      ],
    );
  }

  Widget buildButton({required Function onTap, required IconData icon}) {
    return SizedBox(
      height: 20,
      width: 20,
      child: IconButton(
        splashRadius: 30,
        padding: EdgeInsets.zero,
        onPressed: () {
          onTap();
        },
        icon: Icon(
          icon,
          color: Colors.black,
          size: 14,
        ),
      ),
    );
  }

  void showDateSelector() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2090),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.text.black,
              onPrimary: Colors.white, // header text color
              onSurface: AppColors.text.black, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                textStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: AppColors.text.black,
                ), // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  Future<void> generateCoastGuardSlip() async {
    setState(() {
      showLoading = true;
    });

    List<Boat> boats = await getAllBoats(selectedDate);
    allEmployees = await getEmployees();

    Map<Boat, List<Booking>> cachedBookings = {};
    for (var boat in boats) {
      List<Booking> bookings = await getBookings(selectedDate, boat);
      cachedBookings[boat] = bookings;
    }

    File pdfFile = await CoastGuardSlip.generatePdf(
      selectedDate: selectedDate,
      bookings: cachedBookings,
      employees: allEmployees,
    );
    Share.shareXFiles([XFile(pdfFile.path)]);

    setState(() {
      showLoading = false;
    });
  }

  Future<List<Boat>> getAllBoats(DateTime date) async {
    List<Boat> boats = [];

    var data = await FirebaseFirestore.instance
        .collection('dailyBoats')
        .doc(
          DateFormat('dd-MM-yyyy').format(date),
        )
        .get();
    BoatsModel boatsModel = BoatsModel.fromMap(data.data());
    boats.addAll(boatsModel.boats as Iterable<Boat>);
    return boats;
  }

  Future<List<Booking>> getBookings(DateTime date, Boat boat) async {
    List<Booking> bookings = [];

    var data = await FirebaseFirestore.instance
        .collection('bookings')
        .where(
          'bookingDate',
          arrayContains: DateFormat('dd-MM-yyyy').format(selectedDate),
        )
        .get();
    for (var doc in data.docs) {
      Booking booking = Booking.fromMap(doc.data());

      // Adding only boats that belong to selected boat.
      if (booking.getBoatInfo(selectedDate)?.id == boat.id) {
        bookings.add(booking);
      }
    }

    return bookings;
  }

  Future<List<Employee>> getEmployees() async {
    List<Employee> employees = [];
    var data = await FirebaseFirestore.instance.collection('employees').get();
    for (var doc in data.docs) {
      try {
        Employee employee = Employee.fromMap(doc.data());
        employees.add(employee);
      } catch (e) {
        log('Error getting employes with data : ${doc.data()}');
        log(e.toString());
      }
    }

    return employees;
  }
}
