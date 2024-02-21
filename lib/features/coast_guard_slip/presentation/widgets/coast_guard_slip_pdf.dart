import 'dart:developer';
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
          buildCompanyDetails(selectedDate),
          pw.SizedBox(height: 15),
          buildDarkLine(),
          pw.SizedBox(height: 20),
          ...bookings.keys.map(
            (boat) {
              if (boat.isBoat ?? false) {
                return buildBoat(boat, bookings[boat] ?? [], employees);
              } else {
                return pw.SizedBox();
              }
            },
          ),
          pw.SizedBox(height: 15),
          buildSubTitle(title: 'InCharge  :', text: 'Azharudheen ( 8098629070 )\n'),
          buildSubTitle(title: 'OverAll InCharges  :  ', text: 'Rob ( 9789270958 )\nSanthosh ( 8508854778 )'),
        ],
      ),
    );
    return ShareBookingDetails.saveDocument(name: 'coatGuardSlip.pdf', pdf: pdf);
  }

  static pw.Widget buildCompanyDetails(DateTime selectedDate) {
    return pw.Column(
      mainAxisAlignment: pw.MainAxisAlignment.center,
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Text(
          'Temple Adventures',
          textAlign: pw.TextAlign.center,
          style: pw.TextStyle(
            color: PdfColors.black,
            fontSize: 30,
            wordSpacing: 2,
            font: pw.Font.timesBold(),
          ),
        ),
        pw.SizedBox(height: 15),
        pw.Text(
          'EAST COAST WATERSPORTS PVT LTD,#6A, Gandhi st., Colas Nagar,Opposite to Indira Gandhi Stadium Pondicherry, India Contact : +91 9940219449 / 6385686600',
          style: pw.TextStyle(
            color: PdfColor.fromInt(0xff263238),
            font: pw.Font.times(),
            fontSize: 12,
          ),
        ),
        pw.SizedBox(height: 15),
        pw.Text(
          DateFormat('EEEE, MMMM dd, yyyy').format(selectedDate),
          style: pw.TextStyle(
            fontSize: 15,
            color: PdfColors.black,
            font: pw.Font.timesBold(),
          ),
        ),
      ],
    );
  }

  static pw.Widget buildBoat(Boat boat, List<Booking> bookings, List<Employee> employees) {
    List<Instructor> instructors = getInstructors(bookings);
    List<Customer> customers = getCustomers(bookings);
    List<Instructor> diveBuddies = getDiveBuddies(bookings);
    return pw.Column(
      mainAxisAlignment: pw.MainAxisAlignment.start,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
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
          ),
        ),
        ...List.generate(
          diveBuddies.length,
          (index) => buildCustomerDetails(
            index: instructors.length + index + 1,
            name: diveBuddies[index].name,
            gender: allEmployees(employees, diveBuddies[index].id)?.gender ?? '-',
            category: 'Staff',
            country: 'India',
          ),
        ),
        if (boat.dsdInstructors != null && boat.dsdInstructors!.isNotEmpty)
          ...List.generate(
            (boat.dsdInstructors ?? []).length,
            (index) => buildCustomerDetails(
              index: instructors.length + diveBuddies.length + index + 1,
              name: boat.dsdInstructors?[index].name ?? '',
              gender: allEmployees(employees, boat.dsdInstructors?[index].id)?.gender ?? '-',
              category: 'Staff',
              country: 'India',
            ),
          ),
        ...List.generate(
          customers.length,
          (index) => buildCustomerDetails(
            index: instructors.length + diveBuddies.length + (boat.dsdInstructors ?? []).length + index + 1,
            name: customers[index].name ?? '-',
            gender: customers[index].gender ?? '-',
            category: customers[index].course ?? '-',
            country: customers[index].country ?? 'India',
          ),
        ),
        pw.SizedBox(height: 20),
        getDSDPAXCount(bookings, boat),
        pw.SizedBox(height: 20),
        buildDarkLine(),
        pw.SizedBox(height: 20),
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

  static pw.Widget buildDarkLine() {
    return pw.Container(
      height: 1,
      width: Get.width * 4,
      color: PdfColors.black,
    );
  }

  static pw.Widget buildSubTitle({required String title, String? text}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 5, bottom: 5),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.end,
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          pw.Container(
            width: 130,
            child: pw.Text(
              title,
              style: pw.TextStyle(
                fontSize: 14,
                font: pw.Font.timesBold(),
                color: PdfColors.black,

                // fontWeight: FontWeight.w500,
              ),
            ),
          ),
          pw.Container(
            width: 180,
            child: pw.Text(
              (text != null && text.isNotEmpty) ? text : '-',
              style: pw.TextStyle(
                fontSize: 14,
                color: PdfColor.fromInt(0xff575757),
                font: pw.Font.timesBold(),

                // fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget buildText(String text) => pw.Text(
        text,
        textAlign: pw.TextAlign.center,
        style: pw.TextStyle(
          fontSize: 12,
          color: PdfColors.black,
          font: pw.Font.timesBold(),
        ),
      );

  static pw.Widget buildBoatDetails(Boat boat, List<Employee> employees) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 25, bottom: 25),
      child: pw.Row(
        children: [
          pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                '${boat.name.replaceAll(RegExp(r'[^\w\s]+'), '')} - ${boat.time}',
                style: pw.TextStyle(
                  fontSize: 20,
                  color: PdfColors.black,
                  font: pw.Font.timesBold(),
                ),
              ),
              pw.SizedBox(height: 5),
              pw.Text(
                '${boat.diveSite}',
                style: pw.TextStyle(
                  fontSize: 15,
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
              if (boat.boatNo != null && boat.boatNo != '') buildText('Boat No : ${boat.boatNo}'),
              pw.SizedBox(height: 2),
              if (boat.captains != null && boat.captains!.isNotEmpty)
                buildText(
                  'Captain : ${boat.captains?[0].name} ( ${allEmployees(employees, boat.captains![0].id)?.phoneNumber} )',
                ),
              pw.SizedBox(height: 2),
              if (boat.captains != null && boat.captains?.length == 2)
                buildText(
                  'InCharge : ${boat.captains?[1].name} ( ${allEmployees(employees, boat.captains![1].id)?.phoneNumber} )',
                ),
              if (boat.surfaceSupport != null && boat.surfaceSupport!.isNotEmpty)
                pw.SizedBox(
                  width: 200,
                  child: pw.Wrap(
                    children: [
                      buildText('Surface Support : '),
                      ...?boat.surfaceSupport?.map(
                        (e) => buildText('${e.name}, '),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget buildTitles() {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 15, bottom: 15),
      child: pw.Row(
        children: [
          pw.SizedBox(
            width: 40,
            child: buildText('SI.No'),
          ),
          pw.SizedBox(
            width: 150,
            child: buildText('Diver Names'),
          ),
          pw.SizedBox(
            width: 90,
            child: buildText('Gender'),
          ),
          pw.SizedBox(
            width: 90,
            child: buildText('Dive Category'),
          ),
          pw.SizedBox(
            width: 90,
            child: buildText('Country'),
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
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 5, bottom: 5),
      child: pw.Row(
        children: [
          pw.SizedBox(
            width: 40,
            child: buildText('$index'),
          ),
          pw.SizedBox(
            width: 150,
            child: buildText(name),
          ),
          pw.SizedBox(
            width: 90,
            child: buildText(gender),
          ),
          pw.SizedBox(
            width: 90,
            child: buildText(category),
          ),
          pw.SizedBox(
            width: 90,
            child: buildText(country),
          ),
        ],
      ),
    );
  }

  static pw.Widget getDSDPAXCount(List<Booking>? bookings, Boat boat) {
    Iterable<Customer> totalCustomers = getCustomers(bookings ?? []);
    Iterable<Customer> dsdCustomers = totalCustomers.where((customer) => customer.course == 'DSD').toList();
    List<Instructor> staff = getInstructors(bookings ?? []);
    List<Instructor> diveBuddies = getDiveBuddies(bookings ?? []);

    pw.Widget buildText(String text) => pw.Text(
          text,
          style: pw.TextStyle(
            fontSize: 12,
            color: PdfColors.black,
            font: pw.Font.timesBold(),
          ),
        );

    return pw.Container(
      width: 3508,
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.end,
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              if (totalCustomers.isNotEmpty) buildText('Total Customers : ${totalCustomers.length}'),
              if (dsdCustomers.isNotEmpty) buildText('Total DSD : ${dsdCustomers.length}'),
              if (boat.dsdInstructors != null && boat.dsdInstructors!.isNotEmpty)
                buildText('DSD Instructors : ${boat.dsdInstructors?.length}'),
              if (staff.isNotEmpty) buildText('Total Staff : ${staff.length + diveBuddies.length}'),
            ],
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

List<Instructor> getDiveBuddies(List<Booking> bookings) {
  List<Instructor> diveBuddies = [];

  for (var booking in bookings) {
    if (booking.boatDetails?.diveBuddies != null && booking.boatDetails!.diveBuddies!.isNotEmpty) {
      for (var diveBuddy in booking.boatDetails!.diveBuddies!) {
        diveBuddies.add(diveBuddy);
      }
    }
  }
  return diveBuddies;
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

Employee? allEmployees(List<Employee> allEmployees, String? id) {
  for (var element in allEmployees) {
    if (element.id == id) {
      log(element.toMap().toString());
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
