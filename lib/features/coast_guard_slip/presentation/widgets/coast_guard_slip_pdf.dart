import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:temple_ui_tools/utils/utils.dart';

import '../../../../core/widgets/time_picker.dart';
import '../../../boat/models/boat_details.dart';
import '../../../boat/models/boats.dart';
import '../../../bookings/models/booking_model.dart';
import '../../../bookings/presentation/widgets/share_booking_details_widget.dart';
import '../../../employees/model/employee.dart';

List<Employee> allEmployees = [];

class CoastGuardSlip {
  static Future<File> generatePdf({
    required DateTime selectedDate,
    required Map<Boat, List<Booking>> bookings,
    required List<Employee> employees,
  }) async {
    final pdf = pw.Document();

    List<Boat> boats = bookings.keys.toList();
    boats.sort((a, b) {
      return (TimePicker.getDateTime(a.time) ?? DateTime.now())
          .compareTo(TimePicker.getDateTime(b.time) ?? DateTime.now());
    });

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
          ...boats.map(
            (boat) {
              if ((boat.isBoat ?? false) && ((bookings[boat] ?? []).isNotEmpty)) {
                return buildBoat(boat, bookings[boat] ?? [], selectedDate);
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

  static Map<String, pw.ImageProvider> idProofs = {};

  static Future<File> generateIDProofs({
    required DateTime selectedDate,
    required Map<Boat, List<Booking>> bookings,
  }) async {
    final pdf = pw.Document();

    List<Boat> boats = bookings.keys.toList();
    boats.sort((a, b) {
      return (TimePicker.getDateTime(a.time) ?? DateTime.now())
          .compareTo(TimePicker.getDateTime(b.time) ?? DateTime.now());
    });

    for (final bookingsList in bookings.values) {
      final customers = getCustomers(bookingsList).where((customer) => customer.idProof.isNotEmpty);

      for (var customer in customers) {
        for (final id in customer.idProof) {
          if (idProofs.containsKey(id)) continue;
          try {
            final netImage = await networkImage(id);
            idProofs[id] = netImage;
          } catch (e) {
            log(e.toString());
          }
        }
      }
    }

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
          ...boats.map(
            (boat) {
              if ((boat.isBoat ?? false) && ((bookings[boat] ?? []).isNotEmpty)) {
                return _buildIDProofs(boat, bookings[boat] ?? [], selectedDate);
              } else {
                return pw.SizedBox();
              }
            },
          ),
        ],
      ),
    );
    return ShareBookingDetails.saveDocument(name: 'id_proofs.pdf', pdf: pdf);
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
          'EAST COAST WATERSPOUTS PVT LTD,#6A, Gandhi st., Colas Nagar,Opposite to Indira Gandhi Stadium Pondicherry, India Contact : +91 9940219449 / 6385686600',
          style: pw.TextStyle(
            color: const PdfColor.fromInt(0xff263238),
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

  static pw.Widget buildBoat(Boat boat, List<Booking> bookings, DateTime selectedDate) {
    // TODO : Show intern photo/video and instructor photo/video.
    List<Instructor> instructors = getInstructors(bookings, selectedDate);
    List<Customer> customers = getCustomers(bookings);
    List<Instructor> diveBuddies = getDiveBuddies(bookings);
    List<Instructor> dsdInstructors = (boat.dsdInstructors ?? []).map((instructor) {
      return Instructor.fromEmployee(getEmployee(instructor.id)!);
    }).toList();

    return pw.Column(
      mainAxisAlignment: pw.MainAxisAlignment.start,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        buildBoatDetails(boat),
        buildLine(),
        buildTitles(),
        buildLine(),
        pw.SizedBox(height: 15),
        ...List.generate(
          instructors.length,
          (index) => buildCustomerDetails(
            index: index + 1,
            name: instructors[index].name,
            gender: instructors[index].gender ?? '-',
            category: 'Staff',
            country: 'India',
          ),
        ),
        ...List.generate(
          diveBuddies.length,
          (index) => buildCustomerDetails(
            index: instructors.length + index + 1,
            name: diveBuddies[index].name,
            gender: diveBuddies[index].gender ?? '-',
            category: 'Staff',
            country: 'India',
          ),
        ),
        ...List.generate(
          dsdInstructors.length,
          (index) => buildCustomerDetails(
            index: instructors.length + diveBuddies.length + index + 1,
            name: dsdInstructors[index].name,
            gender: dsdInstructors[index].gender ?? '-',
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
            bookingId: customers[index].bookingId,
          ),
        ),
        pw.SizedBox(height: 20),
        getDSDPAXCount(bookings, boat, selectedDate),
        pw.SizedBox(height: 20),
        buildDarkLine(),
        pw.SizedBox(height: 20),
      ],
    );
  }

  static pw.Widget _buildIDProofs(Boat boat, List<Booking> bookings, DateTime selectedDate) {
    List<Customer> customers = getCustomers(bookings);

    return pw.Column(
      mainAxisAlignment: pw.MainAxisAlignment.start,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        buildBoatDetails(boat),
        buildLine(),
        pw.SizedBox(height: 15),
        ...List.generate(
          customers.length,
          (index) => _buildIDProofPhoto(customer: customers[index]),
        ),
        pw.SizedBox(height: 20),
      ],
    );
  }

  static pw.Widget buildLine() {
    return pw.Container(
      height: 1,
      width: Screen.width * 4,
      color: const PdfColor.fromInt(0xffD9D9D9),
    );
  }

  static pw.Widget buildDarkLine() {
    return pw.Container(
      height: 1,
      width: Screen.width * 4,
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
                color: const PdfColor.fromInt(0xff575757),
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

  static pw.Widget buildBoatDetails(Boat boat) {
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
                  'Captain : ${boat.captains?[0].name} ( ${getEmployee(boat.captains![0].id)?.phoneNumber} )',
                ),
              pw.SizedBox(height: 2),
              if (boat.captains != null && boat.captains?.length == 2)
                buildText(
                  'InCharge : ${boat.captains?[1].name} ( ${getEmployee(boat.captains![1].id)?.phoneNumber} )',
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
          // pw.SizedBox(
          //   width: 40,
          //   child: buildText('Id'),
          // ),
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
    String? bookingId,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 5, bottom: 5),
      child: pw.Row(
        children: [
          pw.SizedBox(
            width: 40,
            child: buildText('$index'),
          ),
          // pw.SizedBox(
          //   width: 40,
          //   child: buildText((bookingId != null) ? bookingId : '-'),
          // ),
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

  static pw.Widget _buildIDProofPhoto({
    required Customer customer,
  }) {
    List<String> urls = customer.idProof;
    final validUrls = urls.where((url) => url.trim().isNotEmpty).toList();
    log(validUrls.toString());
    if (validUrls.isNotEmpty) {
      return pw.SizedBox(
        height: 300,
        child: pw.Padding(
          padding: const pw.EdgeInsets.only(
            top: 5,
            bottom: 5,
          ),
          child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              buildText('${customer.name!.capitalizeFirst} :- ${customer.bookingId}'),
              pw.SizedBox(height: 20),
              pw.SizedBox(
                height: 250,
                width: 250,
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    for (final url in validUrls)
                      if (idProofs.containsKey(url))
                        pw.Padding(
                          padding: const pw.EdgeInsets.only(right: 10),
                          child: pw.Image(
                            idProofs[url]!,
                            height: 250,
                            width: 250,
                            fit: pw.BoxFit.fitHeight,
                          ),
                        ),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),
            ],
          ),
        ),
      );
    } else {
      return pw.SizedBox();
    }
  }

  static pw.Widget getDSDPAXCount(List<Booking>? bookings, Boat boat, DateTime selectedDate) {
    Iterable<Customer> totalCustomers = getCustomers(bookings ?? []);
    Iterable<Customer> dsdCustomers = totalCustomers.where((customer) => customer.course == 'DSD').toList();
    List<Instructor> staff = getInstructors(bookings ?? [], selectedDate);
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
              if ((boat.dsdInstructors ?? []).isNotEmpty) buildText('DSD Instructors : ${boat.dsdInstructors?.length}'),
              if (staff.isNotEmpty) buildText('Total Staff : ${staff.length + diveBuddies.length}'),
            ],
          ),
        ],
      ),
    );
  }
}

