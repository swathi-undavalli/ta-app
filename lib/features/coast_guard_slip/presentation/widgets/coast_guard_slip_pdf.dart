import 'dart:io';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../boat/models/boat_details.dart';
import '../../../boat/models/boats.dart';
import '../../../bookings/models/booking_model.dart';
import '../../../bookings/presentation/widgets/share_booking_details_widget.dart';

class CoastGuardSlip {
  static Future<File> generatePdf({
    required DateTime selectedDate,
    required Map<Boat, List<Booking>> bookings,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          pageFormat: PdfPageFormat.a3.landscape,
        ),
        build: (context) => <pw.Widget>[
          pw.Row(
            children: [
              pw.Spacer(),
              pw.Spacer(),
              pw.Text(
                'Temple Adventures',
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  color: PdfColors.black,
                  fontSize: 50,
                  wordSpacing: 2,
                  font: pw.Font.timesBold(),
                ),
              ),
              pw.Spacer(),
              pw.Text(
                DateFormat('EEEE, MMMM dd, yyyy').format(selectedDate),
                style: pw.TextStyle(
                  fontSize: 23,
                  color: PdfColors.black,
                  font: pw.Font.timesBold(),
                ),
              ),
              pw.Spacer(),
            ],
          ),
          pw.SizedBox(height: 25),
          ...bookings.keys.map(
            (boat) => buildBoat(boat, bookings[boat] ?? []),
          ),
        ],
      ),
    );
    return ShareBookingDetails.saveDocument(name: 'coatGuardSlip.pdf', pdf: pdf);
  }

  static pw.Widget buildBoat(Boat boat, List<Booking> bookings) {
    List<Instructor> instructors = getInstructors(bookings);
    List<Customer> customers = getCustomers(bookings);

    return pw.Column(
      children: [
        buildLine(),
        pw.SizedBox(height: 25),
        buildBoatDetails(boat),
        buildLine(),
        buildTitles(),
        buildLine(),
        pw.SizedBox(height: 25),
        ...List.generate(
          instructors.length,
          (index) => buildCustomerDetails(
            index: index + 1,
            name: instructors[index].name,
            gender: 'Get Gender',
            category: 'Staff',
            country: 'India',
            boatTime: '${boat.name} - ${boat.time}',
            isInstructor: true,
          ),
        ),
        ...List.generate(
          customers.length,
          (index) => buildCustomerDetails(
            index: instructors.length + index + 1,
            name: customers[index].name ?? '-',
            gender: customers[index].gender ?? '-',
            category: customers[index].course ?? '-',
            country: customers[index].country ?? '-',
            boatTime: '${boat.name} - ${boat.time}',
            isInstructor: true,
          ),
        ),
        pw.SizedBox(height: 20),
        buildLine(),
      ],
    );
  }

  static pw.Widget buildLine() {
    return pw.Container(
      height: 1,
      width: Get.width * 4,
      color: const PdfColor.fromInt(0xffD9D9D9),
    );
  }

  static pw.Widget buildBoatDetails(Boat boat) {
    pw.Widget buildText(String text) => pw.Text(
          text,
          textAlign: pw.TextAlign.center,
          style: pw.TextStyle(
            fontSize: 20,
            color: PdfColors.black,
            font: pw.Font.timesBold(),
          ),
        );

    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 25, bottom: 25),
      child: pw.Row(
        children: [
          pw.Text(
            boat.name,
            style: pw.TextStyle(
              fontSize: 40,
              color: PdfColors.black,
              font: pw.Font.timesBold(),
            ),
          ),
          pw.Spacer(),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            mainAxisAlignment: pw.MainAxisAlignment.start,
            children: [
              buildText('Boat No    : ${boat.time}'),
              if (boat.captains != null && boat.captains!.isNotEmpty)
                buildText('Captain    : ${boat.captains?[0].name} ( ${boat.captains?[0].phone} )'),
              if (boat.captains != null && boat.captains?.length == 2)
                buildText('Incharge   : ${boat.captains?[1].name} ( ${boat.captains?[1].phone} )'),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget buildTitles() {
    pw.Widget buildText(String text) => pw.Text(
          text,
          textAlign: pw.TextAlign.center,
          style: pw.TextStyle(
            fontSize: 20,
            color: PdfColors.black,
            font: pw.Font.timesBold(),
          ),
        );

    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 25, bottom: 25),
      child: pw.Row(
        children: [
          pw.SizedBox(
            width: 100,
            child: buildText('SI.No.'),
          ),
          pw.SizedBox(
            width: 230,
            child: buildText('Diver Names'),
          ),
          pw.SizedBox(
            width: 170,
            child: buildText('Gender'),
          ),
          pw.SizedBox(
            width: 170,
            child: buildText('Dive Category'),
          ),
          pw.SizedBox(
            width: 170,
            child: buildText('Country'),
          ),
          pw.SizedBox(
            width: 200,
            child: buildText('Boat-Time'),
          ),
        ],
      ),
    );
  }

  static pw.Widget buildCustomerDetails({
    required int index,
    required String name,
    required String gender,
    required String category,
    required String country,
    required String boatTime,
    required bool isInstructor,
  }) {
    pw.Widget buildText(String text) => pw.Text(
          text,
          textAlign: pw.TextAlign.center,
          style: pw.TextStyle(
            fontSize: 20,
            color: PdfColors.black,
            font: pw.Font.timesBold(),
          ),
        );

    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 5, bottom: 5),
      child: pw.Row(
        children: [
          pw.SizedBox(
            width: 100,
            child: buildText('$index'),
          ),
          pw.SizedBox(
            width: 230,
            child: buildText(name),
          ),
          pw.SizedBox(
            width: 170,
            child: buildText(gender),
          ),
          pw.SizedBox(
            width: 170,
            child: buildText(category),
          ),
          pw.SizedBox(
            width: 170,
            child: buildText(country),
          ),
          pw.SizedBox(
            width: 200,
            child: buildText(boatTime),
          ),
        ],
      ),
    );
  }
}

List<Instructor> getInstructors(List<Booking> bookings) {
  List<Instructor> instructors = [];

  for (var booking in bookings) {
    if (booking.instructor?.id != null) {
      instructors.add(booking.instructor!);
    }
  }

  return instructors.toSet().toList();
}

List<Customer> getCustomers(List<Booking> bookings) {
  List<Customer> customers = [];

  for (var booking in bookings) {
    if ((booking.pax?.length ?? 0) > 1) {
      booking.pax?.forEach((person) {
        Customer customer = Customer(
          name: (person['first-name'] ?? '') + (person['last-name'] ?? ''),
          gender: person['gender'],
          country: person['country'],
          course: booking.activity?.firstOrNull?.shortName,
        );
        customers.add(customer);
      });
    }
  }

  return customers.toSet().toList();
}

class Customer {
  String? name;
  String? gender;
  String? country;
  String? course;

  Customer({
    required this.name,
    required this.gender,
    required this.country,
    required this.course,
  });

  @override
  bool operator ==(Object other) {
    return (other is Customer) && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;
}
