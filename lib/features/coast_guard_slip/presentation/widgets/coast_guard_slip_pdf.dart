import 'dart:io';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../boat/models/boats.dart';
import '../../../bookings/models/booking_model.dart';
import '../../../bookings/models/customer_model.dart';
import '../../../bookings/presentation/widgets/share_booking_details_widget.dart';

class CoastGuardSlip {
  static Future<File> generatePdf({
    required DateTime selectedDate,
    required List<Boat> boats,
    required List<Booking> allBookings,
  }) async {
    List<Booking> getBookings(String boatId) {
      List<Booking> bookings = allBookings.where((Booking booking) {
        return (booking.getBoatInfo(selectedDate)?.id == boatId);
      }).toList();
      return bookings;
    }

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
          ...boats.map(
            (boat) {
              return pw.Column(
                children: [
                  buildLine(),
                  pw.SizedBox(height: 25),
                  buildBoatDetails(boat),
                  buildLine(),
                  buildTitles(),
                  buildLine(),
                  pw.SizedBox(height: 25),
                  ...getBookings(boat.id).map((booking) => buildCustomerDetails(booking: booking, boat: boat)),
                  pw.SizedBox(height: 20),
                  buildLine(),
                ],
              );
            },
          ),
        ],
      ),
    );
    return ShareBookingDetails.saveDocument(name: 'coatGuardSlip.pdf', pdf: pdf);
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

  static pw.Widget buildCustomerDetails({required Booking booking, required Boat boat}) {
    pw.Widget buildText(String text) => pw.Text(
          text,
          textAlign: pw.TextAlign.center,
          style: pw.TextStyle(
            fontSize: 20,
            color: PdfColors.black,
            font: pw.Font.timesBold(),
          ),
        );

    return pw.Column(
      children: [
        ...(booking.pax?.sublist(1) ?? []).map(
          (e) {
            CustomerModel customer = CustomerModel.fromMap(e);
            return pw.Padding(
              padding: const pw.EdgeInsets.only(top: 5, bottom: 5),
              child: pw.Row(
                children: [
                  pw.SizedBox(
                    width: 100,
                    child: buildText('1'),
                  ),
                  pw.SizedBox(
                    width: 230,
                    child: buildText(customer.name),
                  ),
                  pw.SizedBox(
                    width: 170,
                    child: buildText(customer.gender ?? '-'),
                  ),
                  pw.SizedBox(
                    width: 170,
                    child: buildText(booking.activity?[0]?.name ?? '-'),
                  ),
                  pw.SizedBox(
                    width: 170,
                    child: buildText(customer.country ?? 'India'),
                  ),
                  pw.SizedBox(
                    width: 200,
                    child: buildText('${boat.name} - ${boat.time}'),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