List<Instructor> getInstructors(List<Booking> bookings, DateTime selectedDate) {
  List<Instructor> instructors = [];
  try {
    for (var booking in bookings) {
      if ((booking.getInstructor(selectedDate)?.id != null)) {
        Employee? employee = getEmployee((booking.getInstructor(selectedDate)?.id));
        if (employee != null) {
          instructors.add(Instructor.fromEmployee(employee));
        } else {
          instructors.add((booking.getInstructor(selectedDate)!));
        }
      }
    }
  } catch (e) {
    log('Error running getInstructors: $e');
  }

  return instructors.toSet().toList();
}

List<Instructor> getDiveBuddies(List<Booking> bookings) {
  List<Instructor> diveBuddies = [];

  for (var booking in bookings) {
    diveBuddies.addAll(booking.boatDetails?.diveBuddies ?? []);
  }

  if (diveBuddies.isNotEmpty) {
    return diveBuddies.map((instructor) {
      return Instructor.fromEmployee(getEmployee(instructor.id)!);
    }).toList();
  } else {
    return [];
  }
}

List<Customer> getCustomers(List<Booking> bookings) {
  List<Customer> customers = [];

  for (var booking in bookings) {
    booking.pax?.forEach((person) {
      final id = (person['idProof'] as String?) ?? '';

      Customer customer = Customer(
        name: (person['first-name'] ?? '') + (person['last-name'] ?? ''),
        gender: person['gender'],
        country: person['country'],
        course: booking.activity?.firstOrNull?.shortName,
        idProof: id.split(','),
        bookingId: booking.id!,
        noOfPersons: booking.noOfPersons!,
      );
      customers.add(customer);
    });
  }

  return customers.toSet().toList();
}

Employee? getEmployee(String? id) {
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
  String bookingId;
  int noOfPersons;
  List<String> idProof;

  Customer({
    required this.name,
    required this.gender,
    required this.country,
    required this.idProof,
    required this.course,
    required this.bookingId,
    required this.noOfPersons,
  });

  @override
  bool operator ==(Object other) {
    return (other is Customer) && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;
}
