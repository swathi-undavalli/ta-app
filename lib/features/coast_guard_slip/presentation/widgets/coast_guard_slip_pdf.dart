import 'dart:io';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../boat/models/boat_details.dart';
import '../../../boat/models/boats.dart';
import '../../../bookings/models/booking_model.dart';
import '../../../bookings/presentation/widgets/share_booking_details_widget.dart';
import '../../../employees/model/employee.dart';

class CoastGuardSlip {
  static Future<File> generatePdf({
    required DateTime selectedDate,
    required Map<Boat, List<Booking>> bookings,
    required List<Employee> employees,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageTheme: const pw.PageTheme(
          pageFormat: PdfPageFormat.a4,
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
                  fontSize: 20,
                  wordSpacing: 2,
                  font: pw.Font.timesBold(),
                ),
              ),
              pw.Spacer(),
              pw.Text(
                DateFormat('EEEE, MMMM dd, yyyy').format(selectedDate),
                style: pw.TextStyle(
                  fontSize: 15,
                  color: PdfColors.black,
                  font: pw.Font.timesBold(),
                ),
              ),
              pw.Spacer(),
            ],
          ),
          pw.SizedBox(height: 15),
          ...bookings.keys.map(
            (boat) {
              if (boat.isBoat ?? false) {
                return buildBoat(boat, bookings[boat] ?? [], employees);
              } else {
                return pw.SizedBox();
              }
            },
          ),
          getDSDPAXCount(bookings),
        ],
      ),
    );
    return ShareBookingDetails.saveDocument(name: 'coatGuardSlip.pdf', pdf: pdf);
  }

  static pw.Widget buildBoat(Boat boat, List<Booking> bookings, List<Employee> employees) {
    List<Instructor> instructors = getInstructors(bookings);
    List<Customer> customers = getCustomers(bookings);
    return pw.Column(
      children: [
        buildLine(),
        buildBoatDetails(boat, employees),
        buildLine(),
        buildTitles(),
        buildLine(),
        pw.SizedBox(height: 15),
        ...List.generate(
          instructors.length,
          (index) => buildCustomerDetails(
            index: index + 1,
            name: instructors[index].name,
            gender: allEmployees(employees, instructors[index].id)?.gender ?? '-',
            category: 'Staff',
            country: 'India',
            diveSite: '${boat.diveSite}',
          ),
        ),
        ...List.generate(
          customers.length,
          (index) => buildCustomerDetails(
            index: instructors.length + index + 1,
            name: customers[index].name ?? '-',
            gender: customers[index].gender ?? 'Male',
            category: customers[index].course ?? '-',
            country: customers[index].country ?? 'India',
            diveSite: '${boat.diveSite}',
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

  static pw.Widget buildBoatDetails(Boat boat, List<Employee> employees) {
    pw.Widget buildText(String text) => pw.Text(
          text,
          textAlign: pw.TextAlign.center,
          style: pw.TextStyle(
            fontSize: 12,
            color: PdfColors.black,
            font: pw.Font.timesBold(),
          ),
        );

    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 15, bottom: 15),
      child: pw.Row(
        children: [
          pw.Column(
            children: [
              pw.Text(
                '${boat.name} - ${boat.time}',
                style: pw.TextStyle(
                  fontSize: 20,
                  color: PdfColors.black,
                  font: pw.Font.timesBold(),
                ),
              ),
            ],
          ),
          pw.Spacer(),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            mainAxisAlignment: pw.MainAxisAlignment.start,
            children: [
              buildText('Boat No : ${boat.boatNo ?? '-'}'),
              pw.SizedBox(height: 2),
              if (boat.captains != null && boat.captains!.isNotEmpty)
                buildText(
                  'Captain : ${boat.captains?[0].name} ( ${allEmployees(employees, boat.captains![0].id)?.phoneNumber} )',
                ),
              pw.SizedBox(height: 2),
              if (boat.captains != null && boat.captains?.length == 2)
                buildText(
                  'Incharge : ${boat.captains?[1].name} ( ${allEmployees(employees, boat.captains![1].id)?.phoneNumber} )',
                ),
              if (boat.surfaceSupport != null && boat.surfaceSupport!.isNotEmpty)
                pw.Wrap(
                  children: [
                    buildText('Surface Support : '),
                    ...?boat.surfaceSupport?.map(
                      (e) => buildText('${e.name}, '),
                    )
                  ],
                ),
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
            fontSize: 12,
            color: PdfColors.black,
            font: pw.Font.timesBold(),
          ),
        );

    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 15, bottom: 15),
      child: pw.Row(
        children: [
          pw.SizedBox(
            width: 30,
            child: buildText('SI.No'),
          ),
          pw.SizedBox(
            width: 100,
            child: buildText('Diver Names'),
          ),
          pw.SizedBox(
            width: 70,
            child: buildText('Gender'),
          ),
          pw.SizedBox(
            width: 70,
            child: buildText('Dive Category'),
          ),
          pw.SizedBox(
            width: 70,
            child: buildText('Country'),
          ),
          pw.SizedBox(
            width: 120,
            child: buildText('Dive Site'),
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
    required String diveSite,
  }) {
    pw.Widget buildText(String text) => pw.Text(
          text,
          textAlign: pw.TextAlign.center,
          style: pw.TextStyle(
            fontSize: 12,
            color: PdfColors.black,
            font: pw.Font.timesBold(),
          ),
        );

    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 5, bottom: 5),
      child: pw.Row(
        children: [
          pw.SizedBox(
            width: 30,
            child: buildText('$index'),
          ),
          pw.SizedBox(
            width: 100,
            child: buildText(name),
          ),
          pw.SizedBox(
            width: 70,
            child: buildText(gender),
          ),
          pw.SizedBox(
            width: 70,
            child: buildText(category),
          ),
          pw.SizedBox(
            width: 70,
            child: buildText(country),
          ),
          pw.SizedBox(
            width: 120,
            child: buildText(diveSite),
          ),
        ],
      ),
    );
  }

  static pw.Widget getDSDPAXCount(Map<Boat, List<Booking>> bookings) {
    int totalDSD = 0;
    int totalCustomers = 0;
    int totalInstructors = 0;

    for (Boat boat in bookings.keys) {
      Iterable<Customer> customers = getCustomers(bookings[boat] ?? []);
      Iterable<Customer> dsdCustomers = customers.where((customer) => customer.course == 'DSD').toList();
      List<Instructor> instructors = getInstructors(bookings[boat] ?? []);

      totalDSD += dsdCustomers.length;
      totalCustomers += customers.length;
      totalInstructors += instructors.length;
    }

    return pw.Text('DSD : $totalDSD');
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
      booking.pax?.sublist(1).forEach((person) {
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

Employee? allEmployees(List<Employee> allEmployees, String id) {
  for (var element in allEmployees) {
    if (element.id == id) {
      return element;
    }
  }
  return null;
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
